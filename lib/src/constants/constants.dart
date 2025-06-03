import 'package:flutter/foundation.dart';

class Constants {
  Constants._();
  static const sdkVersion = '1.0.0';
  static const coreDbEntityId = "core-db";
  static const coreDbEntitySdkConfigKey = "sdkConfig";
  static const dbFlushDuration = Duration(seconds: 2);
}

class EventKeyConstants {
  EventKeyConstants._();

  static const eventTime = 'eventTime';
  static const eventPriority = 'eventPriority';
  static const eventSdkVersion = 'eventSdkVersion';
}

class BackgroundTaskConstants {
  BackgroundTaskConstants._();

  static const taskIdentifier = 'pulse-events-sdk-bg-task';
  static const taskName = 'Events Sync Task';
  static const taskTag = 'Events Sync Task';

  static const initialDelay = kDebugMode ? Duration(minutes: 10) : Duration(minutes: 30);
  static const backOffPolicyDelay = kDebugMode ? Duration(minutes: 1) : Duration(minutes: 10);

  static const databaseIdKey = 'databaseId';
  static const baseUrlKey = 'baseUrl';
  static const eventPublishEndpointKey = 'eventPublishEndpoint';
  static const appAuthTokenKey = 'appAuthToken';
  static const deviceIdKey = 'deviceId';
  static const sessionIdKey = 'sessionId';
  static const debugMode = 'debugMode';
  static const appType = 'appType';

  static const debugBackgroundTaskEventName = 'BackgroundTaskTriggered';

  static const eventPayloadOS = 'platform.operatingSystem';
  static const eventPayloadOSVersion = 'platform.operatingSystemVersion';
}
