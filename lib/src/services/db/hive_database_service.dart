// ignore: implementation_imports
import 'package:hive/src/hive_impl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../db_models/data_model.dart';
import '../../db_models/event_data_model.dart';
import '../../db_models/sdk_config_data_model.dart';
import '../../services/log/log.dart';
import '../interfaces/database_service.dart';

class HiveDatabaseService implements IDatabaseService {
  static const tag = 'HiveDatabaseService';

  static const baseDirectory = 'events-sdk';

  final HiveImpl hive;
  final String databaseId;

  HiveDatabaseService({
    required this.databaseId,
  }) : hive = HiveImpl();

  @override
  Future<void> init() async {
    if (!hive.isAdapterRegistered(1)) {
      hive.registerAdapter<EventStatus>(EventStatusAdapter());
    }
    if (!hive.isAdapterRegistered(2)) {
      hive.registerAdapter<EventDataModel>(EventDataModelAdapter());
    }
    if (!hive.isAdapterRegistered(3)) {
      hive.registerAdapter<SdkConfigDataModel>(SdkConfigDataModelAdapter());
    }
    // register data model adapters

    final applicationSupportDirectory = await path_provider.getApplicationSupportDirectory();
    return hive.init(path.join(applicationSupportDirectory.path, baseDirectory));
  }

  @override
  Future<void> initEntity<T extends DatabaseModel>({required String entityId}) async {
    if (hive.isBoxOpen(entityId)) {
      return Log.i('$tag: Hive box $entityId is already open, ignoring the initEntity(...) call');
    }

    await hive.openBox<T>(entityId);
  }

  @override
  Future<void> deleteEntity({required String entityId}) async {
    /// Avoid deleting an entity, as read and write (if needed later) would fail
    /// entities doesn't take much space in disk.
    ///
    /// If it's not in use, this entity won't be holding any data - space isn't an issue.

    // return hive.deleteBoxFromDisk(entityId);
    return;
  }

  @override
  Future<void> flush<T extends DatabaseModel>({required String entityId}) {
    return hive.box<T>(entityId).flush();
  }

  @override
  T? get<T extends DatabaseModel>({required String entityId, required String key}) {
    return hive.box<T>(entityId).get(key);
  }

  @override
  Iterable<T> getAll<T extends DatabaseModel>({required String entityId}) {
    return hive.box<T>(entityId).values;
  }

  @override
  Future<void> put<T extends DatabaseModel>({required String entityId, required String key, required T data}) {
    return hive.box<T>(entityId).put(key, data);
  }

  @override
  Future<void> putAll<T extends DatabaseModel>({required String entityId, required Map<String, T> entries}) {
    return hive.box<T>(entityId).putAll(entries);
  }

  @override
  Future<void> deleteAll<T extends DatabaseModel>({required String entityId, required Iterable<String> keys}) {
    return hive.box<T>(entityId).deleteAll(keys);
  }
}
