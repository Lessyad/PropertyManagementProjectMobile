import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      body: Center(
        child: Hero(
          transitionOnUserGestures: true,
          tag: 'splash',
          child: Image.network( 'https://upload.wikimedia.org/wikipedia/commons/b/b4/Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}