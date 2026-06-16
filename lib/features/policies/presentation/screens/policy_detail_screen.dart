import 'package:flutter/material.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/policy_entity.dart';

class PolicyDetailScreen extends StatelessWidget {
  final PolicyEntity policy;
  final String title;

  const PolicyDetailScreen({
    super.key,
    required this.policy,
    required this.title,
  });

  List<String> get _lines => policy.content
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(context),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              context.scale(16),
              context.scale(16),
              context.scale(16),
              context.scale(32),
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorManager.whiteColor,
                  borderRadius: BorderRadius.circular(context.scale(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(context.scale(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_lines.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.scale(14)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: context.scale(5)),
                            child: Container(
                              width: context.scale(7),
                              height: context.scale(7),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          SizedBox(width: context.scale(12)),
                          Expanded(
                            child: Text(
                              _lines[index],
                              style: getRegularStyle(
                                color: ColorManager.grey,
                                fontSize: FontSize.s14,
                              ).copyWith(height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: context.scale(150),
      pinned: true,
      backgroundColor: ColorManager.whiteColor,
      foregroundColor: ColorManager.navyColor,
      leading: Padding(
        padding: EdgeInsets.all(context.scale(8)),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(context.scale(12)),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.greyShade,
              borderRadius: BorderRadius.circular(context.scale(12)),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: ColorManager.navyColor,
              size: context.scale(18),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: getBoldStyle(
            color: ColorManager.navyColor,
            fontSize: FontSize.s15,
          ),
        ),
        titlePadding: EdgeInsets.only(
          left: context.scale(56),
          bottom: context.scale(16),
          right: context.scale(16),
        ),
        background: Container(
          color: ColorManager.whiteColor,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: context.scale(16),
                bottom: context.scale(52),
              ),
              child: Container(
                padding: EdgeInsets.all(context.scale(10)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(context.scale(14)),
                ),
                child: Icon(
                  _iconForType(policy.type),
                  color: ColorManager.whiteColor,
                  size: context.scale(26),
                ),
              ),
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.scale(24)),
          bottomRight: Radius.circular(context.scale(24)),
        ),
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
