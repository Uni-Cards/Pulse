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

import 'dart:async';

import '../log/log.dart';

class Lock {
  final String? debugLabel;

  Lock({
    this.debugLabel,
  });

  Completer<void>? _completer;

  Future<void> get locked {
    // wait if the lock is active
    if (_completer != null) return _completer!.future;

    // return immediately if the lock is not active
    return Future.value();
  }

  Future<void> acquire() async {
    Log.i('$this: trying to acquire lock');

    // wait if the lock is held
    if (_completer != null) {
      Log.i('$this: acquiring lock failed, already locked by other process');
      await _completer!.future;
    }

    Log.i('$this: lock acquired');

    // lock is not acquired
    _completer = Completer<void>();
  }

  void release() {
    // complete the lock, and free it
    _completer?.complete();
    _completer = null;

    Log.i('$this: releasing lock');
  }

  @override
  String toString() {
    return debugLabel != null ? 'Lock($debugLabel)' : super.toString();
  }
}
