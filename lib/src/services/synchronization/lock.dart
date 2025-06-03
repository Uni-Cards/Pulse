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
