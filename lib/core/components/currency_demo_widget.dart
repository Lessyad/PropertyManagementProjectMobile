import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/style_manager.dart';
import 'currency_display_widget.dart';

class CurrencyDemoWidget extends StatefulWidget {
  const CurrencyDemoWidget({Key? key}) : super(key: key);

  @override
  _CurrencyDemoWidgetState createState() => _CurrencyDemoWidgetState();
}

class _CurrencyDemoWidgetState extends State<CurrencyDemoWidget> {
  final CurrencyService _currencyService = CurrencyService();
  String _selectedCountryCode = '+20';

  final Map<String, String> _countries = {
    '+20': 'مصر (Egypt)',
    '+222': 'موريتانيا (Mauritania)',
    '+966': 'السعودية (Saudi Arabia)',
    '+212': 'المغرب (Morocco)',
    '+971': 'الإمارات (UAE)',
    '+965': 'الكويت (Kuwait)',
    '+974': 'قطر (Qatar)',
    '+973': 'البحرين (Bahrain)',
    '+968': 'عمان (Oman)',
    '+962': 'الأردن (Jordan)',
    '+961': 'لبنان (Lebanon)',
    '+963': 'سوريا (Syria)',
    '+964': 'العراق (Iraq)',
    '+98': 'إيران (Iran)',
    '+90': 'تركيا (Turkey)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Demo'),
        backgroundColor: ColorManager.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélecteur de pays
            Text(
              'Select Country:',
              style: getBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCountryCode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Country',
              ),
              items: _countries.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCountryCode = newValue;
                  });
                  // Simuler le changement de pays dans SharedPreferences
                  // Simuler le changement de pays - en réalité, cela devrait être fait via SharedPreferencesService
                  // _currencyService._prefsService.setValue('country_code_number', newValue);
                }
              },
            ),
            const SizedBox(height: 32),
            
            // Affichage de la devise actuelle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorManager.primaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Currency Information:',
                    style: getBoldStyle(
                      color: ColorManager.blackColor,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCurrencyInfo('Country Code:', _selectedCountryCode),
                  _buildCurrencyInfo('Currency Code:', _currencyService.getPreferredCurrency().code),
                  _buildCurrencyInfo('Currency Symbol:', _currencyService.getCurrentCurrencySymbol()),
                  _buildCurrencyInfo('Currency Name:', _currencyService.getPreferredCurrency().name),
                  _buildCurrencyInfo('Per Day Label:', _currencyService.getCurrentCurrencyPerDayLabel()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Exemples d'affichage de montants
            Text(
              'Amount Examples:',
              style: getBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s16,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildAmountExample('Daily Price:', 150.0),
            _buildAmountExample('Weekly Price:', 1000.0),
            _buildAmountExample('Monthly Price:', 4000.0),
            
            const SizedBox(height: 24),
            
            // Exemple d'affichage "per day"
            Text(
              'Per Day Examples:',
              style: getBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s16,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Text(
                  '150 ',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                BoldCurrencyPerDayWidget(
                  textColor: ColorManager.primaryColor,
                  fontSize: FontSize.s18,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Text(
                  '200 ',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                BoldCurrencyPerDayWidget(
                  textColor: ColorManager.primaryColor,
                  fontSize: FontSize.s18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: getMediumStyle(
              color: ColorManager.greyColor,
              fontSize: FontSize.s14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountExample(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: getMediumStyle(
              color: ColorManager.greyColor,
              fontSize: FontSize.s14,
            ),
          ),
          const SizedBox(width: 8),
          BoldCurrencyDisplayWidget(
            amount: amount,
            textColor: ColorManager.primaryColor,
            fontSize: FontSize.s16,
          ),
        ],
      ),
    );
  }
}
