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
    return true;
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
    // Deep-convert to JSON-safe structure so Hive never receives custom objects
    final dynamic sanitizedDynamic = sanitizeForJson(payload);
    final Map<String, dynamic> sanitized =
        sanitizedDynamic is Map<String, dynamic> ? sanitizedDynamic : <String, dynamic>{};

    return {
      ...sanitized,

      // add default payloads
      EventKeyConstants.eventTime: DateTime.now().toString(),
      EventKeyConstants.eventPriority: eventPriority,
      EventKeyConstants.eventSdkVersion: Constants.sdkVersion,
    };
  }

  /// Recursively converts any Dart object to JSON-safe primitives:
  /// - null, num, String, bool are kept as-is
  /// - DateTime -> ISO8601 string
  /// - Uri -> string
  /// - Iterable -> List with elements sanitized
  /// - Map -> Map<String, dynamic> with values sanitized; non-string keys are stringified
  /// - Objects with toJson() -> sanitize result of toJson()
  /// - Fallback -> value.toString()
  static dynamic sanitizeForJson(dynamic value) {
    if (value == null || value is num || value is String || value is bool) return value;
    if (value is DateTime) return value.toIso8601String();
    if (value is Uri) return value.toString();

    if (value is Iterable) {
      return value.map((e) => sanitizeForJson(e)).toList();
    }

    if (value is Map) {
      final result = <String, dynamic>{};
      value.forEach((key, val) {
        final String stringKey = key is String ? key : key?.toString() ?? '';
        result[stringKey] = sanitizeForJson(val);
      });
      return result;
    }

    // Attempt to use toJson if available
    try {
      final dynamic jsonValue = (value as dynamic).toJson();
      return sanitizeForJson(jsonValue);
    } catch (_) {
      // ignore and fallback below
    }

    // Byte arrays are fine in JSON as int lists
    if (value is List<int>) return value;

    // Fallback to string representation
    return value.toString();
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
