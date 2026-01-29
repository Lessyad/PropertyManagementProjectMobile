import 'package:equatable/equatable.dart';

class AppServiceEntity extends Equatable {
  final String image;
  final String text;

  const AppServiceEntity({
    required this.image,
    required this.text,
  });

  @override
  List<Object?> get props => [image, text];
}
