abstract class PulseEventsExceptions implements Exception {}

class NotReady extends PulseEventsExceptions {
  final String message;
  NotReady(this.message);
}
