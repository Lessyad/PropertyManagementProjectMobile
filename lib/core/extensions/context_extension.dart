import 'package:flutter/material.dart'  ;
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double scale(double value) =>  value.sp;

}