import 'package:equatable/equatable.dart';

class AmenityEntity extends Equatable {
  final int id;
  final String name;

  const AmenityEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}