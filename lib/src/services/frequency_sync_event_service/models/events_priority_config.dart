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
