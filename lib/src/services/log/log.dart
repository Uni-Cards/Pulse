// Copyright 2025 Pulse Events SDK Contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:developer' as dev;

import 'package:pulse_events_sdk/pulse_events_sdk.dart';

class Log {
  static bool _ignoreLogging = true;

  static int _index = 1;
  static get _sequenceNumber {
    return _index++;
  }

  /// No logs are printing if app is not in debug mode
  static set debugMode(bool value) => _ignoreLogging = !value;

  static String _formatMessage(String message, DateTime time, int sequenceNo) {
    return '[$sequenceNo] $message';
  }

  static void e(String message, [Error? error, StackTrace? stackTrace]) {
    if (_ignoreLogging) return;

    final time = DateTime.now();
    final sn = _sequenceNumber;

    dev.log(
      _formatMessage(message, time, sn),
      sequenceNumber: sn,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      name: getIt<PulseEventsSdkConfig>().logSourceName,
      time: time,
    );
  }

  static void i(String message) {
    if (_ignoreLogging) return;

    final time = DateTime.now();
    final sn = _sequenceNumber;

    dev.log(
      _formatMessage(message, time, sn),
      sequenceNumber: sn,
      name: getIt<PulseEventsSdkConfig>().logSourceName,
      time: time,
    );
  }
}
