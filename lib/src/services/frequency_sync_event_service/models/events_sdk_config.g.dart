// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_sdk_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsSdkProcessingPolicy _$EventsSdkConfigFromJson(Map<String, dynamic> json) => EventsSdkProcessingPolicy(
      isEnabled: json['isEnabled'] as bool? ?? false,
      eventPublishEndpoint: json['eventPublishEndpoint'] as String,
      priorities: (json['priorities'] as List<dynamic>?)
              ?.map((e) => EventProcessingPolicy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
