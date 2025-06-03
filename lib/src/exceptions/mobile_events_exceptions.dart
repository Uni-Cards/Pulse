abstract class MobileEventsExceptions implements Exception {}

class NotReady extends MobileEventsExceptions {
  final String message;
  NotReady(this.message);
}
