import 'package:dio/dio.dart';

abstract class INetworkService<T> {
  Future<T> get(String endpoint);
  Future<T> post(
    String endpoint,
    Map<String, dynamic> body, {
    CancelToken? cancelToken,
  });
}
