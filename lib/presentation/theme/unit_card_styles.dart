import 'package:flutter/material.dart';
import 'unit_card_style.dart';

class UnitCardStyles {
  static UnitCardStyle fromStars(int stars) {
    switch (stars) {
      case 0:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFECEFF1),
          borderColor: Color(0xFFCFD8DC),
          textColor: Color(0xDD000000),
          starColor: Color(0xFF9E9E9E),
        );

      case 1:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFE3F2FD),
          borderColor: Color(0xFF90CAF9),
          textColor: Color(0xDD000000),
          starColor: Color(0xFF2196F3),
        );

      case 2:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFE8F5E9),
          borderColor: Color(0xFFA5D6A7),
          textColor: Color(0xDD000000),
          starColor: Color(0xFF4CAF50),
        );

      case 3:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFFFF9C4),
          borderColor: Color(0xFFFFF176),
          textColor: Color(0xDD000000),
          starColor: Color(0xFFFFC107),
        );

      case 4:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFFFE0B2),
          borderColor: Color(0xFFFFB74D),
          textColor: Color(0xDD000000),
          starColor: Color(0xFFFF9800),
        );

      case 5:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFFFD54F),
          borderColor: Color(0xFFFFA000),
          textColor: Color(0xDD000000),
          starColor: Color(0xFFFFC107),
        );

      default:
        return const UnitCardStyle(
          backgroundColor: Color(0xFFFFFFFF),
          borderColor: Color(0xFF9E9E9E),
          textColor: Color(0xDD000000),
          starColor: Color(0xFF9E9E9E),
        );
    }
  }
}
