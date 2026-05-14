import 'package:flutter_test/flutter_test.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';

void main() {
  group('getNextFoodBoxesCheckDateTime', () {
    DateTime expectedUtc(int year, int month, int day) {
      return DateTime.utc(year, month, day, 7, 0, 0);
    }

    test('before this month\'s 1st Friday returns this month\'s 1st Friday', () {
      // June 2025: 1st Friday is the 6th. Called on Wednesday the 4th.
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 6, 4, 10, 0),
      );

      expect(result, expectedUtc(2025, 6, 6));
    });

    test('on the morning of the 1st Friday returns the 3rd Friday', () {
      // June 2025: 1st Friday is the 6th, 3rd Friday is the 20th.
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 6, 6, 9, 15),
      );

      expect(result, expectedUtc(2025, 6, 20));
    });

    test('between the 1st and 3rd Friday returns the 3rd Friday', () {
      // June 2025: called on the 12th, between the 1st (6th) and 3rd (20th).
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 6, 12, 14, 0),
      );

      expect(result, expectedUtc(2025, 6, 20));
    });

    test('on the morning of the 3rd Friday returns next month\'s 1st Friday', () {
      // June 2025: 3rd Friday is the 20th. July 2025: 1st Friday is the 4th.
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 6, 20, 9, 15),
      );

      expect(result, expectedUtc(2025, 7, 4));
    });

    test('after the 3rd Friday returns next month\'s 1st Friday', () {
      // June 2025: called on the 25th, after the 3rd Friday (20th).
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 6, 25, 8, 0),
      );

      expect(result, expectedUtc(2025, 7, 4));
    });

    test('in late December rolls over to January of the next year', () {
      // December 2025: 1st Friday is the 5th, 3rd Friday is the 19th.
      // Called on the 22nd. January 2026: 1st Friday is the 2nd.
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 12, 22, 10, 0),
      );

      expect(result, expectedUtc(2026, 1, 2));
    });

    test('when 1st of the month is a Friday, that day counts as the 1st Friday', () {
      // August 2025: 1st is a Friday. Called on July 31.
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 7, 31, 12, 0),
      );

      expect(result, expectedUtc(2025, 8, 1));
    });

    test('returns a UTC timestamp at 07:00', () {
      final result = DateTimeUtils.getNextFoodBoxesCheckDateTime(
        now: DateTime(2025, 6, 4, 10, 0),
      );

      expect(result.isUtc, isTrue);
      expect(result.hour, 7);
      expect(result.minute, 0);
    });
  });
}
