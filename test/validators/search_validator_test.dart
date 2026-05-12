import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/validators/search_validator.dart';

void main() {
  group('validateSearch', () {
    test('null returns error', () {
      expect(validateSearch(null), isNotNull);
    });

    test('empty string returns error', () {
      expect(validateSearch(''), isNotNull);
    });

    test('whitespace-only returns error', () {
      expect(validateSearch('   '), isNotNull);
    });

    test('single character returns error', () {
      expect(validateSearch('a'), isNotNull);
    });

    test('digits return error', () {
      expect(validateSearch('abc123'), isNotNull);
    });

    test('valid input returns null', () {
      expect(validateSearch('chicken'), isNull);
    });

    test('valid input with space returns null', () {
      expect(validateSearch('chicken breast'), isNull);
    });
  });
}
