import 'package:flutter/material.dart';
import 'home_page.dart';
void main() {
  runApp(const groupChat());
}

class groupChat extends StatelessWidget {
  const groupChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
      primaryColor: Color(0xFF0A0E21),
      focusColor: Colors.purpleAccent,
      hintColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
    ),
      home: homePage()
    );
  }
}
