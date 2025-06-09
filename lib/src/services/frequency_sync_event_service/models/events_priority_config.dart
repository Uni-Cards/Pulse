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

part 'events_priority_config.g.dart';

@JsonSerializable(createToJson: false)
class EventProcessingPolicy {
  final int priority;
  final BatchProcessingConfig configuration;

  const EventProcessingPolicy({
    required this.priority,
    required this.configuration,
  });

  factory EventProcessingPolicy.fromJson(Map<String, dynamic> json) => _$EventProcessingPolicyFromJson(json);
}

@JsonSerializable(createToJson: false)
class BatchProcessingConfig {
  final int batchSize;
  final int frequencyInSec;

  const BatchProcessingConfig({
    required this.batchSize,
    required this.frequencyInSec,
  });

  factory BatchProcessingConfig.fromJson(Map<String, dynamic> json) => _$BatchProcessingConfigFromJson(json);
}
