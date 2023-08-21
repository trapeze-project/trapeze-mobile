import 'package:flutter/material.dart';

class AppColors {
  static const TRAPEZE_YELLOW_RGBO_HEX = 0xFFEED216;
  static const TRAPEZE_YELLOW = Color(TRAPEZE_YELLOW_RGBO_HEX);

  /// (yellow (RGB) = 0xEED216) = (228,210,22); opacity (O) = 0xFF)
  /// https://maketintsandshades.com/#EED216
  static const PRIMARY_SWATCH = MaterialColor(TRAPEZE_YELLOW_RGBO_HEX, <int, Color>{
        50: const Color(0xFFD6BD14), // 10%
        100: const Color(0xFFBEA812),// 20%
        200: const Color(0xFFA7930F),// 30%
        300: const Color(0xFF8F7E0D),// 40%
        400: const Color(0xFF77690B),// 50%
        500: const Color(0xFF5F5409),// 60%
        600: const Color(0xFF473F07),// 70%
        700: const Color(0xFF302A04),// 80%
        800: const Color(0xFF181502),// 90%
        900: const Color(0xFF000000), // 100%
        });

  static const SECONDARY_SWATCH = MaterialColor(0xFFe89309, <int, Color>{
        50: const Color(0xFFF0D72D), // 10%
        100: const Color(0xFFF1DB45),// 20%
        200: const Color(0xFFF3E05C),// 30%
        300: const Color(0xFFF5E473),// 40%
        400: const Color(0xFFF7E98B),// 50%
        500: const Color(0xFFF8EDA2),// 60%
        600: const Color(0xFFFAF2B9),// 70%
        700: const Color(0xFFFCF6D0),// 80%
        800: const Color(0xFFFDFBE8),// 90%
        900: const Color(0xFFFFFFFF), // 100%
      });

}