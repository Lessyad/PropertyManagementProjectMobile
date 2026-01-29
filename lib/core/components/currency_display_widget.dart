import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/currency_service.dart';

class CurrencyDisplayWidget extends StatelessWidget {
  final double amount;
  final Color textColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final int? decimalPlaces;

  const CurrencyDisplayWidget({
    Key? key,
    required this.amount,
    required this.textColor,
    required this.fontSize,
    this.fontWeight,
    this.decimalPlaces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;
    final currency = currencyService.getCurrencyForLanguage(currentLocale);
    final places = decimalPlaces ?? 2;
    final formattedAmount = '${amount.toStringAsFixed(places)} ${currency.symbol}';
    
    return Text(
      formattedAmount,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

class BoldCurrencyDisplayWidget extends CurrencyDisplayWidget {
  const BoldCurrencyDisplayWidget({
    Key? key,
    required double amount,
    required Color textColor,
    required double fontSize,
  }) : super(
          key: key,
          amount: amount,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        );
}

class SemiBoldCurrencyDisplayWidget extends CurrencyDisplayWidget {
  const SemiBoldCurrencyDisplayWidget({
    Key? key,
    required double amount,
    required Color textColor,
    required double fontSize,
  }) : super(
          key: key,
          amount: amount,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        );
}

class CurrencyPerDayWidget extends StatelessWidget {
  final Color textColor;
  final double fontSize;
  final FontWeight? fontWeight;

  const CurrencyPerDayWidget({
    Key? key,
    required this.textColor,
    required this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;
    final currency = currencyService.getCurrencyForLanguage(currentLocale);
    
    return Text(
      currency.perDayLabel,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

class BoldCurrencyPerDayWidget extends CurrencyPerDayWidget {
  const BoldCurrencyPerDayWidget({
    Key? key,
    required Color textColor,
    required double fontSize,
  }) : super(
          key: key,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        );
}

class SemiBoldCurrencyPerDayWidget extends CurrencyPerDayWidget {
  const SemiBoldCurrencyPerDayWidget({
    Key? key,
    required Color textColor,
    required double fontSize,
  }) : super(
          key: key,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        );
}

// Widget pour afficher uniquement le symbole de devise
class CurrencySymbolWidget extends StatelessWidget {
  final Color textColor;
  final double fontSize;
  final FontWeight? fontWeight;

  const CurrencySymbolWidget({
    Key? key,
    required this.textColor,
    required this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;
    final currency = currencyService.getCurrencyForLanguage(currentLocale);
    
    return Text(
      currency.symbol,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

// Widget pour afficher le nom complet de la devise
class CurrencyNameWidget extends StatelessWidget {
  final Color textColor;
  final double fontSize;
  final FontWeight? fontWeight;

  const CurrencyNameWidget({
    Key? key,
    required this.textColor,
    required this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;
    final currency = currencyService.getCurrencyForLanguage(currentLocale);
    
    return Text(
      currency.name,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

// Widget pour afficher le code de la devise (ex: EGP, USD, etc.)
class CurrencyCodeWidget extends StatelessWidget {
  final Color textColor;
  final double fontSize;
  final FontWeight? fontWeight;

  const CurrencyCodeWidget({
    Key? key,
    required this.textColor,
    required this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;
    final currency = currencyService.getCurrencyForLanguage(currentLocale);
    
    return Text(
      currency.code,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
