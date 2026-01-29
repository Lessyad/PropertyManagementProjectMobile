import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String name , id;

  const CityEntity({
    required this.name,
    required this.id,
  });

  @override
  List<Object?> get props => [name, id];
}