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

import 'dart:io';
import 'dart:math' as math;

import 'package:uuid/uuid.dart';

import '../../constants/constants.dart';
import '../../db_models/event_data_model.dart';
import '../frequency_sync_event_service/models/events_priority_config.dart';
import '../log/log.dart';

class Utils {
  static const tag = 'Utils';
  static const _uuid = Uuid();
  static final _rnd = math.Random();

  Utils._();

  static const defaultEventPublishPolicy = EventProcessingPolicy(
    priority: -1,
    configuration: BatchProcessingConfig(
      batchSize: 50,
      frequencyInSec: 100,
    ),
  );

  /// Only simple primitive data types are allowed
  /// Refer here for primitive data types supported in Dart: https://dart.dev/language/built-in-types
  static bool isTypeAllowed(Type type) {
    // Numbers (int, double)
    if (type == int || type == double) return true;

    // Strings (String)
    if (type == String) return true;

    // Booleans (bool)
    if (type == bool) return true;

    // null (Null)
    if (type == Null) return true;

    Log.i('$tag: type: $type is ignored and will NOT be included in the payload attribute');

    return false;
  }

  static String generateEventId() => _uuid.v8();

  static String getEntityIdFor({required int priority}) => '$priority-worker-db';

  static const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  static const _shortUidLength = 8;
  static String get shortUid => String.fromCharCodes(
        Iterable.generate(_shortUidLength, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))),
      );

  /// The [payload] is iterated through and only supported types are kept, check [Utils.isTypeAllowed] to know more.
  /// Default payloads are added as well.
  static Map<String, dynamic> prepareEventPayloadFrom({
    required Map<String, dynamic> payload,
    required int eventPriority,
  }) {
    final preparedPayload = Map.fromEntries(
      payload.entries.where((e) => Utils.isTypeAllowed(e.value.runtimeType)),
    );

    return {
      ...preparedPayload,

      // add default payloads
      EventKeyConstants.eventTime: DateTime.now().toString(),
      EventKeyConstants.eventPriority: eventPriority,
      EventKeyConstants.eventSdkVersion: Constants.sdkVersion,
    };
  }

  // helper events
  static EventDataModel generateBgTaskTriggeredEventWithPriority(int priority) {
    return EventDataModel(
      eventId: Utils.generateEventId(),
      eventName: BackgroundTaskConstants.debugBackgroundTaskEventName,
      payload: Utils.prepareEventPayloadFrom(
        payload: {
          BackgroundTaskConstants.eventPayloadOS: Platform.operatingSystem,
          BackgroundTaskConstants.eventPayloadOSVersion: Platform.operatingSystemVersion,
        },
        eventPriority: priority,
      ),
    );
  }
}
