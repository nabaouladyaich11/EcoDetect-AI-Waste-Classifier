import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vvongzrngxfpigyfeias.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2b25nenJuZ3hmcGlneWZlaWFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NzcyNTEsImV4cCI6MjA4MDM1MzI1MX0.8aCOhUdrG7p5av5g61RqBSpgrQmoSwUIWjCSNXymFOg',
  );

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
