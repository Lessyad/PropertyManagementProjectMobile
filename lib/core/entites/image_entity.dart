import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final int id;
  final String image;
  final bool isMain;

  const ImageEntity({
    required this.id,
    required this.image,
    required this.isMain,
  });

  @override
  List<Object> get props => [id, image, isMain];
}