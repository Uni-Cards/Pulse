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
