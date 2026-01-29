import 'package:equatable/equatable.dart';

class BankEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? logoUrl;

  const BankEntity({
    required this.id,
    required this.name,
    required this.code,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, code, logoUrl];
}
