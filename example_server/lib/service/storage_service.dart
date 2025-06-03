import 'package:hive/hive.dart';

const kBoxName = 'events-box';

class StorageService {
  StorageService._();

  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  late Box<Map> _box;

  Future<void> init() async {
    Hive.init('./.db');
    _box = await Hive.openBox<Map>(kBoxName);
  }

  Future<void> addAllEvents(Iterable<Map> events) async {
    await _box.addAll(events);
  }

  Iterable<Map> getAllEvents() {
    return _box.values;
  }

  Future<int> deleteAllEvents() {
    return _box.clear();
  }
}
