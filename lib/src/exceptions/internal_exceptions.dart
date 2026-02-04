// Copyright 2025 Pulse Events SDK Contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import '../db_models/event_data_model.dart';

abstract class PulseEventsInternalExceptions implements Exception {
  final String message;
  final String? code;

  /// Static callback for reporting internal exceptions to external monitoring
  static Function(String message, dynamic error, StackTrace? stackTrace)? onInternalError;

  PulseEventsInternalExceptions(this.message, {this.code}) {
    // Automatically report critical internal exceptions to external monitoring
    onInternalError?.call('Internal SDK Exception: $message', this, StackTrace.current);
  }

  @override
  String toString() => 'PulseEventsInternalException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NothingToSync extends PulseEventsInternalExceptions {
  final EventStatus eventStatus;
  NothingToSync(this.eventStatus) : super('No events found to sync for status: $eventStatus', code: 'NOTHING_TO_SYNC');
}

class TooManyEventsToSync extends PulseEventsInternalExceptions {
  final int size;
  TooManyEventsToSync(this.size) : super('Too many events to sync: $size', code: 'TOO_MANY_EVENTS');
}

class AllSyncInvokedOnActiveWorker extends PulseEventsInternalExceptions {
  AllSyncInvokedOnActiveWorker() : super('Cannot invoke sync all on active worker', code: 'SYNC_ON_ACTIVE_WORKER');
}

class BackgroundTaskInvokedWithEmptyInputData extends PulseEventsInternalExceptions {
  BackgroundTaskInvokedWithEmptyInputData()
      : super('Background task invoked with empty input data', code: 'EMPTY_BACKGROUND_DATA');
}

class DatabaseCorruptionException extends PulseEventsInternalExceptions {
  final String entityId;
  DatabaseCorruptionException(this.entityId)
      : super('Database corruption detected for entity: $entityId', code: 'DATABASE_CORRUPTION');
}

class LockAcquisitionTimeoutException extends PulseEventsInternalExceptions {
  final String lockName;
  final Duration timeout;
  LockAcquisitionTimeoutException(this.lockName, this.timeout)
      : super('Failed to acquire lock "$lockName" within ${timeout.inSeconds}s', code: 'LOCK_TIMEOUT');
}

class WorkerStateException extends PulseEventsInternalExceptions {
  final String workerTag;
  final String expectedState;
  final String actualState;
  WorkerStateException(this.workerTag, this.expectedState, this.actualState)
      : super('Worker $workerTag expected to be in $expectedState state but was in $actualState',
            code: 'INVALID_WORKER_STATE');
}

class EventProcessingException extends PulseEventsInternalExceptions {
  final String eventId;
  final dynamic originalError;
  EventProcessingException(this.eventId, this.originalError)
      : super('Failed to process event $eventId: $originalError', code: 'EVENT_PROCESSING_FAILED');
}

class ConfigurationMismatchException extends PulseEventsInternalExceptions {
  final String field;
  final dynamic expected;
  final dynamic actual;
  ConfigurationMismatchException(this.field, this.expected, this.actual)
      : super('Configuration mismatch for $field: expected $expected, got $actual', code: 'CONFIG_MISMATCH');
}
