import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/commercial_management/data/models/property_sale_summary_model.dart';
import 'package:flutter/material.dart';

enum _CommercialFilter {
  all,
  reserved,
  paid,
  remaining,
}

class CommercialManagementScreen extends StatefulWidget {
  const CommercialManagementScreen({super.key});

  @override
  State<CommercialManagementScreen> createState() =>
      _CommercialManagementScreenState();
}

class _CommercialManagementScreenState
    extends State<CommercialManagementScreen> {
  _CommercialFilter _selectedFilter = _CommercialFilter.all;
  late Future<List<PropertySaleSummaryModel>> _salesFuture;

  @override
  void initState() {
    super.initState();
    _salesFuture = _getSalesSummary();
  }

  Future<List<PropertySaleSummaryModel>> _getSalesSummary() async {
    final response = await ServiceLocator.getIt<DioService>().get(
      url: ApiConstants.myPropertySalesSummary,
    );

    final List<dynamic> results = response.data['results'] ?? [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(PropertySaleSummaryModel.fromJson)
        .toList();
  }

  void _refreshSales() {
    setState(() {
      _salesFuture = _getSalesSummary();
    });
  }

  List<PropertySaleSummaryModel> _filteredRecords(
    List<PropertySaleSummaryModel> records,
  ) {
    switch (_selectedFilter) {
      case _CommercialFilter.reserved:
        return records.where((record) => record.isReserved).toList();
      case _CommercialFilter.paid:
        return records.where((record) => record.isPaid).toList();
      case _CommercialFilter.remaining:
        return records
            .where((record) => record.systemRemainingAmount > 0)
            .toList();
      case _CommercialFilter.all:
        return records;
    }
  }

  double _totalAmount(List<PropertySaleSummaryModel> records) =>
      records.fold(0, (total, record) => total + record.ownerPortion);

  double _paidAmount(List<PropertySaleSummaryModel> records) =>
      records.fold(0, (total, record) => total + record.systemPaidAmount);

  double _remainingAmount(List<PropertySaleSummaryModel> records) =>
      records.fold(0, (total, record) => total + record.systemRemainingAmount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: _text(context, 'title'),
            showNotificationIcon: false,
            showLocationIcon: false,
            showBackIcon: true,
            centerText: true,
          ),
          Expanded(
            child: FutureBuilder<List<PropertySaleSummaryModel>>(
              future: _salesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _CommercialError(
                    message: _text(context, 'loadError'),
                    onRetry: _refreshSales,
                  );
                }

                final records = snapshot.data ?? [];
                final filteredRecords = _filteredRecords(records);

                if (records.isEmpty) {
                  return _CommercialEmpty(message: _text(context, 'empty'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _refreshSales(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      _CommercialSummary(
                        totalAmount: _totalAmount(records),
                        paidAmount: _paidAmount(records),
                        remainingAmount: _remainingAmount(records),
                        recordsCount: records.length,
                        text: (key) => _text(context, key),
                      ),
                      SizedBox(height: context.scale(14)),
                      _FilterChips(
                        selectedFilter: _selectedFilter,
                        onChanged: (filter) {
                          setState(() => _selectedFilter = filter);
                        },
                        text: (key) => _text(context, key),
                      ),
                      SizedBox(height: context.scale(10)),
                      ...filteredRecords.map(
                        (record) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CommercialClientCard(
                            record: record,
                            text: (key) => _text(context, key),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommercialError extends StatelessWidget {
  const _CommercialError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: ColorManager.redColor, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s15,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: ColorManager.whiteColor,
              ),
              child: Text(_text(context, 'retry')),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommercialEmpty extends StatelessWidget {
  const _CommercialEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              color: ColorManager.primaryColor,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommercialSummary extends StatelessWidget {
  const _CommercialSummary({
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.recordsCount,
    required this.text,
  });

  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final int recordsCount;
  final String Function(String key) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: ColorManager.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text('summary'),
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: FontSize.s18,
                  ),
                ),
              ),
              _CountBadge(count: recordsCount),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: text('total'),
                  value: _formatMoney(totalAmount),
                  color: ColorManager.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryMetric(
                  label: text('paid'),
                  value: _formatMoney(paidAmount),
                  color: ColorManager.greenColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryMetric(
                  label: text('remaining'),
                  value: _formatMoney(remainingAmount),
                  color: ColorManager.yellowColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            style: getSemiBoldStyle(
              color: ColorManager.grey2,
              fontSize: FontSize.s12,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              style: getBoldStyle(
                color: color,
                fontSize: FontSize.s16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedFilter,
    required this.onChanged,
    required this.text,
  });

  final _CommercialFilter selectedFilter;
  final ValueChanged<_CommercialFilter> onChanged;
  final String Function(String key) text;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _CommercialFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              selected: isSelected,
              showCheckmark: false,
              label: Text(_filterLabel(filter)),
              selectedColor: ColorManager.primaryColor,
              backgroundColor: ColorManager.whiteColor,
              side: BorderSide(
                color:
                    isSelected ? ColorManager.primaryColor : ColorManager.grey3,
              ),
              labelStyle: getSemiBoldStyle(
                color: isSelected
                    ? ColorManager.whiteColor
                    : ColorManager.blackColor,
                fontSize: FontSize.s13,
              ),
              onSelected: (_) => onChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(_CommercialFilter filter) {
    switch (filter) {
      case _CommercialFilter.all:
        return text('all');
      case _CommercialFilter.reserved:
        return text('reserved');
      case _CommercialFilter.paid:
        return text('paid');
      case _CommercialFilter.remaining:
        return text('remaining');
    }
  }
}

class _CommercialClientCard extends StatelessWidget {
  const _CommercialClientCard({
    required this.record,
    required this.text,
  });

  final PropertySaleSummaryModel record;
  final String Function(String key) text;

  @override
  Widget build(BuildContext context) {
    final progress = record.ownerPortion == 0
        ? 0.0
        : (record.systemPaidAmount / record.ownerPortion).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorManager.grey3.withValues(alpha: 0.6)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ClientAvatar(name: record.sellerName),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.sellerName.isEmpty ? '-' : record.sellerName,
                      maxLines: 1,
                      style: getBoldStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      record.sellerPhoneNumber.isEmpty
                          ? '-'
                          : record.sellerPhoneNumber,
                      maxLines: 1,
                      style: getSemiBoldStyle(
                        color: ColorManager.grey2,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: _statusLabel(record, text),
                color: _statusColor(record),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.apartment,
            label: text('property'),
            value: '${record.propertyTitle} - #${record.propertyId}',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.person_outline,
            label: text('client'),
            value: _clientLabel(record),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.event_available_outlined,
            label: text('date'),
            value: _formatDate(record.dealDate),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.account_balance_wallet_outlined,
            label: text('clientPaid'),
            value: _formatMoney(record.paidAmount),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: ColorManager.grey3,
              valueColor: AlwaysStoppedAnimation<Color>(
                record.systemRemainingAmount == 0
                    ? ColorManager.greenColor
                    : ColorManager.yellowColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PaymentLine(
                  label: text('paid'),
                  value: _formatMoney(record.systemPaidAmount),
                  color: ColorManager.greenColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PaymentLine(
                  label: text('remaining'),
                  value: _formatMoney(record.systemRemainingAmount),
                  color: record.systemRemainingAmount == 0
                      ? ColorManager.greenColor
                      : ColorManager.redColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ColorManager.grey2),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: getSemiBoldStyle(
            color: ColorManager.grey2,
            fontSize: FontSize.s12,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
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

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            style: getSemiBoldStyle(
              color: ColorManager.grey2,
              fontSize: FontSize.s12,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              style: getBoldStyle(
                color: color,
                fontSize: FontSize.s15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientAvatar extends StatelessWidget {
  const _ClientAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: ColorManager.primaryColor2,
      child: Text(
        name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase(),
        style: getBoldStyle(
          color: ColorManager.primaryColor,
          fontSize: FontSize.s16,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 28, minWidth: 70),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.s12,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 34, minHeight: 30),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        count.toString(),
        style: getBoldStyle(
          color: ColorManager.primaryColor,
          fontSize: FontSize.s14,
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  final formatter = NumberFormat.decimalPattern('fr');
  return '${formatter.format(value)} MRU';
}

String _clientLabel(PropertySaleSummaryModel record) {
  if (record.clientPhoneNumber.isEmpty) return record.clientName;
  return '${record.clientName} - ${record.clientPhoneNumber}';
}

String _formatDate(DateTime? value) {
  if (value == null) return '-';
  return DateFormat('dd/MM/yyyy').format(value);
}

Color _statusColor(PropertySaleSummaryModel record) {
  final dealStatus = record.status.toLowerCase();
  if (record.isSold) return ColorManager.greenColor;
  if (record.isReserved) return ColorManager.yellowColor;
  if (dealStatus == 'pending' || dealStatus == 'confirmed') {
    return ColorManager.yellowColor;
  }
  if (dealStatus == 'completed') return ColorManager.greenColor;
  if (dealStatus == 'cancelled') return ColorManager.redColor;
  return ColorManager.primaryColor;
}

String _statusLabel(
  PropertySaleSummaryModel record,
  String Function(String key) text,
) {
  final dealStatus = record.status.toLowerCase();
  if (record.isSold) return text('sold');
  if (record.isReserved) return text('reserved');
  if (dealStatus == 'pending' || dealStatus == 'confirmed') {
    return text('reserved');
  }
  if (dealStatus == 'completed') return text('sold');
  if (dealStatus == 'cancelled') return text('cancelled');
  return record.status.isEmpty ? '-' : record.status;
}

String _text(BuildContext context, String key) {
  final labels = switch (context.locale.languageCode) {
    'ar' => _arLabels,
    'fr' => _frLabels,
    _ => _enLabels,
  };
  return labels[key] ?? _enLabels[key] ?? key;
}

const Map<String, String> _frLabels = {
  'title': 'Gestion commerciale',
  'summary': 'Mes reservations commerciales',
  'total': 'Total a recevoir',
  'paid': 'Verse par le systeme',
  'remaining': 'Reste a recevoir',
  'all': 'Tous',
  'reserved': 'Reserve',
  'sold': 'Vendu',
  'cancelled': 'Annule',
  'property': 'Propriete',
  'seller': 'Vendeur',
  'client': 'Client',
  'date': 'Date',
  'clientPaid': 'Montant reservation',
  'loadError': 'Impossible de charger les donnees commerciales',
  'retry': 'Reessayer',
  'empty': 'Aucune reservation sur vos proprietes',
};

const Map<String, String> _enLabels = {
  'title': 'Commercial management',
  'summary': 'My commercial reservations',
  'total': 'Total to receive',
  'paid': 'Paid by system',
  'remaining': 'Left to receive',
  'all': 'All',
  'reserved': 'Reserved',
  'sold': 'Sold',
  'cancelled': 'Cancelled',
  'property': 'Property',
  'seller': 'Seller',
  'client': 'Client',
  'date': 'Date',
  'clientPaid': 'Reservation amount',
  'loadError': 'Unable to load commercial data',
  'retry': 'Retry',
  'empty': 'No reservations on your properties',
};

const Map<String, String> _arLabels = {
  'title': 'الإدارة التجارية',
  'summary': 'حجوزاتي التجارية',
  'total': 'إجمالي المستحق',
  'paid': 'مدفوع من النظام',
  'remaining': 'المتبقي للاستلام',
  'all': 'الكل',
  'reserved': 'محجوز',
  'sold': 'مباع',
  'cancelled': 'ملغى',
  'property': 'العقار',
  'seller': 'البائع',
  'client': 'العميل',
  'date': 'التاريخ',
  'clientPaid': 'مبلغ الحجز',
  'loadError': 'تعذر تحميل بيانات الإدارة التجارية',
  'retry': 'إعادة المحاولة',
  'empty': 'لا توجد حجوزات على عقاراتك',
};
