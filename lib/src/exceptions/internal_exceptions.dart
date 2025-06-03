import '../db_models/event_data_model.dart';

abstract class MobileEventsInternalExceptions implements Exception {}

class NothingToSync extends MobileEventsInternalExceptions {
  final EventStatus eventStatus;
  NothingToSync(this.eventStatus);
}

class TooManyEventsToSync extends MobileEventsInternalExceptions {
  final int size;
  TooManyEventsToSync(this.size);
}

class AllSyncInvokedOnActiveWorker extends MobileEventsInternalExceptions {}

class BackgroundTaskInvokedWithEmptyInputData extends MobileEventsInternalExceptions {}
