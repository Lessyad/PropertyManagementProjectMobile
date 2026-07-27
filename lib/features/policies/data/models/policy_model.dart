import '../../../../core/utils/localized_name.dart';
import '../../domain/entities/policy_entity.dart';

class PolicyModel extends PolicyEntity {
  const PolicyModel({
    required super.id,
    required super.type,
    required super.content,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'] as int,
      type: (json['type'] as String?) ?? '',
      // Le backend renvoie désormais content (fr/défaut) + contentAr + contentEn.
      // On affiche la valeur correspondant à la langue de l'app (repli fr).
      content: resolveLocalizedName(
        nameFr: json['content'] as String?,
        nameAr: json['contentAr'] as String?,
        nameEn: json['contentEn'] as String?,
      ),
    );
  }
}
