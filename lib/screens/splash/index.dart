import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: Center(
          child: Image.asset(
        "assets/logo.png",
        width: 140.0,
        height: 140.0,
      )));
}
