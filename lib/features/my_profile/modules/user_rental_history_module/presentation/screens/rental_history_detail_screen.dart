import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/currency_display_widget.dart';
import '../../../../../../core/components/custom_image.dart';
import '../../../../../../core/services/dateformatter_service.dart';
import '../../../../../../core/translation/locale_keys.dart';
import '../../domain/entity/rental_history_entity.dart';
import '../controller/rental_history_cubit.dart';

class RentalHistoryDetailScreen extends StatelessWidget {
  final RentalHistoryEntity rental;

  const RentalHistoryDetailScreen({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RentalHistoryCubit, RentalHistoryState>(
      listenWhen: (prev, curr) => prev.cancelState != curr.cancelState,
      listener: (context, state) {
        if (state.cancelState == CancelState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_cancelSuccessMsg(context)),
              backgroundColor: ColorManager.greenColor,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.cancelState == CancelState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.cancelError.isNotEmpty
                  ? state.cancelError
                  : LocaleKeys.somethingWentWrong.tr()),
              backgroundColor: ColorManager.redColor,
            ),
          );
          context.read<RentalHistoryCubit>().resetCancelState();
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.greyShade,
        appBar: AppBar(
          backgroundColor: ColorManager.whiteColor,
          foregroundColor: ColorManager.navyColor,
          title: Text(
            _detailTitle(context),
            style: getBoldStyle(
              color: ColorManager.navyColor,
              fontSize: FontSize.s16,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<RentalHistoryCubit, RentalHistoryState>(
          builder: (context, state) {
            final current = _findCurrentRental(state.rentals, rental);
            return _DetailBody(rental: current);
          },
        ),
      ),
    );
  }

  RentalHistoryEntity _findCurrentRental(
    List<RentalHistoryEntity> rentals,
    RentalHistoryEntity fallback,
  ) {
    for (final item in rentals) {
      if (item.id == fallback.id) return item;
    }
    return fallback;
  }
}

class _DetailBody extends StatelessWidget {
  final RentalHistoryEntity rental;

  const _DetailBody({required this.rental});

  @override
  Widget build(BuildContext context) {
    final isCancellable = rental.dealStatus.toLowerCase() != 'cancelled' &&
        rental.dealStatus.toLowerCase() != 'completed';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VehicleImageCard(imageUrl: rental.propertyImage),
          const SizedBox(height: 16),
          _InfoCard(rental: rental),
          const SizedBox(height: 16),
          _FinancialCard(rental: rental),
          if (isCancellable) ...[
            const SizedBox(height: 24),
            _CancelButton(rental: rental),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _VehicleImageCard extends StatelessWidget {
  final String imageUrl;

  const _VehicleImageCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomNetworkImage(
        image: imageUrl,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final RentalHistoryEntity rental;

  const _InfoCard({required this.rental});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rental.propertyTitle.isNotEmpty
                      ? rental.propertyTitle
                      : rental.propertyType,
                  style: getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
              _StatusBadge(status: rental.dealStatus),
            ],
          ),
          const SizedBox(height: 12),
          _Row(
            label: _startDateLabel(context),
            value: _fmt(rental.startDate),
          ),
          const SizedBox(height: 8),
          _Row(
            label: _endDateLabel(context),
            value: _fmt(rental.endDate),
          ),
          if (rental.clientName.isNotEmpty) ...[
            const SizedBox(height: 8),
            _Row(label: _clientLabel(context), value: rental.clientName),
          ],
          if (rental.clientPhoneNumber.isNotEmpty) ...[
            const SizedBox(height: 8),
            _Row(
                label: _phoneLabel(context),
                value: rental.clientPhoneNumber),
          ],
        ],
      ),
    );
  }

  String _fmt(String? v) {
    if (v == null || v.isEmpty) return '-';
    try {
      return DateFormatterService.getFormattedDate(v);
    } catch (_) {
      return v;
    }
  }
}

class _FinancialCard extends StatelessWidget {
  final RentalHistoryEntity rental;

  const _FinancialCard({required this.rental});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _financialTitle(context),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s14,
            ),
          ),
          const SizedBox(height: 12),
          _AmountRow(
            label: LocaleKeys.totalAmount.tr(),
            amount: rental.totalAmount,
            bold: true,
          ),
          const SizedBox(height: 8),
          _AmountRow(
            label: _paidLabel(context),
            amount: rental.paidAmount,
          ),
          const SizedBox(height: 8),
          _AmountRow(
            label: _remainingLabel(context),
            amount: (rental.totalAmount - rental.paidAmount).clamp(0, double.infinity),
          ),
        ],
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final RentalHistoryEntity rental;

  const _CancelButton({required this.rental});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentalHistoryCubit, RentalHistoryState>(
      builder: (context, state) {
        final isLoading = state.cancelState == CancelState.loading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _confirmCancel(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.redColor,
              foregroundColor: ColorManager.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _cancelLabel(context),
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
          _confirmTitle(context),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s16,
          ),
        ),
        content: Text(
          _confirmMessage(context),
          style: getMediumStyle(
            color: ColorManager.grey,
            fontSize: FontSize.s13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              _noLabel(context),
              style: getMediumStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s13,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<RentalHistoryCubit>().cancelRental(rental.id);
            },
            child: Text(
              _yesLabel(context),
              style: getBoldStyle(
                color: ColorManager.redColor,
                fontSize: FontSize.s13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: getMediumStyle(
            color: ColorManager.grey,
            fontSize: FontSize.s13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s13,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;

  const _AmountRow({
    required this.label,
    required this.amount,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: bold
                ? getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s13,
                  )
                : getMediumStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s13,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CurrencyDisplayWidget(
              amount: amount,
              textColor:
                  bold ? ColorManager.primaryColor : ColorManager.blackColor,
              fontSize: FontSize.s13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = switch (normalized) {
      'completed' => ColorManager.greenColor,
      'cancelled' => ColorManager.redColor,
      'active' || 'confirmed' => ColorManager.primaryColor,
      _ => ColorManager.yellowColor,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.isEmpty ? '-' : status,
        style: getBoldStyle(color: color, fontSize: FontSize.s11),
      ),
    );
  }
}

// ── i18n helpers ──────────────────────────────────────────────────────────────
String _detailTitle(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Détails de la location',
      'ar' => 'تفاصيل الإيجار',
      _ => 'Rental details',
    };

String _startDateLabel(BuildContext ctx) =>
    switch (ctx.locale.languageCode) {
      'fr' => 'Début',
      'ar' => 'البداية',
      _ => 'Start',
    };

String _endDateLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Fin',
      'ar' => 'النهاية',
      _ => 'End',
    };

String _clientLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Client',
      'ar' => 'العميل',
      _ => 'Client',
    };

String _phoneLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Téléphone',
      'ar' => 'الهاتف',
      _ => 'Phone',
    };

String _financialTitle(BuildContext ctx) =>
    switch (ctx.locale.languageCode) {
      'fr' => 'Informations financières',
      'ar' => 'المعلومات المالية',
      _ => 'Financial details',
    };

String _paidLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Montant payé',
      'ar' => 'المبلغ المدفوع',
      _ => 'Amount paid',
    };

String _remainingLabel(BuildContext ctx) =>
    switch (ctx.locale.languageCode) {
      'fr' => 'Reste à payer',
      'ar' => 'المبلغ المتبقي',
      _ => 'Remaining',
    };

String _cancelLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Annuler la location',
      'ar' => 'إلغاء الإيجار',
      _ => 'Cancel rental',
    };

String _cancelSuccessMsg(BuildContext ctx) =>
    switch (ctx.locale.languageCode) {
      'fr' => 'Location annulée avec succès',
      'ar' => 'تم إلغاء الإيجار بنجاح',
      _ => 'Rental cancelled successfully',
    };

String _confirmTitle(BuildContext ctx) =>
    switch (ctx.locale.languageCode) {
      'fr' => 'Confirmer l\'annulation',
      'ar' => 'تأكيد الإلغاء',
      _ => 'Confirm cancellation',
    };

String _confirmMessage(BuildContext ctx) =>
    switch (ctx.locale.languageCode) {
      'fr' => 'Êtes-vous sûr de vouloir annuler cette location ?',
      'ar' => 'هل أنت متأكد أنك تريد إلغاء هذا الإيجار؟',
      _ => 'Are you sure you want to cancel this rental?',
    };

String _noLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Non',
      'ar' => 'لا',
      _ => 'No',
    };

String _yesLabel(BuildContext ctx) => switch (ctx.locale.languageCode) {
      'fr' => 'Oui, annuler',
      'ar' => 'نعم، إلغاء',
      _ => 'Yes, cancel',
    };
