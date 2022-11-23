import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';


class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset('assets/images/socket-io-white.png'), nextScreen: homePage(),
    backgroundColor: Colors.black,
    splashIconSize:275,
    );
  }
}
