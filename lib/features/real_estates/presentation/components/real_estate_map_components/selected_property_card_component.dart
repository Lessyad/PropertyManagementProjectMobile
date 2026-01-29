import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import '../../../domain/entities/base_property_entity.dart';
import '../../../../home_module/presentation/components/real_state_card_component.dart';

class SelectedPropertyCardComponent extends StatelessWidget {
  final PropertyEntity property;
  final Offset screenOffset;

  const SelectedPropertyCardComponent({
    Key? key,
    required this.property,
    required this.screenOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: screenOffset.dy + context.scale(30),
      left: 0,
      right: 0,
      child: ZoomIn(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: RealStateCardComponent(
            width: MediaQuery.of(context).size.width,
            height: context.scale(290),
            currentProperty: property,
            showWishlistButton: false,
          ),
        ),
      ),
    );
  }
} 