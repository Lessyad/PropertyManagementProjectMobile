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
      content: (json['content'] as String?) ?? '',
    );
  }
}
