import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'views/welcome_screen.dart'; 

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
      home: WelcomeScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}