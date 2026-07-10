class AppDurations {
  static const Duration splashDelay = Duration(seconds: 3);
  static const Duration fadeIn = Duration(milliseconds: 800);
  static const Duration slideUp = Duration(milliseconds: 600);
  static const Duration scaleIn = Duration(milliseconds: 500);
  static const Duration staggerDelay = Duration(milliseconds: 200);
}

class AppSizes {
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusXL = 28.0;
  static const double borderRadiusCard = 40.0;
  static const double buttonHeight = 52.0;
  static const double buttonHeightLarge = 56.0;
  static const double touchTarget = 48.0;
  static const double inputHeight = 48.0;
}

class AppRegexes {
  static const String email = r"^[^\s@]+@[^\s@]+\.(com|id|co\.id|net|org|ac\.id|go\.id|sch\.id)$";
  static const String name = r"^[a-zA-Z\s\.,'-]+$";
  static const String password = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$';
  static const String nonDigit = r'\D';
  static const String nonDigitPlus = r'[^\d+]';
}

class AppLimits {
  static const int phoneMinLength = 7;
  static const int phoneMaxLength = 12;
}
