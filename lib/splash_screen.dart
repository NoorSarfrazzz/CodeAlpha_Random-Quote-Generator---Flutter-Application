import 'package:flutter/material.dart';
import 'package:random_quote_generator_app/bottom_navigation_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  _startSplashScreenTimer() async {
    var duration = Duration(seconds: 0);
    Timer(duration, _showContent);
    Timer(Duration(seconds: 3), _navigateToNextScreen);
  }

  _showContent() {
    setState(() {
      _visible = true;
    });
  }

  _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141A30),
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width:80,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                child : Image.asset('assets/images/appbar-logo.png'),
              ),),
              SizedBox(width: 15,),
              Text(
                'Quote Creator',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25,color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
