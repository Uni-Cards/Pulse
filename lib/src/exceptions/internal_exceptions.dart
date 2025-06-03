import '../db_models/event_data_model.dart';

abstract class PulseEventsInternalExceptions implements Exception {}

class NothingToSync extends PulseEventsInternalExceptions {
  final EventStatus eventStatus;
  NothingToSync(this.eventStatus);
}

class TooManyEventsToSync extends PulseEventsInternalExceptions {
  final int size;
  TooManyEventsToSync(this.size);
}

class AllSyncInvokedOnActiveWorker extends PulseEventsInternalExceptions {}

class BackgroundTaskInvokedWithEmptyInputData extends PulseEventsInternalExceptions {}
