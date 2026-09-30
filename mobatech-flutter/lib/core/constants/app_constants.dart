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
  static const String email =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String name = r"^[a-zA-ZÀ-ÿ\s.',-]+$";
  static const String phone = r'^(\+62|62|0)8[1-9][0-9]{7,11}$';
  static const String password =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,64}$';
  static const String nonDigit = r'\D';
  static const String nonDigitPlus = r'[^\d+]';
}

class AppEmailDomains {
  static const Set<String> blockedTypoDomains = {
    'gmail.co',
    'yahoo.co',
    'hotmail.co',
    'outlook.co',
    'icloud.co',
    'gmial.com',
    'gmaill.com',
    'gamil.com',
    'yaho.com',
    'outlok.com',
    'hotmial.com',
    'iclod.com',
    'gmail.con',
  };

  static const Set<String> trustedDomains = {
    'gmail.com',
    'googlemail.com',
    'yahoo.com',
    'yahoo.co.id',
    'ymail.com',
    'outlook.com',
    'hotmail.com',
    'live.com',
    'msn.com',
    'icloud.com',
    'me.com',
    'mac.com',
    'proton.me',
    'protonmail.com',
    'zoho.com',
    'aol.com',
    'herminahospitals.com',
    'mobatech.com',
    'kemkes.go.id',
  };

  static const List<String> allowedTLDs = [
    '.com',
    '.id',
    '.co.id',
    '.net',
    '.org',
    '.ac.id',
    '.go.id',
    '.sch.id',
    '.edu',
    '.io',
  ];
}

class AppLimits {
  static const int nameMinLength = 2;
  static const int nameMaxLength = 100;
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 64;
  static const int phoneMinLength = 9;
  static const int phoneMaxLength = 15;
}
