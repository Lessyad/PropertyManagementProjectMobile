import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../constants/api_constants.dart';
import '../services/currency_service.dart';
import '../translation/locale_keys.dart';

class BankilyMerchantCodeBox extends StatefulWidget {
  const BankilyMerchantCodeBox({super.key});

  @override
  State<BankilyMerchantCodeBox> createState() => _BankilyMerchantCodeBoxState();
}

class _BankilyMerchantCodeBoxState extends State<BankilyMerchantCodeBox> {
  late final Future<String> _merchantCodeFuture;

  @override
  void initState() {
    super.initState();
    _merchantCodeFuture = _fetchMerchantCode();
  }

  Future<String> _fetchMerchantCode() async {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Si l'utilisateur a un pays connu, on cherche d'abord un code dedie a ce pays
    final countryCode = CurrencyService().getCurrentUserCountry();
    if (countryCode != null && countryCode.isNotEmpty) {
      final suffix = countryCode.replaceAll('+', '');
      final countrySpecific =
          await _fetchConfigValue(dio, 'BankilyMerchantCode_$suffix');
      if (countrySpecific.isNotEmpty) return countrySpecific;
    }

    // Sinon, on retombe sur le code par defaut
    return await _fetchConfigValue(dio, 'BankilyMerchantCode');
  }

  Future<String> _fetchConfigValue(Dio dio, String key) async {
    try {
      final response = await dio.get('${ApiConstants.appConfigsPublic}$key');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final stringVal = data['stringValue'] as String?;
        if (stringVal != null && stringVal.isNotEmpty) return stringVal;
        final numVal = data['value'];
        if (numVal != null) {
          final d = (numVal as num).toDouble();
          return d == d.truncateToDouble() ? d.toInt().toString() : d.toString();
        }
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_android, color: ColorManager.primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.bankilyMerchantCodeLabel.tr(),
                  style: getRegularStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<String>(
                  future: _merchantCodeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorManager.primaryColor,
                        ),
                      );
                    }
                    final code = snapshot.data ?? '';
                    return Text(
                      code.isNotEmpty ? code : '—',
                      style: getBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s20,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
