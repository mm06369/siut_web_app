import 'package:flutter/material.dart';
import 'package:siut_web_app/home_page.dart';
import 'package:siut_web_app/login_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIUT ChatBot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset('assets/siut_logo.jpg'),
            nextScreen: const LoginPage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white)
    );
  }
}
