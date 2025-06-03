import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static const kBaseUrl = 'base-url';
  static const kConfigureEndpoint = 'configure-endpoint';

  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // base url
  String? get baseUrl => _sharedPreferences?.getString(kBaseUrl);
  set baseUrl(String? url) {
    if (url != null) _sharedPreferences?.setString(kBaseUrl, url);
  }

  // configure endpoint
  String? get configureEndPoint => _sharedPreferences?.getString(kConfigureEndpoint);
  set configureEndPoint(String? endpoint) {
    if (endpoint != null) _sharedPreferences?.setString(kConfigureEndpoint, endpoint);
  }
}
