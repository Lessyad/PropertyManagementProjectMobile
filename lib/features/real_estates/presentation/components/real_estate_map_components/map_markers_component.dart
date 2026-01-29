import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';

import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../../core/components/custom_snack_bar.dart';


import '../../../domain/entities/base_property_entity.dart';



Set<Marker> buildMapMarkers(
    List<PropertyEntity> properties,
    Function(PropertyEntity) onMarkerTap,
    Map<int, BitmapDescriptor> customMarkers, // Add this parameter
    ) {
  final markers = <Marker>{};

  for (var property in properties) {
    final icon = customMarkers[property.id];
    if (icon != null) {
      markers.add(
        Marker(
          markerId: MarkerId(property.id.toString()),
          position: LatLng(
            property.latitude.toDouble(),
            property.longitude.toDouble(),
          ),
          icon: icon,
          zIndex: 1,
          consumeTapEvents: true,
          onTap: () => onMarkerTap(property),
        ),
      );
    } else {
      print('No icon found for property ID: ${property.id}');
    }
  }

  return markers;
}

Future<BitmapDescriptor> mapPriceMarkerComponent(String price , BuildContext context) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final double width = context.scale(220);
  final double height = context.scale(100);

  final rrect = RRect.fromRectAndRadius(
    Rect.fromLTWH(0, 0, width, height),
    Radius.circular(context.scale(50)),
  );

  final Path shadowPath = Path()..addRRect(rrect);

  final dx = 5.0;
  final dy = 5.0;

  canvas.save();
  canvas.translate(dx, dy);
  canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.25), 6, false);
  canvas.restore();

  final paint = Paint()..color = Colors.white;
  canvas.drawRRect(rrect, paint);

  final textPainter = TextPainter(
    text: TextSpan(
      text: '$price ج.م',
      style: TextStyle(
        color: ColorManager.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
    maxLines: 1,
    ellipsis: '...',
  );
  textPainter.layout(minWidth: 0, maxWidth: width - 20);
  textPainter.paint(
    canvas,
    Offset(
        (width - textPainter.width) / 2, (height - textPainter.height) / 2),
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}


