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

import '../exceptions/pulse_events_exceptions.dart';

abstract class IEventContext {
  String? get appAuthToken;
  String get deviceId;
  String get sessionId;
  Map<String, dynamic>? get networkHeaders;
}

class EventContext implements IEventContext {
  @override
  final String? appAuthToken;

  @override
  final String deviceId;

  @override
  final String sessionId;

  @override
  final Map<String, dynamic>? networkHeaders;

  EventContext({
    required this.appAuthToken,
    required this.deviceId,
    required this.sessionId,
    this.networkHeaders,
  }) {
    _validate();
  }

  /// Validates the event context parameters - only check null/empty
  void _validate() {
    if (deviceId.isEmpty) {
      throw InvalidEventContext('Device ID cannot be empty');
    }
    
    if (sessionId.isEmpty) {
      throw InvalidEventContext('Session ID cannot be empty');
    }
    
    // Validate auth token if provided
    if (appAuthToken != null && appAuthToken!.isEmpty) {
      throw InvalidEventContext('Auth token cannot be empty if provided');
    }
  }
  
  /// Creates a copy of the event context with updated values
  EventContext copyWith({
    String? appAuthToken,
    String? deviceId,
    String? sessionId,
    Map<String, dynamic>? networkHeaders,
  }) {
    return EventContext(
      appAuthToken: appAuthToken ?? this.appAuthToken,
      deviceId: deviceId ?? this.deviceId,
      sessionId: sessionId ?? this.sessionId,
      networkHeaders: networkHeaders ?? this.networkHeaders,
    );
  }
  
  @override
  String toString() {
    return 'EventContext(deviceId: $deviceId, sessionId: $sessionId, hasAuthToken: ${appAuthToken != null}, headerCount: ${networkHeaders?.length ?? 0})';
  }
}
