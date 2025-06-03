import 'dart:io';

import 'package:example_server/constants/constants.dart';
import 'package:example_server/handlers/handler.dart';
import 'package:example_server/service/storage_service.dart';
import 'package:example_server/utils/utils.dart';

class Server {
  Server({
    required this.port,
  });

  final int port;

  Future<void> run() async {
    await StorageService.instance.init();
    print('Database is ready');

    final server = await HttpServer.bind(InternetAddress.anyIPv6, port);
    print('Start server at port: $port');

    final handler = Handler();

    await server.forEach((HttpRequest request) async {
      // set default headers
      request.response.headers.add('Content-Type', 'application/json; charset=utf-8');

      final isHandled = await handler.handle(request);

      // handle default fallback
      if (!isHandled) {
        print('Request is not handled, returning badRequest to client');

        request.response
          ..statusCode = HttpStatus.badRequest
          ..add(Utils.encode(Constants.invalidRequest))
          ..close();
      }
    });
  }
}
