import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../core/services/currency_service.dart';

class VehicleCurrencyDisplayWidget extends StatelessWidget {
  final double amount;
  final String? customLabel;
  final bool showPerDay;
  final bool useDefaultCurrency;
  final TextStyle? amountStyle;
  final TextStyle? currencyStyle;

  const VehicleCurrencyDisplayWidget({
    Key? key,
    required this.amount,
    this.customLabel,
    this.showPerDay = false,
    this.useDefaultCurrency = true,
    this.amountStyle,
    this.currencyStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;

    // Obtenir la devise selon la langue et le pays
    final currencyInfo = currencyService.getCurrencyForLanguage(currentLocale);

    // Utiliser MRU par défaut si demandé, sinon la devise du pays
    final displayCurrency = useDefaultCurrency
        ? _getDefaultCurrencyInfo(currentLocale)
        : (currencyInfo ?? _getDefaultCurrencyInfo(currentLocale));

    // Formater le montant
    final formattedAmount = amount.toStringAsFixed(2);

    // Construire le label de devise
    String currencyLabel;
    if (customLabel != null) {
      currencyLabel = customLabel!;
    } else if (showPerDay) {
      currencyLabel = useDefaultCurrency
          ? tr(LocaleKeys.currency_per_day)
          : displayCurrency.perDayLabel;
    } else {
      currencyLabel = displayCurrency.symbol;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Montant
        Text(
          formattedAmount,
          style: amountStyle ?? getBoldStyle(
            color: ColorManager.primaryColor,
            fontSize: FontSize.s16,
          ),
        ),
        const SizedBox(width: 4),
        // Devise
        Text(
          currencyLabel,
          style: currencyStyle ?? getRegularStyle(
            color: ColorManager.grey,
            fontSize: FontSize.s14,
          ),
        ),
      ],
    );
  }

  /// Obtient les informations de devise par défaut (MRU) selon la langue
  CurrencyInfo _getDefaultCurrencyInfo(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return CurrencyInfo(
          code: 'MRU',
          symbol: tr(LocaleKeys.default_currency_mru),
          name: 'أوقية موريتانية',
          perDayLabel: tr(LocaleKeys.currency_per_day),
        );
      case 'en':
        return CurrencyInfo(
          code: 'MRU',
          symbol: tr(LocaleKeys.default_currency_mru),
          name: 'Mauritanian Ouguiya',
          perDayLabel: tr(LocaleKeys.currency_per_day),
        );
      case 'fr':
        return CurrencyInfo(
          code: 'MRU',
          symbol: tr(LocaleKeys.default_currency_mru),
          name: 'Ouguiya mauritanienne',
          perDayLabel: tr(LocaleKeys.currency_per_day),
        );
      default:
        return CurrencyInfo(
          code: 'MRU',
          symbol: tr(LocaleKeys.default_currency_mru),
          name: 'أوقية موريتانية',
          perDayLabel: tr(LocaleKeys.currency_per_day),
        );
    }
  }
}

class VehiclePriceDisplayWidget extends StatelessWidget {
  final double price;
  final String? title;
  final bool isTotal;
  final bool showPerDay;

  const VehiclePriceDisplayWidget({
    Key? key,
    required this.price,
    this.title,
    this.isTotal = false,
    this.showPerDay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTotal ? ColorManager.primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isTotal
            ? Border.all(color: ColorManager.primaryColor, width: 2)
            : Border.all(color: ColorManager.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre
          Text(
            title ?? (isTotal ? tr(LocaleKeys.total_amount) : tr(LocaleKeys.payment_amount)),
            style: getMediumStyle(
              color: isTotal ? ColorManager.primaryColor : ColorManager.grey,
              fontSize: FontSize.s14,
            ),
          ),
          // Prix avec devise
          VehicleCurrencyDisplayWidget(
            amount: price,
            showPerDay: showPerDay,
            useDefaultCurrency: true, // Toujours utiliser MRU par défaut
            amountStyle: getBoldStyle(
              color: isTotal ? ColorManager.primaryColor : ColorManager.grey,
              fontSize: FontSize.s16,
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleCurrencySelectorWidget extends StatefulWidget {
  final String? selectedCurrency;
  final Function(String) onCurrencyChanged;

  const VehicleCurrencySelectorWidget({
    Key? key,
    this.selectedCurrency,
    required this.onCurrencyChanged,
  }) : super(key: key);

  @override
  State<VehicleCurrencySelectorWidget> createState() => _VehicleCurrencySelectorWidgetState();
}

class _VehicleCurrencySelectorWidgetState extends State<VehicleCurrencySelectorWidget> {
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.selectedCurrency ?? 'MRU'; // MRU par défaut
  }

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final currentLocale = context.locale.languageCode;

    // Obtenir la devise du pays actuel
    final countryCurrency = currencyService.getCurrencyForLanguage(currentLocale);

    // Liste des devises disponibles (MRU par défaut + devise du pays si différente)
    final List<Map<String, dynamic>> availableCurrencies = [
      {'code': 'MRU', 'name': tr(LocaleKeys.default_currency_mru), 'isDefault': true},
    ];

    // Ajouter la devise du pays seulement si elle est différente de MRU
    if (countryCurrency != null && countryCurrency.code != 'MRU') {
      availableCurrencies.add({
        'code': countryCurrency.code,
        'name': countryCurrency.symbol,
        'isDefault': false,
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.currency), // Utilisez une clé de traduction appropriée
            style: getMediumStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s14,
            ),
          ),
          const SizedBox(height: 12),
          ...availableCurrencies.map((currency) {
            final isSelected = _selectedCurrency == currency['code'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCurrency = currency['code'] as String;
                });
                widget.onCurrencyChanged(_selectedCurrency!);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? ColorManager.primaryColor
                        : ColorManager.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? ColorManager.primaryColor : ColorManager.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      currency['name'] as String,
                      style: getRegularStyle(
                        color: isSelected ? ColorManager.primaryColor : ColorManager.grey,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    if (currency['isDefault'] as bool) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tr(LocaleKeys.yes), // Utilisez une clé de traduction
                          style: getRegularStyle(
                            color: Colors.white,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}