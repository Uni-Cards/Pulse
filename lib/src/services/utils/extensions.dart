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

import 'package:dio/dio.dart' as dio;

extension ResponseX on dio.Response? {
  Map<String, dynamic> get dataMap {
    final map = this;

    if (map == null || map.data == null || map.data is! Map<String, dynamic>) {
      return {};
    }

    return Map<String, dynamic>.from(map.data);
  }
}

extension IterToolsExtension<T> on Iterable<T> {
  List<List<T>> foldBy(int split) {
    final k = <List<T>>[];
    var tmp = <T>[];

    for (final item in this) {
      tmp.add(item);
      if (tmp.length == split) {
        k.add(tmp);
        tmp = <T>[];
      }
    }

    if (tmp.isNotEmpty) {
      k.add(tmp);
    }

    return k;
  }
}
