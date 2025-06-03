class Constants {
  Constants._();

  static const maxEventsLimit = 80; // largest batch size

  static const authToken = 'secret';

  static const noContent = {
    'message': 'No content',
    'description': 'No events to store',
  };

  static const invalidRequest = {
    'message': 'Invalid request',
    'description': 'We don\'t know yet how to handle your request!',
  };

  static const unauthorized = {
    'message': 'Unauthorized',
    'description': 'Invalid or null auth token, this endpoint requires authentication',
  };

  static Map nothingToDelete = {
    'message': 'Nothing to delete',
  };

  static Map eventsDeleted({required int noOfEvents}) => {
        'message': 'Success',
        'description': 'Deleted $noOfEvents event${noOfEvents > 1 ? 's' : ''}!',
      };

  static Map events({required List events}) => {
        'message': 'Found ${events.length} event${events.length > 1 ? 's' : ''}!',
        'events': events,
      };

  static Map eventsRecorded({required int noOfEvents}) => {
        'message': 'Success',
        'description': 'Recorded $noOfEvents event${noOfEvents > 1 ? 's' : ''}!',
      };

  static Map badRequest({required String moreDetails}) => {
        'message': 'Bad Request',
        'description': 'Wow, that\'s a baaaaad request, please correct it.',
        'moreDetails': moreDetails,
      };

  static Map internalError({required Object error}) => {
        'message': 'Something terribly went wrong',
        'description': 'Here is what went wrong, error thrown: $error',
      };

  static const eventsConfig = {
    "responseType": "EVENTS_SDK_CONFIG",
    "eventPublishEndpoint": "/v1/events",
    "priorities": [
      {
        "priority": 0,
        "configuration": {
          "batchSize": 1,
          "frequencyInSec": 5,
        }
      },
      {
        "priority": 1,
        "configuration": {
          "batchSize": 5,
          "frequencyInSec": 30,
        }
      },
      {
        "priority": 3,
        "configuration": {
          "batchSize": 50,
          "frequencyInSec": 120,
        }
      }
    ],
  };
}
