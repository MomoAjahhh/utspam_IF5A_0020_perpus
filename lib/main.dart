// lib/main.dart
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'views/welcome_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'views/profile_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initDummyData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpus App',
      debugShowCheckedModeBanner: false,

      initialRoute: '/welcome',           
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),   
        
      },
    );
  }
}