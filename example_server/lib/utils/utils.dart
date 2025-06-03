import 'dart:convert';
import 'dart:typed_data';

class Utils {
  Utils._();

  static Uint8List encode(Map map) {
    return utf8.encode(jsonEncode(map));
  }
}
