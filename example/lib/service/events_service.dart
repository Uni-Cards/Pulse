import 'dart:developer';

import 'package:mobile_events_sdk/mobile_events_sdk.dart';

import 'auth_service.dart';
import 'session_service.dart';

const kAppId = 'example-app';
const kDeviceIdentifier = 'a-constant-identifier';

class EventsService {
  static const tag = 'Events Service';

  final MobileEventsSdk _mobileEventsSdk;

  EventsService._()
      : _mobileEventsSdk = MobileEventsSdk(
          appId: kAppId,
          eventContext: EventContext(
            sessionId: SessionService.instance.sessionId,
            appAuthToken: AuthService.instance.authToken ?? "",
            deviceId: kDeviceIdentifier,
            networkHeaders: {
              'fingerprint-id': kDeviceIdentifier,
              'Authorization': AuthService.instance.authToken,
              'session-id': SessionService.instance.sessionId,
              'User-Agent': 'Mobile Events SDK',
              'Content-Type': 'application/json',
            },
          ),
        );

  static EventsService? _instance;
  static EventsService get instance => _instance ??= EventsService._();

  static const screenLoadEventName = 'ScreenLoaded';
  static const buttonTapEventName = 'ButtonTapped';
  static const errorEventName = 'ErrorEvents';

  Future<bool> configure({
    required String baseUrl,
    required String configureEndpoint,
    required bool debugMode,
  }) async {
    try {
      // parsing is done just to validate uri format
      final uri = Uri.parse('$baseUrl$configureEndpoint');
      log('$tag: valid uri: $uri');

      return _mobileEventsSdk.init(
        baseUrl: baseUrl,
        configUrlEndpoint: configureEndpoint,
        config: MobileEventsSdkConfig(fallbackEventPublishEndpoint: '/v1/events'),
        debugMode: debugMode,
      );
    } catch (e) {
      log('$tag: configure method threw error: $e');
      return false;
    }
  }

  void setUserId(String userId) {
    _mobileEventsSdk.setUserId(userId);
  }

  void logout() {
    _mobileEventsSdk.logout();
  }

  /// Generic events can be prioritized by the caller with the [priority] value
  void trackEvent({
    required String eventName,
    required Map<String, dynamic> payload,
    required int priority,
  }) {
    payload.addAll(
      {
        'userId': AuthService.instance.userId,
      },
    );

    return _mobileEventsSdk.trackEvent(
      eventName: eventName,
      payload: payload,
      priority: priority,
    );
  }

  /// All error events are prioritized as level 0
  void trackError({
    Map<String, dynamic>? payload,
  }) {
    return trackEvent(
      eventName: errorEventName,
      payload: _createPayloadFrom(payload: payload),
      priority: 0,
    );
  }

  /// All screen load events are prioritized as level 1
  void trackScreenLoadEvent({
    Map<String, dynamic>? payload,
    int priority = 1,
  }) {
    return trackEvent(
      eventName: screenLoadEventName,
      payload: _createPayloadFrom(payload: payload),
      priority: priority,
    );
  }

  /// All button tap events are prioritized as level 2
  void trackButtonTapEvent({
    Map<String, dynamic>? payload,
    int priority = 2,
  }) {
    return trackEvent(
      eventName: buttonTapEventName,
      payload: _createPayloadFrom(payload: payload),
      priority: priority,
    );
  }

  Map<String, dynamic> _createPayloadFrom({Map<String, dynamic>? payload}) {
    return payload ?? {};
  }
}
