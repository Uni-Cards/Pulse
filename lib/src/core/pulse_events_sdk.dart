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

import 'package:pulse_events_sdk/src/config/pulse_events_sdk_config.dart';

import '../interfaces/events_service.dart';
import '../interfaces/event_context.dart';
import '../services/frequency_sync_event_service/frequency_sync_event_service.dart';
import '../services/log/log.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.I;

class PulseEventsSdk {
  final EventContext eventContext;
  final String appId;
  final IEventsService _eventService;

  PulseEventsSdk({
    required this.appId,
    required this.eventContext,
  }) : _eventService = FrequencySyncEventService();

  Future<bool> init({
    required String baseUrl,
    required String configUrlEndpoint,
    required PulseEventsSdkConfig config,
    bool debugMode = false,
  }) async {
    // prepare logging
    Log.debugMode = debugMode;

    if (!getIt.isRegistered<PulseEventsSdkConfig>()) {
      getIt.registerSingleton<PulseEventsSdkConfig>(config);
    }

    // init event service
    return _eventService.init(
      eventContext: eventContext,
      appId: appId,
      baseUrl: baseUrl,
      configUrl: configUrlEndpoint,
      debugMode: debugMode,
    );
  }

  void setUserId(String userId) {
    _eventService.setUserId(userId: userId);
  }

  void refreshEventContext(EventContext eventContext) {
    _eventService.refreshEventContext(eventContext);
  }

  void trackEvent({
    required String eventName,
    required Map<String, dynamic> payload,
    int priority = 1,
  }) {
    _eventService.trackEvent(
      eventName: eventName,
      payload: payload,
      priority: priority,
    );
  }

  void logout() {
    _eventService.logout();
  }
}
