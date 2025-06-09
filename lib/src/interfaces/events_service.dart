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

import 'event_context.dart';

abstract class IEventsService {
  /// Initialization of the SDK - prepares the service to accept events
  Future<bool> init({
    required String baseUrl,
    required String configUrl,
    required String appId,
    required EventContext eventContext,
    bool debugMode = false,
  });

  /// Sets the [userId] property, which is tagged to every recorded event, to attribute event to an user
  void setUserId({
    required String userId,
  });

  void refreshEventContext(EventContext eventContext);

  /// Tracks an event with [eventName] name and [payload] as attributes of the events.
  /// [priority] determines how frequent the local events are sycned in the backend.
  /// Lower values are treated as higher priority.
  /// Accepted ranges of priority is [0, INT_MAX]. 0 being the hightest priority.
  void trackEvent({
    required String eventName,
    required Map<String, dynamic> payload,
    int? priority,
  });

  /// Marks the current set user id as logged out, and new events recorded are treated as anynomous user's events
  void logout();
}
