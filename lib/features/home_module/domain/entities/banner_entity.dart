import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String image;


  const BannerEntity({
    required this.image,

  });

  @override
  List<Object?> get props => [image];
}