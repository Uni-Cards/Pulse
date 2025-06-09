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
