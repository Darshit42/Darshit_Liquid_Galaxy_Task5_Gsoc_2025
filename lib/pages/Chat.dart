import 'package:flutter/material.dart';
import 'package:darshit_lg_t5/animations/mainanimation.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: geminibutton()),
      ),
    );
  }
}
