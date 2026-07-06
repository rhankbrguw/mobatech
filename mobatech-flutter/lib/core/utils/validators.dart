import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';

class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${CoreStrings.requiredField.toLowerCase()}';
    }
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${CoreStrings.requiredField.toLowerCase()}';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s\.,'-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return ErrorStrings.errInvalidName;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    final emailRegex = RegExp(
      r"^[^\s@]+@[^\s@]+\.(com|id|co\.id|net|org|ac\.id|go\.id|sch\.id)$",
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return ErrorStrings.errInvalidEmailDomain;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    String cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.startsWith('+62')) {
      cleanPhone = cleanPhone.substring(3);
    } else if (cleanPhone.startsWith('62')) {
      cleanPhone = cleanPhone.substring(2);
    } else if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    final digits = cleanPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 12) {
      return ErrorStrings.errInvalidPhone;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return ErrorStrings.errWeakPassword;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    if (value != originalPassword) {
      return ErrorStrings.errPasswordMismatch;
    }
    return null;
  }
}
