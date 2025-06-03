import '../../../db_models/event_data_model.dart';

enum EventSyncState { failed, succeeded, partial, halted }

class EventSyncResult {
  final List<EventDataModel> failed;
  final List<EventDataModel> succeeded;
  final EventSyncState state;

  EventSyncResult({
    this.succeeded = const [],
    this.failed = const [],
    required this.state,
  });

  int get succeededNo => succeeded.length;
  int get failedNo => failed.length;

  bool get hasAtleastOneSucceeded => succeededNo != 0;
  bool get hasAllSucceeded => failedNo == 0;

  bool get isSuccess => failed.isEmpty;
  bool get isHalted => state == EventSyncState.halted;

  factory EventSyncResult.success(List<EventDataModel> succeeded) {
    return EventSyncResult(succeeded: succeeded, state: EventSyncState.succeeded);
  }

  factory EventSyncResult.failed(List<EventDataModel> failed) {
    return EventSyncResult(failed: failed, state: EventSyncState.failed);
  }

  factory EventSyncResult.halted() {
    return EventSyncResult(state: EventSyncState.halted);
  }

  static EventSyncResult merge(List<EventSyncResult> results) {
    final succeeded = <EventDataModel>[];
    final failed = <EventDataModel>[];

    for (final result in results) {
      succeeded.addAll(result.succeeded);
      failed.addAll(result.failed);
    }

    return EventSyncResult(
      succeeded: succeeded,
      failed: failed,
      state: failed.isEmpty
          ? EventSyncState.succeeded
          : succeeded.isEmpty
              ? EventSyncState.failed
              : EventSyncState.partial,
    );
  }

  @override
  String toString() {
    return 'EventSyncResult(succeeded: $succeededNo, failed: $failedNo)';
  }
}

class SingularEventSyncResult {
  final int priority;
  final bool isSyncSuccessful;

  SingularEventSyncResult({
    required this.priority,
    required this.isSyncSuccessful,
  });

  @override
  String toString() {
    return 'SingularEventSyncStatus(priority: $priority, isSyncSuccessful: $isSyncSuccessful)';
  }
}
