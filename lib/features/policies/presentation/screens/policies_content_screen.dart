import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/request_states_extension.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../domain/entities/policy_entity.dart';
import '../components/collapsible_policy_card.dart';
import '../controller/policies_cubit.dart';

class PoliciesContentScreen extends StatefulWidget {
  const PoliciesContentScreen({super.key});

  @override
  State<PoliciesContentScreen> createState() => _PoliciesContentScreenState();
}

class _PoliciesContentScreenState extends State<PoliciesContentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PoliciesCubit>().getPolicies();
  }

  String _localizedType(String type) {
    switch (type.toLowerCase()) {
      case 'privacy':
        return LocaleKeys.policyTypePrivacy.tr();
      case 'terms':
        return LocaleKeys.policyTypeTerms.tr();
      case 'conditioninput':
        return LocaleKeys.policyTypeConditionInput.tr();
      default:
        return type;
    }
  }

  List<String> _lines(String content) => content
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.policiesScreenTitle.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            showBackIcon: true,
            centerText: true,
          ),
          Expanded(
            child: BlocBuilder<PoliciesCubit, PoliciesState>(
              builder: (context, state) {
                if (state.getPoliciesState.isLoading ||
                    state.getPoliciesState.isInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: ColorManager.primaryColor),
                  );
                }
                if (state.getPoliciesState.isError) {
                  return _buildError(context);
                }
                if (state.policies.isEmpty) {
                  return Center(
                    child: Text(LocaleKeys.policiesEmpty.tr(),
                        style: getMediumStyle(color: ColorManager.grey2)),
                  );
                }
                return _buildContent(context, state.policies);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<PolicyEntity> policies) {
    // Grouper par type : un seul en-tête par type, tous les contenus regroupés
    final Map<String, List<String>> grouped = {};
    for (final policy in policies) {
      final key = policy.type.toLowerCase();
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.addAll(_lines(policy.content));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        context.scale(16),
        context.scale(12),
        context.scale(16),
        context.scale(32),
      ),
      child: Column(
        children: grouped.entries.map((entry) {
          // Même carte repliable (aperçu par caractères + "Lire plus")
          // que dans l'écran des informations du locataire.
          return CollapsiblePolicyCard(
            title: _localizedType(entry.key),
            icon: _iconForType(entry.key),
            content: entry.value.join('\n'),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined,
              size: context.scale(64), color: ColorManager.grey3),
          SizedBox(height: context.scale(16)),
          Text(
            LocaleKeys.policiesLoadError.tr(),
            style: getMediumStyle(color: ColorManager.grey2),
          ),
          SizedBox(height: context.scale(16)),
          ElevatedButton(
            onPressed: () => context.read<PoliciesCubit>().getPolicies(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.scale(24)),
              ),
            ),
            child: Text(
              LocaleKeys.retryButton.tr(),
              style: getBoldStyle(
                  color: ColorManager.whiteColor, fontSize: FontSize.s14),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'privacy':
        return Icons.shield_outlined;
      case 'terms':
        return Icons.description_outlined;
      default:
        return Icons.policy_outlined;
    }
  }
}
