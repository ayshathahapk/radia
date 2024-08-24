import 'dart:async';
import 'package:flutter/material.dart';
import 'package:radia/Core/Utils/image_constant.dart';
import 'package:radia/main.dart';
import '../../New/NavigationBar/navigation_bar.dart';
import '../nav_bar.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationBarScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: height * 0.3,
          width: width * 0.3,
          child: Image.asset(
            ImageConstants.logo,
          ),
        ),
      ),
    );
  }
}
