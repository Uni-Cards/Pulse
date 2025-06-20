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

import '../../db_models/data_model.dart';

abstract class IDatabaseService {
  /// Prepares the database service to start interactions
  Future<void> init();

  /// Initializes an entity for read/write,
  /// it's an async process as it creates necessary files in disk
  Future<void> initEntity<T extends DatabaseModel>({required String entityId});

  /// Put [T] into an entity (using [key])
  Future<void> put<T extends DatabaseModel>({
    required String entityId,
    required String key,
    required T data,
  });

  /// Put multiple [T] into an entity, best for batch writing [T] types
  /// batch writing may be needed when bulk editing multiple [T]'s states
  Future<void> putAll<T extends DatabaseModel>({
    required String entityId,
    required Map<String, T> entries,
  });

  /// Returns back a single [T] (using [key]) from an entity
  T? get<T extends DatabaseModel>({
    required String entityId,
    required String key,
  });

  /// Returns back all [T]s in an entity
  Iterable<T> getAll<T extends DatabaseModel>({required String entityId});

  /// Delete all [keys] in an entity, this is better for batch deleting all [T]s
  Future<void> deleteAll<T extends DatabaseModel>({required String entityId, required Iterable<String> keys});

  /// Flush makes sure uncommited changes in memory are written to the disk immediately
  Future<void> flush<T extends DatabaseModel>({required String entityId});

  /// WARING: deleting an entity could be dangerous - avoid deleting
  Future<void> deleteEntity({required String entityId});
}
