import 'package:ai_waste_classifier/screens/auth/onboarding_one.dart';
import 'package:flutter/material.dart';
import 'package:ai_waste_classifier/screens/home/home_screen.dart';
import 'package:ai_waste_classifier/supabase_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final session =
          supabase.auth.currentSession; // non-null = logged in [web:63]
      if (session != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingOne()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 245, 255, 238),
              Color.fromARGB(255, 201, 224, 194),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Image.asset(
                'assets/images/EcoDetect.png',
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
