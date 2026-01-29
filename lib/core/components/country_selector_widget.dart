import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/currency_service.dart';
import '../services/country_detection_service.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';

class CountrySelectorWidget extends StatefulWidget {
  final Function(String)? onCountrySelected;
  final String? initialCountryCode;

  const CountrySelectorWidget({
    Key? key,
    this.onCountrySelected,
    this.initialCountryCode,
  }) : super(key: key);

  @override
  _CountrySelectorWidgetState createState() => _CountrySelectorWidgetState();
}

class _CountrySelectorWidgetState extends State<CountrySelectorWidget> {
  final CurrencyService _currencyService = CurrencyService();
  final CountryDetectionService _countryDetectionService = CountryDetectionService();
  String? _selectedCountryCode;

  final Map<String, Map<String, String>> _countries = {
    '+20': {
      'name': 'مصر',
      'nameEn': 'Egypt',
      'nameFr': 'Égypte',
      'flag': '🇪🇬',
    },
    '+222': {
      'name': 'موريتانيا',
      'nameEn': 'Mauritania',
      'nameFr': 'Mauritanie',
      'flag': '🇲🇷',
    },
    '+966': {
      'name': 'السعودية',
      'nameEn': 'Saudi Arabia',
      'nameFr': 'Arabie Saoudite',
      'flag': '🇸🇦',
    },
    '+212': {
      'name': 'المغرب',
      'nameEn': 'Morocco',
      'nameFr': 'Maroc',
      'flag': '🇲🇦',
    },
    '+971': {
      'name': 'الإمارات',
      'nameEn': 'UAE',
      'nameFr': 'Émirats Arabes Unis',
      'flag': '🇦🇪',
    },
    '+965': {
      'name': 'الكويت',
      'nameEn': 'Kuwait',
      'nameFr': 'Koweït',
      'flag': '🇰🇼',
    },
    '+974': {
      'name': 'قطر',
      'nameEn': 'Qatar',
      'nameFr': 'Qatar',
      'flag': '🇶🇦',
    },
    '+973': {
      'name': 'البحرين',
      'nameEn': 'Bahrain',
      'nameFr': 'Bahreïn',
      'flag': '🇧🇭',
    },
    '+968': {
      'name': 'عمان',
      'nameEn': 'Oman',
      'nameFr': 'Oman',
      'flag': '🇴🇲',
    },
    '+962': {
      'name': 'الأردن',
      'nameEn': 'Jordan',
      'nameFr': 'Jordanie',
      'flag': '🇯🇴',
    },
    '+961': {
      'name': 'لبنان',
      'nameEn': 'Lebanon',
      'nameFr': 'Liban',
      'flag': '🇱🇧',
    },
    '+963': {
      'name': 'سوريا',
      'nameEn': 'Syria',
      'nameFr': 'Syrie',
      'flag': '🇸🇾',
    },
    '+964': {
      'name': 'العراق',
      'nameEn': 'Iraq',
      'nameFr': 'Irak',
      'flag': '🇮🇶',
    },
    '+98': {
      'name': 'إيران',
      'nameEn': 'Iran',
      'nameFr': 'Iran',
      'flag': '🇮🇷',
    },
    '+90': {
      'name': 'تركيا',
      'nameEn': 'Turkey',
      'nameFr': 'Turquie',
      'flag': '🇹🇷',
    },
  };

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode ?? 
                          _currencyService.getCurrentUserCountry() ?? 
                          '+20';
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Country / اختر بلدك / Choisissez votre pays',
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),
          
          // Affichage du pays actuellement sélectionné
          if (_selectedCountryCode != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _countries[_selectedCountryCode!]!['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCountryName(_selectedCountryCode!, currentLocale),
                          style: getBoldStyle(
                            color: ColorManager.primaryColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        Text(
                          'Currency: ${_currencyService.getPreferredCurrency().name}',
                          style: getRegularStyle(
                            color: ColorManager.grey,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Liste des pays
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                String countryCode = _countries.keys.elementAt(index);
                Map<String, String> countryInfo = _countries[countryCode]!;
                bool isSelected = _selectedCountryCode == countryCode;
                
                return ListTile(
                  leading: Text(
                    countryInfo['flag']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    _getCountryName(countryCode, currentLocale),
                    style: getMediumStyle(
                      color: isSelected ? ColorManager.primaryColor : ColorManager.blackColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  subtitle: Text(
                    '${_currencyService.getCurrencyForLanguage(currentLocale).symbol} - ${countryCode}',
                    style: getRegularStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: ColorManager.primaryColor,
                        )
                      : null,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCountryCode = countryCode;
                    });
                    _currencyService.setUserCountry(countryCode);
                    widget.onCountrySelected?.call(countryCode);
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    String? detectedCountry = await _countryDetectionService.detectUserCountry();
                    if (detectedCountry != null) {
                      setState(() {
                        _selectedCountryCode = detectedCountry;
                      });
                      widget.onCountrySelected?.call(detectedCountry);
                    }
                  },
                  icon: const Icon(Icons.location_on),
                  label: Text('Auto Detect / كشف تلقائي / Détection auto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    foregroundColor: ColorManager.whiteColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await _countryDetectionService.resetCountryDetection();
                    setState(() {
                      _selectedCountryCode = '+20';
                    });
                    widget.onCountrySelected?.call('+20');
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text('Reset / إعادة تعيين / Réinitialiser'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.primaryColor,
                    side: BorderSide(color: ColorManager.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCountryName(String countryCode, String locale) {
    Map<String, String> countryInfo = _countries[countryCode]!;
    switch (locale) {
      case 'ar':
        return countryInfo['name']!;
      case 'en':
        return countryInfo['nameEn']!;
      case 'fr':
        return countryInfo['nameFr']!;
      default:
        return countryInfo['nameEn']!;
    }
  }
}
