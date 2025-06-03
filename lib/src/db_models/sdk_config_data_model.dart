import 'package:hive/hive.dart';

import 'data_model.dart';

part 'sdk_config_data_model.g.dart';

@HiveType(typeId: 3)
class SdkConfigDataModel extends DatabaseModel {
  @HiveField(0)
  final String eventPublishEndpoint;

  @HiveField(1)
  final List<int> priorities;

  @HiveField(2)
  final bool isEnabled;

  SdkConfigDataModel({
    required this.eventPublishEndpoint,
    required this.priorities,
    required this.isEnabled,
  });
}
