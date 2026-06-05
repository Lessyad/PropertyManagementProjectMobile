import 'package:equatable/equatable.dart';

class AppServiceEntity extends Equatable {
  final String image;
  final String text;
  final bool isComingSoon;

  const AppServiceEntity({
    required this.image,
    required this.text,
    this.isComingSoon = false,
  });

  @override
  List<Object?> get props => [image, text, isComingSoon];
}
