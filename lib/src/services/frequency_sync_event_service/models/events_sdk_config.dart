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

import 'package:json_annotation/json_annotation.dart';

import 'events_priority_config.dart';

part 'events_sdk_config.g.dart';

@JsonSerializable(createToJson: false)
class EventsSdkProcessingPolicy {
  final bool isEnabled;
  final String eventPublishEndpoint;
  final List<EventProcessingPolicy> priorities;

  EventsSdkProcessingPolicy({
    this.isEnabled = false,
    required this.eventPublishEndpoint,
    this.priorities = const [],
  });

  factory EventsSdkProcessingPolicy.fromJson(Map<String, dynamic> json) => _$EventsSdkConfigFromJson(json);
}
