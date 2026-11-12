import 'package:flutter_test/flutter_test.dart';
import 'package:zachranobed/common/presentation/utils/field_validation_utils.dart';

void main() {
  group('FieldValidationUtils.isValidEmail', () {
    test('accepts valid addresses', () {
      expect(FieldValidationUtils.isValidEmail('charita@gmail.com'), isTrue);
      expect(FieldValidationUtils.isValidEmail('zachran.obed+test@sub.example.cz'), isTrue);
      expect(FieldValidationUtils.isValidEmail('a_b-c%d@example-domain.org'), isTrue);
    });

    test('ignores leading and trailing whitespace', () {
      expect(FieldValidationUtils.isValidEmail(' charita@gmail.com'), isTrue);
      expect(FieldValidationUtils.isValidEmail('charita@gmail.com  '), isTrue);
    });

    test('rejects whitespace inside the address', () {
      expect(FieldValidationUtils.isValidEmail('zachranobed charita@gmail.com'), isFalse);
      expect(FieldValidationUtils.isValidEmail('charita@gmail .com'), isFalse);
    });

    test('rejects a comma', () {
      expect(FieldValidationUtils.isValidEmail('zachranobed,charita@gmail.com'), isFalse);
      expect(FieldValidationUtils.isValidEmail('charita@gmail.com,'), isFalse);
    });

    test('rejects other invalid formats', () {
      expect(FieldValidationUtils.isValidEmail(''), isFalse);
      expect(FieldValidationUtils.isValidEmail('charita'), isFalse);
      expect(FieldValidationUtils.isValidEmail('charita@gmail'), isFalse);
      expect(FieldValidationUtils.isValidEmail('@gmail.com'), isFalse);
      expect(FieldValidationUtils.isValidEmail('charita@@gmail.com'), isFalse);
    });
  });
}
