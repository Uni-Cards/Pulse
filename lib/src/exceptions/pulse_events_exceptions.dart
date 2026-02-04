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

abstract class PulseEventsExceptions implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  PulseEventsExceptions(this.message, {this.code, this.originalError});

  @override
  String toString() => 'PulseEventsException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NotReady extends PulseEventsExceptions {
  NotReady(super.message) : super(code: 'SDK_NOT_READY');
}

class InvalidConfiguration extends PulseEventsExceptions {
  InvalidConfiguration(super.message) : super(code: 'INVALID_CONFIG');
}

class InvalidEventPayload extends PulseEventsExceptions {
  final Map<String, dynamic>? payload;
  InvalidEventPayload(super.message, {this.payload}) : super(code: 'INVALID_PAYLOAD');
}

class InvalidEventContext extends PulseEventsExceptions {
  InvalidEventContext(super.message) : super(code: 'INVALID_CONTEXT');
}

class DatabaseException extends PulseEventsExceptions {
  DatabaseException(super.message, {super.originalError}) : super(code: 'DATABASE_ERROR');
}

class NetworkException extends PulseEventsExceptions {
  final int? statusCode;
  NetworkException(super.message, {this.statusCode, super.originalError}) : super(code: 'NETWORK_ERROR');
}

class ResourceException extends PulseEventsExceptions {
  ResourceException(super.message, {super.originalError}) : super(code: 'RESOURCE_ERROR');
}

class ValidationException extends PulseEventsExceptions {
  final String field;
  final dynamic value;
  ValidationException(super.message, this.field, this.value) : super(code: 'VALIDATION_ERROR');
}

class CircuitBreakerOpenException extends PulseEventsExceptions {
  CircuitBreakerOpenException()
      : super('Circuit breaker is open, requests are being rejected', code: 'CIRCUIT_BREAKER_OPEN');
}

class BackgroundProcessingException extends PulseEventsExceptions {
  // ignore: use_super_parameters
  BackgroundProcessingException(String message, {dynamic originalError})
      : super(message, code: 'BACKGROUND_PROCESSING_ERROR', originalError: originalError);
}
