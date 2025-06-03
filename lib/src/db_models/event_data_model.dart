import 'package:hive/hive.dart';

import 'data_model.dart';

part 'event_data_model.g.dart';

@HiveType(typeId: 1)
enum EventStatus {
  @HiveField(0, defaultValue: true)
  pending,

  @HiveField(1)
  readyToSync,

  @HiveField(2)
  synced,

  @HiveField(3)
  failed,
}

@HiveType(typeId: 2)
class EventDataModel extends DatabaseModel {
  @HiveField(0)
  final String eventId;

  @HiveField(1)
  final String eventName;

  @HiveField(2)
  final Map<String, dynamic> payload;

  @HiveField(3)
  EventStatus status;

  EventDataModel({
    required this.eventId,
    required this.eventName,
    required this.payload,
    this.status = EventStatus.pending,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'payload': payload,
    };
  }
}
