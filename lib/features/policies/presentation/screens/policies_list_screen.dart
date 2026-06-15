import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/request_states_extension.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../domain/entities/policy_entity.dart';
import '../controller/policies_cubit.dart';

class PoliciesListScreen extends StatefulWidget {
  const PoliciesListScreen({super.key});

  @override
  State<PoliciesListScreen> createState() => _PoliciesListScreenState();
}

class _PoliciesListScreenState extends State<PoliciesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PoliciesCubit>().getPolicies();
  }

  String _localizedType(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'privacy':
        return LocaleKeys.policyTypePrivacy.tr();
      case 'terms':
        return LocaleKeys.policyTypeTerms.tr();
      default:
        return type;
    }
  }

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
                  return _buildLoading(context);
                }
                if (state.getPoliciesState.isError) {
                  return _buildError(context);
                }
                if (state.policies.isEmpty) {
                  return _buildEmpty(context);
                }
                return _buildList(context, state.policies);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<PolicyEntity> policies) {
    return RefreshIndicator(
      color: ColorManager.primaryColor,
      onRefresh: () async => context.read<PoliciesCubit>().getPolicies(),
      child: ListView(
        padding: EdgeInsets.all(context.scale(16)),
        children: [
          SizedBox(height: context.scale(8)),
          Container(
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(context.scale(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: List.generate(policies.length, (index) {
                final policy = policies[index];
                final isLast = index == policies.length - 1;
                return _PolicyListTile(
                  index: index + 1,
                  title: _localizedType(context, policy.type),
                  showDivider: !isLast,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RoutersNames.policyDetailScreen,
                    arguments: {
                      'policy': policy,
                      'title': _localizedType(context, policy.type),
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.scale(16)),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.whiteColor,
          borderRadius: BorderRadius.circular(context.scale(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scale(20),
                    vertical: context.scale(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.scale(32),
                        height: context.scale(32),
                        decoration: BoxDecoration(
                          color: ColorManager.grey3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: context.scale(16)),
                      Expanded(
                        child: Container(
                          height: context.scale(14),
                          width: context.scale(160),
                          decoration: BoxDecoration(
                            color: ColorManager.grey3,
                            borderRadius: BorderRadius.circular(context.scale(6)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < 2)
                  Divider(
                    height: 1,
                    color: ColorManager.greyShade,
                    indent: context.scale(20),
                    endIndent: context.scale(20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.scale(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: context.scale(72),
              color: ColorManager.grey3,
            ),
            SizedBox(height: context.scale(16)),
            Text(
              LocaleKeys.policiesLoadError.tr(),
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: ColorManager.grey2,
                fontSize: FontSize.s15,
              ),
            ),
            SizedBox(height: context.scale(20)),
            ElevatedButton(
              onPressed: () => context.read<PoliciesCubit>().getPolicies(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.scale(24)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.scale(32),
                  vertical: context.scale(12),
                ),
              ),
              child: Text(
                LocaleKeys.retryButton.tr(),
                style: getBoldStyle(
                  color: ColorManager.whiteColor,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.policiesEmpty.tr(),
        style: getMediumStyle(color: ColorManager.grey2),
      ),
    );
  }
}

class _PolicyListTile extends StatelessWidget {
  final int index;
  final String title;
  final bool showDivider;
  final VoidCallback onTap;

  const _PolicyListTile({
    required this.index,
    required this.title,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.scale(20)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scale(20),
              vertical: context.scale(18),
            ),
            child: Row(
              children: [
                Container(
                  width: context.scale(34),
                  height: context.scale(34),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: getBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.scale(16)),
                Expanded(
                  child: Text(
                    title,
                    style: getSemiBoldStyle(
                      color: ColorManager.blackColor,
                      fontSize: FontSize.s15,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: context.scale(15),
                  color: ColorManager.grey2,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: ColorManager.greyShade,
            indent: context.scale(20),
            endIndent: context.scale(20),
          ),
      ],
    );
  }
}
