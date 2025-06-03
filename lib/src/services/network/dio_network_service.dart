import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:mobile_events_sdk/src/constants/constants.dart';

import '../../interfaces/event_context.dart';
import '../interfaces/network_service.dart';
import '../log/log.dart';

typedef DioNetworkServiceType = INetworkService<dio.Response?>;

class DioNetworkService implements DioNetworkServiceType {
  static const tag = 'DioNetworkService';

  final String appType;
  final String baseUrl;
  final EventContext eventContext;
  final dio.Dio _dio;

  DioNetworkService({
    required this.appType,
    required this.baseUrl,
    required this.eventContext,
  }) : _dio = dio.Dio()
          ..options = dio.BaseOptions(
            validateStatus: (statusCode) {
              if (statusCode == null) return false;
              return (200 <= statusCode && statusCode < 300) || statusCode == HttpStatus.unauthorized;
            },
          )
          ..interceptors.add(
            _Interceptor(
              eventContext: eventContext,
              appType: appType,
            ),
          );

  @override
  Future<dio.Response?> get(String endpoint) async {
    Log.i('$tag: get(...) request with endpoint: $endpoint');

    try {
      final response = await _dio.get('$baseUrl$endpoint');

      Log.i('$tag: get(...) at endpoint: $endpoint returned response: $response');

      return response;
    } on dio.DioException catch (error) {
      Log.e('$tag: get(...) at endpoint: $endpoint returned error: $error');
      return error.response;
    }
  }

  @override
  Future<dio.Response?> post(
    String endpoint,
    Map<String, dynamic> body, {
    dio.CancelToken? cancelToken,
  }) async {
    // post request must require an authentication token
    if (eventContext.appAuthToken == null) return null;

    Log.i('$tag: post(...) request with endpoint: $endpoint');

    try {
      final response = await _dio.post('$baseUrl$endpoint', data: body, cancelToken: cancelToken);

      Log.i('$tag: post(...) at endpoint: $endpoint returned response: $response');

      return response;
    } on dio.DioException catch (error) {
      Log.e('$tag: post(...) at endpoint: $endpoint threw error: $error');
      return error.response;
    }
  }
}

class _Interceptor extends dio.Interceptor {
  final EventContext eventContext;
  final String appType;

  _Interceptor({
    required this.eventContext,
    required this.appType,
  });

  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    final userAgent = '$appType MobileEventsSdk/${Constants.sdkVersion}($_osType; deviceId=${eventContext.deviceId})';

    options.headers.addAll({
      'Content-Type': 'application/json',
      'os-type': _osType,
      'appType': appType,
      'User-Agent': userAgent,
      'device-id': eventContext.deviceId,
      'session-id': eventContext.sessionId,
      'Authorization': eventContext.appAuthToken,
    });

    if (eventContext.networkHeaders != null) {
      options.headers.addAll(eventContext.networkHeaders!);
    }

    super.onRequest(options, handler);
  }

  String get _osType => (Platform.isIOS ? 'iOS' : 'Android').toUpperCase();
}
