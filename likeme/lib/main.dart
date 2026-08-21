import 'package:flutter/material.dart';
import 'package:likeme/splashscreen.dart';

void main() {
  runApp(const LikeMeApp());
}

class LikeMeApp extends StatelessWidget {
  const LikeMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LikeMe',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8E44AD),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

