import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mobile_events_sdk/mobile_events_sdk.dart';
import 'package:mobile_events_sdk/src/constants/constants.dart';

import '../../db_models/sdk_config_data_model.dart';
import '../../exceptions/mobile_events_exceptions.dart';
import '../../interfaces/events_service.dart';
import '../db/hive_database_service.dart';
import '../interfaces/database_service.dart';
import '../log/log.dart';
import '../network/dio_network_service.dart';
import '../synchronization/lock.dart';
import '../utils/extensions.dart';
import '../utils/utils.dart';
import 'background_worker.dart';
import 'models/events_sdk_config.dart';
import 'workers/single_task_worker.dart';
import 'workers/worker.dart';

part 'event_manager.dart';

enum Status { notConfigured, configured, failed }

class FrequencySyncEventService implements IEventsService {
  static const tag = 'FrequencySyncEventService';

  late EventManager _eventManager;

  Status _configurationStatus = Status.notConfigured;
  bool get _isSdkNotReady => _configurationStatus != Status.configured;

  @override
  Future<bool> init({
    required String baseUrl,
    required String configUrl,
    required String appId,
    required EventContext eventContext,
    bool debugMode = false,
  }) async {
    try {
      Log.i(
        '$tag: init({...}) invoked with {baseUrl: $baseUrl, configUrl: $configUrl, appId: $appId, debugMode: $debugMode}',
      );

      _eventManager = EventManager(
        baseUrl: baseUrl,
        appId: appId,
        eventContext: eventContext,
        debugMode: debugMode,
      );

      await _eventManager.init(configUrl: configUrl);

      Log.i('$tag: init({...}) configured - sdk now ready to accept events!');
      _configurationStatus = Status.configured;
    } on MobileEventsExceptions catch (e) {
      Log.e('$tag: init({...}) failed with exception: $e');
      _configurationStatus = Status.failed;
      return false;
    }

    return true;
  }

  @override
  void logout() {
    // ignore logout invocation if sdk is not yet ready
    if (_isSdkNotReady) return;

    _eventManager.logout();
  }

  @override
  void setUserId({required String userId}) {
    // ignore setUserId invocation if sdk is not yet ready
    if (_isSdkNotReady) return;

    _eventManager.userId = userId;
  }

  @override
  void trackEvent({
    required String eventName,
    required Map<String, dynamic> payload,
    int? priority,
  }) {
    if (_isSdkNotReady) throw NotReady('SDK status: $_configurationStatus');

    _eventManager.trackEvent(
      eventName: eventName,
      payload: payload,
      priority: priority ?? getIt<MobileEventsSdkConfig>().defaultEventPriority,
    );
  }

  @override
  void refreshEventContext(EventContext newEventContext) {
    _eventManager.setEventContext = newEventContext;
  }
}
