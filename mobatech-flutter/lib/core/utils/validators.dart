import 'package:mobatech_app/core/constants/app_constants.dart';
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
    if (!RegExp(AppRegexes.name).hasMatch(value.trim())) {
      return ErrorStrings.errInvalidName;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    if (!RegExp(AppRegexes.email, caseSensitive: false).hasMatch(value.trim())) {
      return ErrorStrings.errInvalidEmailDomain;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    String cleanPhone = value.replaceAll(RegExp(AppRegexes.nonDigitPlus), '');
    if (cleanPhone.startsWith(CoreFormatters.phonePrefixIntl)) {
      cleanPhone = cleanPhone.substring(3);
    } else if (cleanPhone.startsWith(CoreFormatters.phonePrefixLocalIntl)) {
      cleanPhone = cleanPhone.substring(2);
    } else if (cleanPhone.startsWith(CoreFormatters.phonePrefixLocal)) {
      cleanPhone = cleanPhone.substring(1);
    }
    final digits = cleanPhone.replaceAll(RegExp(AppRegexes.nonDigit), '');
    if (digits.length < AppLimits.phoneMinLength || digits.length > AppLimits.phoneMaxLength) {
      return ErrorStrings.errInvalidPhone;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    if (!RegExp(AppRegexes.password).hasMatch(value)) {
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
