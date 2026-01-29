import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/extensions/transactions_extensions.dart';
import '../../../../core/services/convert_string_to_enum.dart';
import '../../../../core/services/dateformatter_service.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import '../../domain/entities/transaction_history_entity.dart';

class TransactionHistoryCard extends StatelessWidget {
  const TransactionHistoryCard({super.key, required this.transactionHistoryEntity});

  final TransactionHistoryEntity transactionHistoryEntity;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final type = TransactionTypeExtension.fromJson(transactionHistoryEntity.transactionType);
    final purpose = TransactionPurposeExtension.fromJson(transactionHistoryEntity.transactionPurpose);

    // Font size adaptatif
    final double titleFontSize = width < 350 ? 12 : 14;
    final double dateFontSize = width < 350 ? 11 : 13;
    final double amountFontSize = width < 350 ? 14 : 16;

    String transactionTitle =
        "${type.toName} ${LocaleKeys.money.tr()} ${purpose.toName} ${LocaleKeys.toKey.tr()}${getPropertyType(transactionHistoryEntity.property.propertyType).toName} ${LocaleKeys.inKey.tr()} ${transactionHistoryEntity.property.city}";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: context.scale(12), vertical: context.scale(12)),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scale(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(context.scale(6)),
            width: context.scale(32),
            height: context.scale(32),
            decoration: BoxDecoration(
              color: ColorManager.yellowColor,
              shape: BoxShape.circle,
            ),
            child: SvgImageComponent(
              iconPath: type.toIcon,
              width: context.scale(16),
              height: context.scale(16),
            ),
          ),
          SizedBox(width: context.scale(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: transactionTitle,
                  child: Text(
                    transactionTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      color: ColorManager.blackColor,
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
                SizedBox(height: context.scale(4)),
                Text(
                  DateFormatterService.getFormattedDate(
                      transactionHistoryEntity.transactionDate),
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    color: ColorManager.grey2,
                    fontSize: dateFontSize,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.scale(8)),
          Flexible(
            child: Text(
              "${transactionHistoryEntity.direction == "received" ? '+' : '-'}${transactionHistoryEntity.amount}",
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                color: transactionHistoryEntity.direction != "received"
                    ? ColorManager.redColor
                    : ColorManager.greenColor,
                fontSize: amountFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
