import '../../domain/entities/bank_entity.dart';

class BankModel extends BankEntity {
  const BankModel({
    required super.id,
    required super.name,
    required super.code,
    super.logoUrl,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'logoUrl': logoUrl,
    };
  }
}
