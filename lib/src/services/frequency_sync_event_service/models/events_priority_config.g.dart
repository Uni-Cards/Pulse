// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_priority_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventProcessingPolicy _$EventProcessingPolicyFromJson(Map<String, dynamic> json) => EventProcessingPolicy(
      priority: (json['priority'] as num).toInt(),
      configuration: BatchProcessingConfig.fromJson(json['configuration'] as Map<String, dynamic>),
    );

BatchProcessingConfig _$BatchProcessingConfigFromJson(Map<String, dynamic> json) => BatchProcessingConfig(
      batchSize: (json['batchSize'] as num).toInt(),
      frequencyInSec: (json['frequencyInSec'] as num).toInt(),
    );
