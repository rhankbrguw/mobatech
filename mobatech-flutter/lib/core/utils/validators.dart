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
    final trimmed = value.trim();
    if (trimmed.length < AppLimits.nameMinLength ||
        trimmed.length > AppLimits.nameMaxLength) {
      return ErrorStrings.errInvalidName;
    }
    if (!RegExp(AppRegexes.name).hasMatch(trimmed)) {
      return ErrorStrings.errInvalidName;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    final trimmed = value.trim();
    if (!RegExp(AppRegexes.email, caseSensitive: false).hasMatch(trimmed)) {
      return ErrorStrings.errEmailInvalid;
    }

    final parts = trimmed.split('@');
    if (parts.length != 2) return ErrorStrings.errEmailInvalid;
    final domain = parts[1].toLowerCase();

    if (AppEmailDomains.blockedTypoDomains.contains(domain)) {
      return ErrorStrings.errEmailTypo;
    }

    final isTrusted = AppEmailDomains.trustedDomains.contains(domain);
    final isValidTLD = AppEmailDomains.allowedTLDs.any(
      (tld) => domain.endsWith(tld) && domain.length > tld.length + 1,
    );

    if (!isTrusted && !isValidTLD) {
      return ErrorStrings.errInvalidEmailDomain;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    final cleanPhone = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(AppRegexes.phone).hasMatch(cleanPhone)) {
      return ErrorStrings.errInvalidPhone;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return CoreStrings.requiredField;
    }
    if (value.length < AppLimits.passwordMinLength ||
        value.length > AppLimits.passwordMaxLength) {
      return ErrorStrings.errWeakPassword;
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
