import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import '../components/charge_screen_wallet_data_container.dart';
import '../components/transaction_history_list.dart';

class ChargeWalletScreen extends StatelessWidget {
  const ChargeWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Adaptation du padding selon taille écran
    final horizontalPadding = width < 400 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ChargeScreenWalletDataContainer(),
            SizedBox(height: context.scale(12)),

            /// Le reste doit pouvoir scroller
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TransactionHistoryList(
                    title: LocaleKeys.chargeWalletScreenTitle.tr(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
