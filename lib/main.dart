import 'package:ai_waste_classifier/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const EcoDetect());
}

class EcoDetect extends StatelessWidget {
  const EcoDetect({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EcoDetect',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: const HomeScreen(),
    );
  }
}
