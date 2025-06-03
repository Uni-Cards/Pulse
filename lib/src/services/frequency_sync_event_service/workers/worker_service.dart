import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_events_sdk/mobile_events_sdk.dart';
import 'package:mobile_events_sdk/src/services/network/dio_network_service.dart';
import 'package:mobile_events_sdk/src/services/utils/extensions.dart';

import '../../../db_models/event_data_model.dart';
import '../../../exceptions/internal_exceptions.dart';
import '../../log/log.dart';
import '../../utils/utils.dart';
import '../models/event_sync_result.dart';

class WorkerService {
  final String tag;
  final void Function(int?)? onIrreversibleError;
  bool _hasHalted = false;
  CancelToken _cancelToken = CancelToken();

  WorkerService(
    String tag, {
    this.onIrreversibleError,
  }) : tag = '$tag: [WorkerService]';

  /// Makes network call to server to sync [eventsToSync] events.
  /// The network call is timed out after [MobileEventsSdkConfig.eventSyncNetworkTimeout] duration.
  ///
  /// No matter how many events were passed in [eventsToSync],
  /// this method respects the [MobileEventsSdkConfig.largestBatchSize] while doing the network call
  /// Multiple parallel network calls could be made internally, each request with the allowed max batch size
  ///
  /// If [retry] is true,
  /// each sync network calls are retried upto a max of [MobileEventsSdkConfig.syncMaxRetry] times before returning a result and,
  /// each retries are spaced out by [MobileEventsSdkConfig.syncRetryDelayDuration] duration
  ///
  /// Returns the success and failure events
  Future<EventSyncResult> syncToServer({
    required String eventPublishEndpoint,
    required Iterable<EventDataModel> eventsToSync,
    bool retry = false,
  }) async {
    final syncToServerId = Utils.shortUid;

    Log.i('$tag: syncToServer($syncToServerId) invoked with ${eventsToSync.length} events, and with retry: $retry');

    /// Split [eventsToSync] into chunks of [maxBatchSize] elements
    final eventsBatches = eventsToSync.foldBy(getIt<MobileEventsSdkConfig>().largestBatchSize);

    Log.i('$tag: syncToServer($syncToServerId) created ${eventsBatches.length} batches, starting parallel sync');

    // start syncing all batches simultaneously
    final futures = <Future<EventSyncResult>>[];

    for (final batch in eventsBatches) {
      futures.add(
        _batchSyncResult(
          logId: syncToServerId,
          eventPublishEndpoint: eventPublishEndpoint,
          batch: batch,
          retry: retry,
        ),
      );
    }

    final results = <EventSyncResult>[];

    // wait for all batches' network call to finish
    // final eventSyncResults = await Future.wait(futures);
    for (final future in futures) {
      if (_hasHalted) break;
      results.add(await future);
    }

    if (_hasHalted) {
      return EventSyncResult.halted();
    }

    final eventSyncResult = EventSyncResult.merge(results);

    Log.i('$tag: syncToServer($syncToServerId) resulted in eventSyncResult: $eventSyncResult');

    return eventSyncResult;
  }

  /// Make sure [eventsToSync] has max of [MobileEventsSdkConfig.largestBatchSize] events, otherwise
  /// this method would throw [TooManyEventsToSync] exception
  ///
  /// [retry] determines if multiple retries would be made
  /// [retryCount] is the current retried no
  Future<EventSyncResult> _batchSyncResult({
    required String logId,
    required String eventPublishEndpoint,
    required Iterable<EventDataModel> batch,
    bool retry = false,
    int retryCount = 1,
  }) async {
    if (_hasHalted) return EventSyncResult.halted();
    final config = getIt<MobileEventsSdkConfig>();

    // validate batch size
    if (batch.length > config.largestBatchSize) throw TooManyEventsToSync(batch.length);

    Log.i(
      '$tag: _syncEventsForABatch($logId) invoked for ${batch.length} events, with retry: $retry, retryCount: $retryCount',
    );

    try {
      // do a network call to sync events - and wait till timeout duration
      final response = await getIt<DioNetworkServiceType>()
          .post(
            eventPublishEndpoint,
            {
              "events": batch.map((e) => e.toJson()).toList(),
            },
            cancelToken: _cancelToken,
          )
          .timeout(config.eventSyncNetworkTimeout);

      final statusCode = response?.statusCode;

      if (_shouldHaltWorker(response?.statusCode)) {
        _hasHalted = true;
        _cancelToken.cancel("events sync halted");
        Log.e('$tag: Irreversible error detected (status: $statusCode). Halting worker and cancelling further syncs.');

        onIrreversibleError?.call(response?.statusCode);
        return EventSyncResult.halted();
      }

      // if syncing was successful, mark the events as `synced` otherwise mark as `failed`
      if (statusCode == HttpStatus.ok) {
        Log.i('$tag: _syncEventsForABatch($logId) succeeded with response: $response');
        return EventSyncResult.success(batch.toList());
      }

      Log.i('$tag: _syncEventsForABatch($logId) failed with response: $response');
    } on TimeoutException catch (e) {
      Log.e('$tag: _syncEventsForABatch($logId) failed due to timeout error: $e');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        Log.e('$tag: Sync cancelled due to halt');
        return EventSyncResult.halted();
      }
    } catch (e) {
      Log.e('$tag: _syncEventsForABatch($logId) failed due to error: $e');
    }

    // if retry is false, or we have reached max retry count, return back syncFailed state
    if (_hasHalted || retry == false || retryCount == config.syncMaxRetry) {
      return EventSyncResult.failed(batch.toList());
    }

    Log.i('$tag: _syncEventsForABatch($logId) has failed events, a retry would happen');

    // delay the next retry
    await Future.delayed(config.syncRetryDelayDuration);

    if (_hasHalted) {
      return EventSyncResult.halted();
    }

    // otherwise, keep retrying
    return _batchSyncResult(
      logId: logId,
      eventPublishEndpoint: eventPublishEndpoint,
      batch: batch,
      retry: retry,
      retryCount: retryCount + 1,
    );
  }

  bool _shouldHaltWorker(int? statusCode) {
    return statusCode == 401 || statusCode == 403;
  }

  void restart() {
    _hasHalted = false;
    _cancelToken = CancelToken();
  }
}
