import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/services/currency_service.dart';
import '../../../../core/services/country_detection_service.dart';
import '../../../../core/components/currency_display_widget.dart';
import '../../../../core/components/country_selector_widget.dart';

class CurrencyDemoScreen extends StatefulWidget {
  const CurrencyDemoScreen({Key? key}) : super(key: key);

  @override
  _CurrencyDemoScreenState createState() => _CurrencyDemoScreenState();
}

class _CurrencyDemoScreenState extends State<CurrencyDemoScreen> {
  final CurrencyService _currencyService = CurrencyService();
  final CountryDetectionService _countryDetectionService = CountryDetectionService();
  String? _currentCountryCode;

  @override
  void initState() {
    super.initState();
    _loadCurrentCountry();
  }

  Future<void> _loadCurrentCountry() async {
    final countryCode = _currencyService.getCurrentUserCountry();
    setState(() {
      _currentCountryCode = countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency System Demo',
          style: getBoldStyle(
            color: ColorManager.whiteColor,
            fontSize: FontSize.s20,
          ),
        ),
        backgroundColor: ColorManager.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélecteur de pays
            CountrySelectorWidget(
              initialCountryCode: _currentCountryCode,
              onCountrySelected: (countryCode) {
                setState(() {
                  _currentCountryCode = countryCode;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Informations sur la devise actuelle
            _buildCurrentCurrencyInfo(),
            
            const SizedBox(height: 24),
            
            // Exemples d'affichage de montants
            _buildAmountExamples(),
            
            const SizedBox(height: 24),
            
            // Exemples d'affichage "par jour"
            _buildPerDayExamples(),
            
            const SizedBox(height: 24),
            
            // Boutons d'action
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCurrencyInfo() {
    final currentCurrency = _currencyService.getPreferredCurrency();
    final currentLocale = context.locale.languageCode;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Currency Information / معلومات العملة الحالية / Informations sur la devise actuelle',
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Country Code / رمز البلد / Code pays:', _currentCountryCode ?? 'Not set'),
          _buildInfoRow('Currency Code / رمز العملة / Code devise:', currentCurrency.code),
          _buildInfoRow('Currency Symbol / رمز العملة / Symbole:', currentCurrency.symbol),
          _buildInfoRow('Currency Name / اسم العملة / Nom:', currentCurrency.name),
          _buildInfoRow('Per Day Label / لكل يوم / Par jour:', currentCurrency.perDayLabel),
          _buildInfoRow('Current Locale / اللغة الحالية / Locale actuel:', currentLocale),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: getMediumStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: getBoldStyle(
                color: ColorManager.primaryColor,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountExamples() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Examples / أمثلة على المبالغ / Exemples de montants',
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),
          _buildAmountExample('Daily Price / السعر اليومي / Prix journalier:', 150.0),
          _buildAmountExample('Weekly Price / السعر الأسبوعي / Prix hebdomadaire:', 1000.0),
          _buildAmountExample('Monthly Price / السعر الشهري / Prix mensuel:', 4000.0),
          _buildAmountExample('Small Amount / مبلغ صغير / Petit montant:', 25.50),
          _buildAmountExample('Large Amount / مبلغ كبير / Gros montant:', 15000.75),
        ],
      ),
    );
  }

  Widget _buildAmountExample(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: getMediumStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: BoldCurrencyDisplayWidget(
              amount: amount,
              textColor: ColorManager.primaryColor,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerDayExamples() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Per Day Examples / أمثلة لكل يوم / Exemples par jour',
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),
          _buildPerDayExample('Vehicle Rental / تأجير المركبة / Location véhicule:', 150.0),
          _buildPerDayExample('Insurance / التأمين / Assurance:', 25.0),
          _buildPerDayExample('Child Seat / مقعد الأطفال / Siège enfant:', 15.0),
        ],
      ),
    );
  }

  Widget _buildPerDayExample(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: getMediumStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                BoldCurrencyDisplayWidget(
                  amount: amount,
                  textColor: ColorManager.primaryColor,
                  fontSize: FontSize.s14,
                ),
                const SizedBox(width: 4),
                BoldCurrencyPerDayWidget(
                  textColor: ColorManager.primaryColor,
                  fontSize: FontSize.s14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final detectedCountry = await _countryDetectionService.detectUserCountry();
              if (detectedCountry != null) {
                setState(() {
                  _currentCountryCode = detectedCountry;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Country detected: $detectedCountry'),
                    backgroundColor: ColorManager.primaryColor,
                  ),
                );
              }
            },
            icon: const Icon(Icons.location_on),
            label: Text('Auto Detect Country / كشف البلد تلقائياً / Détection automatique'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: ColorManager.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await _countryDetectionService.resetCountryDetection();
              setState(() {
                _currentCountryCode = '+20';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Country reset to default (Egypt)'),
                  backgroundColor: ColorManager.grey,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: Text('Reset to Default / إعادة تعيين / Réinitialiser'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorManager.primaryColor,
              side: BorderSide(color: ColorManager.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
