import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/extensions/request_states_extension.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../domain/use_cases/get_policies_use_case.dart';
import '../controller/policies_cubit.dart';
import 'collapsible_policy_card.dart';

/// Affiche les policies de type "ConditionInput" (conditions de location).
/// Se charge de manière autonome et reste invisible s'il n'y a rien à montrer.
/// Le contenu est déjà résolu dans la langue de l'app côté modèle.
class ConditionInputPoliciesWidget extends StatelessWidget {
  const ConditionInputPoliciesWidget({super.key});

  static const String _conditionInputType = 'conditioninput';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PoliciesCubit(ServiceLocator.getIt<GetPoliciesUseCase>())..getPolicies(),
      child: BlocBuilder<PoliciesCubit, PoliciesState>(
        builder: (context, state) {
          // Discret pendant le chargement / en cas d'erreur : on n'encombre pas
          // le formulaire du locataire.
          if (state.getPoliciesState.isInitial ||
              state.getPoliciesState.isLoading ||
              state.getPoliciesState.isError) {
            return const SizedBox.shrink();
          }

          final conditions = state.policies
              .where((p) => p.type.toLowerCase() == _conditionInputType)
              .toList();

          if (conditions.isEmpty) return const SizedBox.shrink();

          final List<String> lines = [];
          for (final policy in conditions) {
            lines.addAll(
              policy.content
                  .split('\n')
                  .map((l) => l.trim())
                  .where((l) => l.isNotEmpty),
            );
          }

          if (lines.isEmpty) return const SizedBox.shrink();

          return CollapsiblePolicyCard(
            title: LocaleKeys.policyTypeConditionInput.tr(),
            icon: Icons.assignment_outlined,
            content: lines.join('\n'),
          );
        },
      ),
    );
  }
}
