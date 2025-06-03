import 'package:mobile_events_sdk/mobile_events_sdk.dart';
import 'package:mobile_events_sdk/src/interfaces/event_context.dart';
import 'package:mobile_events_sdk/src/services/db/hive_database_service.dart';
import 'package:workmanager/workmanager.dart';

import '../../constants/constants.dart';
import '../../db_models/event_data_model.dart';
import '../../db_models/sdk_config_data_model.dart';
import '../../exceptions/internal_exceptions.dart';
import '../log/log.dart';
import '../network/dio_network_service.dart';
import '../utils/utils.dart';
import 'workers/single_task_worker.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  const tag = 'Background callback dispatcher';

  Workmanager().executeTask(
    (taskName, inputData) async {
      Log.i('$tag: $taskName is invoked with $inputData');
      if (inputData == null) throw BackgroundTaskInvokedWithEmptyInputData();

      // read from inputData
      final databaseId = inputData[BackgroundTaskConstants.databaseIdKey] as String;
      final baseUrl = inputData[BackgroundTaskConstants.baseUrlKey] as String;
      final eventPublishEndpoint = inputData[BackgroundTaskConstants.eventPublishEndpointKey] as String;
      final appAuthToken = inputData[BackgroundTaskConstants.appAuthTokenKey] as String;
      final deviceId = inputData[BackgroundTaskConstants.deviceIdKey] as String;
      final sessionId = inputData[BackgroundTaskConstants.sessionIdKey] as String;
      final debugMode = inputData[BackgroundTaskConstants.debugMode] as bool;
      final appType = inputData[BackgroundTaskConstants.appType] as String;

      // prepare database service
      final databaseService = HiveDatabaseService(
        databaseId: databaseId,
      );

      await databaseService.init();

      // initialize dlq worker
      final dlqWorker = DLQWorker(
        databaseService: databaseService,
        networkService: DioNetworkService(
          appType: appType,
          baseUrl: baseUrl,
          eventContext: EventContext(
            appAuthToken: appAuthToken,
            deviceId: deviceId,
            sessionId: sessionId,
          ),
        ),
      );

      // init core db entity & read the sdk config data model
      await databaseService.initEntity<SdkConfigDataModel>(entityId: Constants.coreDbEntityId);
      final sdkConfigDataModel = dlqWorker.databaseService.get<SdkConfigDataModel>(
        entityId: Constants.coreDbEntityId,
        key: Constants.coreDbEntitySdkConfigKey,
      );

      // process events from single task worker
      final prioritiesSet = (sdkConfigDataModel?.priorities ?? const <int>[]).toSet();

      // add miscellaneous event's priority
      final miscellaneousEventPriority = Utils.defaultEventPublishPolicy.priority;
      prioritiesSet.add(miscellaneousEventPriority);

      // in case of debugMode, add an event for invocation of background task
      // this event is to test out background tasks
      if (debugMode) {
        // prepare event logging

        final entityId = Utils.getEntityIdFor(priority: miscellaneousEventPriority);
        final backgroundTaskTriggeredEvent = Utils.generateBgTaskTriggeredEventWithPriority(
          miscellaneousEventPriority,
        );

        await databaseService.initEntity<EventDataModel>(entityId: entityId);

        // put the event in miscellaneous category
        await databaseService.put<EventDataModel>(
          entityId: entityId,
          key: backgroundTaskTriggeredEvent.eventId,
          data: backgroundTaskTriggeredEvent,
        );
      }

      Log.i('$tag: Invoking event processing for priorities: $prioritiesSet');

      return dlqWorker.processEventsFor(
        eventPriorities: prioritiesSet,
        eventPublishEndpoint: eventPublishEndpoint,
      );
    },
  );
}

class BackgroundWorker {
  static const tag = 'BackgroundWorker';

  final bool debugMode;
  final String baseUrl;
  final String appId;
  final String eventPublishEndpoint;
  final void Function(int? statusCode)? onIrreversibleError;

  BackgroundWorker({
    required this.debugMode,
    required this.baseUrl,
    required this.appId,
    required this.eventPublishEndpoint,
    this.onIrreversibleError,
  }) {
    _spawnWorker();
  }

  /// initializes a worker
  Future<void> _spawnWorker() {
    // register dispatcher
    return Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: debugMode,
    );
  }

  /// Registers a background worker,
  /// This method can be called multiple times, existing registered tasks would be replaced if called again
  ///
  /// [appAuthToken] can be null, in case the user is not logged in
  Future<void> registerTask({
    required EventContext eventContext,
  }) async {
    // if we don't have an active auth token, there is no point registering a background worker
    if (eventContext.appAuthToken == null) return;

    final inputData = <String, dynamic>{
      BackgroundTaskConstants.baseUrlKey: baseUrl,
      BackgroundTaskConstants.databaseIdKey: appId,
      BackgroundTaskConstants.eventPublishEndpointKey: eventPublishEndpoint,
      BackgroundTaskConstants.appAuthTokenKey: eventContext.appAuthToken,
      BackgroundTaskConstants.deviceIdKey: eventContext.deviceId,
      BackgroundTaskConstants.sessionIdKey: eventContext.sessionId,
      BackgroundTaskConstants.debugMode: debugMode,
      BackgroundTaskConstants.appType: appId,
    };

    try {
      // register one off task with following policies
      return Workmanager().registerOneOffTask(
        BackgroundTaskConstants.taskIdentifier,
        BackgroundTaskConstants.taskName,
        tag: BackgroundTaskConstants.taskTag,
        initialDelay: BackgroundTaskConstants.initialDelay,
        backoffPolicyDelay: BackgroundTaskConstants.backOffPolicyDelay,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        backoffPolicy: BackoffPolicy.linear,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        inputData: inputData,
      );
    } catch (e) {
      Log.e('$tag: ${BackgroundTaskConstants.taskIdentifier} failed to register one off task with error: $e');
    }
  }
}
