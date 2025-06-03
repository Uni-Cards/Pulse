import 'dart:convert';
import 'dart:io';

import 'package:example_server/constants/constants.dart';
import 'package:example_server/service/storage_service.dart';
import 'package:example_server/utils/utils.dart';

// endpoints
const kEventsConfigUri = '/events-config';
const kEventsUri = '/v1/events';

// methods
const kGetMethod = 'GET';
const kPostMethod = 'POST';
const kDeleteMethod = 'DELETE';

// keys
const kEventsKey = 'events';
const kAuthorizationKey = 'Authorization';

class Handler {
  static const tag = 'Handler';

  Future<bool> handle(HttpRequest request) async {
    final uri = request.uri.path;
    final method = request.method;

    print('$tag: [$uri, method: $method]');

    try {
      // get events config
      if (uri == kEventsConfigUri && method == kGetMethod) {
        handleGetEventsConfig(request);
        return true;
      }

      // events
      if (uri == kEventsUri) {
        if (method == kPostMethod) {
          // post events
          await handlePostEvents(request);
          return true;
        } else if (method == kGetMethod) {
          // get events
          await handleGetEvents(request);
          return true;
        } else if (method == kDeleteMethod) {
          await handleDeleteEvents(request);
          return true;
        }
      }
    } catch (e) {
      print('$tag: caught error: $e');
      handleError(request, e);
      return true;
    }

    return false;
  }

  void handleGetEventsConfig(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..add(Utils.encode(Constants.eventsConfig))
      ..close();
  }

  handleDeleteEvents(HttpRequest request) async {
    final noOfDeletedEvents = await StorageService.instance.deleteAllEvents();

    if (noOfDeletedEvents == 0) {
      request.response
        ..statusCode = HttpStatus.ok
        ..add(Utils.encode(Constants.nothingToDelete))
        ..close();
      return;
    }

    request.response
      ..statusCode = HttpStatus.ok
      ..add(Utils.encode(Constants.eventsDeleted(noOfEvents: noOfDeletedEvents)))
      ..close();
  }

  Future<void> handlePostEvents(HttpRequest request) async {
    // check for authentication
    final authHeader = request.headers.value(kAuthorizationKey);
    if (authHeader != Constants.authToken) {
      request.response
        ..statusCode = HttpStatus.unauthorized
        ..add(Utils.encode(Constants.unauthorized))
        ..close();

      return;
    }

    final content = await utf8.decoder.bind(request).join();

    Map<String, dynamic> body;

    try {
      body = jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      print('$tag: json parsing failed, bad body, error: $e');

      request.response
        ..statusCode = HttpStatus.badRequest
        ..add(
          Utils.encode(
            Constants.badRequest(moreDetails: 'Invalid body, body must be a JSON'),
          ),
        )
        ..close();
      return;
    }

    final eventsList = body[kEventsKey];
    if (eventsList is! List) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..add(
          Utils.encode(
            Constants.badRequest(moreDetails: 'Expecting an events list'),
          ),
        )
        ..close();
      return;
    }

    if (eventsList.isEmpty) {
      print('$tag: empty events list received, nothing to store');
      request.response
        ..statusCode = HttpStatus.ok
        ..add(Utils.encode(Constants.noContent))
        ..close();
      return;
    }

    final events = eventsList.map<Map<String, dynamic>>((e) {
      return Map<String, dynamic>.from(e);
    });

    if (events.length > Constants.maxEventsLimit) {
      print('$tag: exceeding max events limit');
      request.response
        ..statusCode = HttpStatus.badRequest
        ..add(Utils.encode(Constants.badRequest(moreDetails: 'Too many events!')))
        ..close();
      return;
    }

    print('$tag: recording ${events.length} events to storage');

    await StorageService.instance.addAllEvents(events);

    request.response
      ..statusCode = HttpStatus.ok
      ..add(Utils.encode(Constants.eventsRecorded(noOfEvents: events.length)))
      ..close();
  }

  Future<void> handleGetEvents(HttpRequest request) async {
    final allEvents = StorageService.instance.getAllEvents();

    request.response
      ..statusCode = HttpStatus.ok
      ..add(Utils.encode(Constants.events(events: allEvents.toList())))
      ..close();
  }

  void handleError(HttpRequest request, Object e) {
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..add(Utils.encode(Constants.internalError(error: e)))
      ..close();
  }
}
