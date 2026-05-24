import 'package:flash_english/presentation/theme/unit_card_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitCardStyles.fromStars', () {
    test('returns style for 0 stars', () {
      final style = UnitCardStyles.fromStars(0);

      expect(style.backgroundColor, const Color(0xFFECEFF1));
      expect(style.borderColor, const Color(0xFFCFD8DC));
      expect(style.textColor, const Color(0xDD000000));
      expect(style.starColor, const Color(0xFF9E9E9E));
    });

    test('returns style for 1 star', () {
      final style = UnitCardStyles.fromStars(1);

      expect(style.backgroundColor, const Color(0xFFE3F2FD));
      expect(style.borderColor, const Color(0xFF90CAF9));
      expect(style.starColor, const Color(0xFF2196F3));
    });

    test('returns style for 2 stars', () {
      final style = UnitCardStyles.fromStars(2);

      expect(style.backgroundColor, const Color(0xFFE8F5E9));
      expect(style.borderColor, const Color(0xFFA5D6A7));
      expect(style.starColor, const Color(0xFF4CAF50));
    });

    test('returns style for 3 stars', () {
      final style = UnitCardStyles.fromStars(3);

      expect(style.backgroundColor, const Color(0xFFFFF9C4));
      expect(style.borderColor, const Color(0xFFFFF176));
      expect(style.starColor, const Color(0xFFFFC107));
    });

    test('returns style for 4 stars', () {
      final style = UnitCardStyles.fromStars(4);

      expect(style.backgroundColor, const Color(0xFFFFE0B2));
      expect(style.borderColor, const Color(0xFFFFB74D));
      expect(style.starColor, const Color(0xFFFF9800));
    });

    test('returns style for 5 stars', () {
      final style = UnitCardStyles.fromStars(5);

      expect(style.backgroundColor, const Color(0xFFFFD54F));
      expect(style.borderColor, const Color(0xFFFFA000));
      expect(style.starColor, const Color(0xFFFFC107));
    });

    test('returns default style for invalid value', () {
      final style = UnitCardStyles.fromStars(999);

      expect(style.backgroundColor, const Color(0xFFFFFFFF));
      expect(style.borderColor, const Color(0xFF9E9E9E));
      expect(style.textColor, const Color(0xDD000000));
      expect(style.starColor, const Color(0xFF9E9E9E));
    });
  });
}
