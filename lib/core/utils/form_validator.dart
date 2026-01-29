import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

class FormValidator {
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName == null
          ? LocaleKeys.thisFieldIsRequired.tr()
          : LocaleKeys.enterField.tr(namedArgs: {'fieldName': fieldName});
    }
    return null;
  }

  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName == null
          ? LocaleKeys.thisFieldIsRequired.tr()
          : LocaleKeys.enterField.tr(namedArgs: {'fieldName': fieldName});
    }

    if (double.tryParse(value) == null) {
      return fieldName != null
          ? LocaleKeys.enterValidNumberInField.tr(namedArgs: {'fieldName': fieldName})
          : LocaleKeys.enterValidNumber.tr();
    }

    return null;
  }

  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) {
      return numberError;
    }

    if (double.parse(value!) <= 0) {
      return fieldName != null
          ? LocaleKeys.fieldMustBeGreaterThanZero.tr(namedArgs: {'fieldName': fieldName})
          : LocaleKeys.numberMustBeGreaterThanZero.tr();
    }

    return null;
  }

  static String? validateWithinRange(String? value, {double? min, double? max, String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) {
      return numberError;
    }

    double numValue = double.parse(value!);

    if (min != null && numValue < min) {
      return fieldName != null
          ? LocaleKeys.fieldMustBeGreaterThan.tr(namedArgs: {'fieldName': fieldName, 'min': min.toString()})
          : LocaleKeys.numberMustBeGreaterThan.tr(namedArgs: {'min': min.toString()});
    }

    if (max != null && numValue > max) {
      return fieldName != null
          ? LocaleKeys.fieldMustBeLessThan.tr(namedArgs: {'fieldName': fieldName, 'max': max.toString()})
          : LocaleKeys.numberMustBeLessThan.tr(namedArgs: {'max': max.toString()});
    }

    return null;
  }

  static String? validatePassword(String? value, {String? fieldName}) {
    final requiredError = validateRequired(value, fieldName: fieldName ?? LocaleKeys.password.tr());
    if (requiredError != null) {
      return requiredError;
    }

    String password = value!.trim();

    // Minimum length check (e.g., 8 characters)
    if (password.length < 8) {
      return fieldName != null
          ? LocaleKeys.fieldMustBeAtLeast8Chars.tr(namedArgs: {'fieldName': fieldName})
          : LocaleKeys.passwordMustBeAtLeast8Chars.tr();
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return fieldName != null
          ? LocaleKeys.fieldMustContainNumber.tr(namedArgs: {'fieldName': fieldName})
          : LocaleKeys.passwordMustContainNumber.tr();
    }

    // Check for at least one alphabetic character (uppercase OR lowercase)
    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return fieldName != null
          ? LocaleKeys.fieldMustContainLetter.tr(namedArgs: {'fieldName': fieldName})
          : LocaleKeys.passwordMustContainLetter.tr();
    }

    return null; // Password is valid
  }

}