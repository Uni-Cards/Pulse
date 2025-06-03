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
