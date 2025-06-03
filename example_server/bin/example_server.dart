import 'package:example_server/server.dart' as example_server;

const kPort = 8444;

void main(List<String> arguments) async {
  await example_server.Server(
    port: kPort,
  ).run();
}
