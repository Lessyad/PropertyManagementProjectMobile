import 'package:equatable/equatable.dart';

class StateEntity extends Equatable {
  final String name , id;

  const StateEntity({
    required this.name,
    required this.id,
  });

  @override
  List<Object?> get props => [name, id];
}