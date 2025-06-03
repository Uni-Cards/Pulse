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
  });
}
