import 'package:animals_tasks/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('should create ServerFailure with message', () {
        // Arrange
        const message = 'Server error occurred';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure, isA<Failure>());
        expect(failure, isA<ServerFailure>());
        expect(failure.message, message);
      });

      test('should create ServerFailure with empty message', () {
        // Arrange
        const message = '';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, isEmpty);
      });

      test('should create ServerFailure with long message', () {
        // Arrange
        const message = 'This is a very long error message that contains detailed information about what went wrong on the server side including stack traces and error codes';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message.length, greaterThan(50));
      });

      test('should create ServerFailure with special characters', () {
        // Arrange
        const message = 'Error: 404 - Not Found! @#\$%^&*()';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('404'));
      });

      test('should create ServerFailure with unicode characters', () {
        // Arrange
        const message = 'خطأ في الخادم 🚫 Erreur du serveur';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('🚫'));
      });

      test('should create ServerFailure with newlines and tabs', () {
        // Arrange
        const message = 'Error on line 1\n\tDetails: Connection failed\n\tCode: 500';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('\n'));
        expect(failure.message, contains('\t'));
      });

      test('should be const constructible', () {
        // This test verifies that ServerFailure can be created as const
        const failure1 = ServerFailure('Test error');
        const failure2 = ServerFailure('Test error');

        // In Dart, const objects with the same values are identical
        expect(identical(failure1, failure2), isTrue);
      });

      test('should have different instances for different messages', () {
        const failure1 = ServerFailure('Error 1');
        const failure2 = ServerFailure('Error 2');

        expect(failure1.message, isNot(equals(failure2.message)));
      });
    });

    group('NetworkFailure', () {
      test('should create NetworkFailure with message', () {
        // Arrange
        const message = 'Network connection failed';

        // Act
        const failure = NetworkFailure(message);

        // Assert
        expect(failure, isA<Failure>());
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, message);
      });

      test('should create NetworkFailure with empty message', () {
        // Arrange
        const message = '';

        // Act
        const failure = NetworkFailure(message);

        // Assert
        expect(failure.message, isEmpty);
      });

      test('should create NetworkFailure with timeout message', () {
        // Arrange
        const message = 'Connection timeout after 30 seconds';

        // Act
        const failure = NetworkFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('timeout'));
      });

      test('should create NetworkFailure with no internet message', () {
        // Arrange
        const message = 'No internet connection available';

        // Act
        const failure = NetworkFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('internet'));
      });

      test('should be const constructible', () {
        const failure1 = NetworkFailure('Network error');
        const failure2 = NetworkFailure('Network error');

        expect(identical(failure1, failure2), isTrue);
      });

      test('should have different instances for different messages', () {
        const failure1 = NetworkFailure('Timeout');
        const failure2 = NetworkFailure('No connection');

        expect(failure1.message, isNot(equals(failure2.message)));
      });

      test('should be distinct from ServerFailure', () {
        const networkFailure = NetworkFailure('Network error');
        const serverFailure = ServerFailure('Network error');

        expect(networkFailure, isNot(isA<ServerFailure>()));
        expect(serverFailure, isNot(isA<NetworkFailure>()));
        expect(networkFailure.runtimeType, isNot(equals(serverFailure.runtimeType)));
      });
    });

    group('UnknownFailure', () {
      test('should create UnknownFailure with message', () {
        // Arrange
        const message = 'An unexpected error occurred';

        // Act
        const failure = UnknownFailure(message);

        // Assert
        expect(failure, isA<Failure>());
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, message);
      });

      test('should create UnknownFailure with empty message', () {
        // Arrange
        const message = '';

        // Act
        const failure = UnknownFailure(message);

        // Assert
        expect(failure.message, isEmpty);
      });

      test('should create UnknownFailure with exception details', () {
        // Arrange
        const message = 'FormatException: Invalid format';

        // Act
        const failure = UnknownFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('Exception'));
      });

      test('should create UnknownFailure with stack trace info', () {
        // Arrange
        const message = 'Error at file.dart:123:45';

        // Act
        const failure = UnknownFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('.dart'));
      });

      test('should be const constructible', () {
        const failure1 = UnknownFailure('Unknown error');
        const failure2 = UnknownFailure('Unknown error');

        expect(identical(failure1, failure2), isTrue);
      });

      test('should have different instances for different messages', () {
        const failure1 = UnknownFailure('Error A');
        const failure2 = UnknownFailure('Error B');

        expect(failure1.message, isNot(equals(failure2.message)));
      });

      test('should be distinct from other failure types', () {
        const unknownFailure = UnknownFailure('Error');
        const serverFailure = ServerFailure('Error');
        const networkFailure = NetworkFailure('Error');

        expect(unknownFailure, isNot(isA<ServerFailure>()));
        expect(unknownFailure, isNot(isA<NetworkFailure>()));
        expect(unknownFailure.runtimeType, isNot(equals(serverFailure.runtimeType)));
        expect(unknownFailure.runtimeType, isNot(equals(networkFailure.runtimeType)));
      });
    });

    group('Failure Hierarchy', () {
      test('all failure types should extend Failure', () {
        const serverFailure = ServerFailure('Server error');
        const networkFailure = NetworkFailure('Network error');
        const unknownFailure = UnknownFailure('Unknown error');

        expect(serverFailure, isA<Failure>());
        expect(networkFailure, isA<Failure>());
        expect(unknownFailure, isA<Failure>());
      });

      test('should be able to use as Failure type', () {
        // Arrange & Act
        const List<Failure> failures = [
          ServerFailure('Server error'),
          NetworkFailure('Network error'),
          UnknownFailure('Unknown error'),
        ];

        // Assert
        expect(failures.length, 3);
        expect(failures[0], isA<ServerFailure>());
        expect(failures[1], isA<NetworkFailure>());
        expect(failures[2], isA<UnknownFailure>());
      });

      test('should preserve message through polymorphism', () {
        // Arrange
        const Failure failure = ServerFailure('Test message');

        // Assert
        expect(failure.message, 'Test message');
        expect(failure, isA<ServerFailure>());
      });

      test('should be able to pattern match on failure types', () {
        // Arrange
        const failures = [
          ServerFailure('Server error'),
          NetworkFailure('Network error'),
          UnknownFailure('Unknown error'),
        ];

        // Act & Assert
        for (final failure in failures) {
          if (failure is ServerFailure) {
            expect(failure.message, contains('Server'));
          } else if (failure is NetworkFailure) {
            expect(failure.message, contains('Network'));
          } else if (failure is UnknownFailure) {
            expect(failure.message, contains('Unknown'));
          }
        }
      });
    });

    group('Edge Cases', () {
      test('should handle very long messages', () {
        // Arrange
        final longMessage = 'Error: ' + 'A' * 10000;

        // Act
        final failure = ServerFailure(longMessage);

        // Assert
        expect(failure.message.length, greaterThan(10000));
        expect(failure.message, startsWith('Error:'));
      });

      test('should handle messages with only whitespace', () {
        // Arrange
        const message = '   \n\t   ';

        // Act
        const failure = NetworkFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message.trim(), isEmpty);
      });

      test('should handle null-like string messages', () {
        // Arrange
        const message = 'null';

        // Act
        const failure = UnknownFailure(message);

        // Assert
        expect(failure.message, 'null');
      });

      test('should handle numeric string messages', () {
        // Arrange
        const message = '404';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, '404');
      });

      test('should handle JSON-like messages', () {
        // Arrange
        const message = '{"error": "Not found", "code": 404}';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('{'));
        expect(failure.message, contains('}'));
      });

      test('should handle HTML-like messages', () {
        // Arrange
        const message = '<html><body>Error 404</body></html>';

        // Act
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.message, contains('<html>'));
      });
    });

    group('Common Error Scenarios', () {
      test('should represent HTTP 400 Bad Request', () {
        const failure = ServerFailure('Bad Request [400]');
        expect(failure.message, contains('400'));
      });

      test('should represent HTTP 401 Unauthorized', () {
        const failure = ServerFailure('Unauthorized [401]');
        expect(failure.message, contains('401'));
      });

      test('should represent HTTP 403 Forbidden', () {
        const failure = ServerFailure('Forbidden [403]');
        expect(failure.message, contains('403'));
      });

      test('should represent HTTP 404 Not Found', () {
        const failure = ServerFailure('Not Found [404]');
        expect(failure.message, contains('404'));
      });

      test('should represent HTTP 500 Internal Server Error', () {
        const failure = ServerFailure('Internal Server Error [500]');
        expect(failure.message, contains('500'));
      });

      test('should represent HTTP 503 Service Unavailable', () {
        const failure = ServerFailure('Service Unavailable [503]');
        expect(failure.message, contains('503'));
      });

      test('should represent connection timeout', () {
        const failure = NetworkFailure('Connection timeout');
        expect(failure.message, contains('timeout'));
      });

      test('should represent no internet connection', () {
        const failure = NetworkFailure('No internet connection');
        expect(failure.message, contains('internet'));
      });

      test('should represent SSL/TLS errors', () {
        const failure = NetworkFailure('SSL certificate verification failed');
        expect(failure.message, contains('SSL'));
      });

      test('should represent parsing errors', () {
        const failure = UnknownFailure('Failed to parse JSON response');
        expect(failure.message, contains('parse'));
      });

      test('should represent unexpected null values', () {
        const failure = UnknownFailure('Unexpected null value in response');
        expect(failure.message, contains('null'));
      });
    });

    group('Message Formatting', () {
      test('should preserve exact message formatting', () {
        const message = 'Error: Failed to fetch data\nDetails: Connection refused\nCode: ECONNREFUSED';
        const failure = NetworkFailure(message);

        expect(failure.message, equals(message));
      });

      test('should preserve leading and trailing spaces', () {
        const message = '  Error message  ';
        const failure = ServerFailure(message);

        expect(failure.message, equals(message));
        expect(failure.message, startsWith('  '));
        expect(failure.message, endsWith('  '));
      });

      test('should handle multi-line error messages', () {
        const message = '''
Error occurred while processing request
Endpoint: /api/users
Method: GET
Status: 500
''';
        const failure = ServerFailure(message);

        expect(failure.message, contains('Error occurred'));
        expect(failure.message, contains('Endpoint'));
        expect(failure.message, contains('500'));
      });
    });
  });
}
