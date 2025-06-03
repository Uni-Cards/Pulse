import 'package:uuid/uuid.dart';

/// Maintains a single session accross a single app open
/// App kill would generate a new session, otherwise the [sessionId] getter
/// is guaranteed to return the same string
class SessionService {
  final String _sessionId;
  SessionService._() : _sessionId = const Uuid().v1();

  static SessionService? _instance;
  static SessionService get instance => _instance ??= SessionService._();

  String get sessionId => _sessionId;
}
