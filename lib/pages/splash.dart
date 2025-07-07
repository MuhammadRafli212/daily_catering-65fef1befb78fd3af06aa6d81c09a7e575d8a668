import 'dart:async';

import 'package:daily_catering/api/preferences.dart';
import 'package:daily_catering/pages/home_page.dart';
import 'package:daily_catering/pages/onboard_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void changePage() {
    Future.delayed(const Duration(seconds: 3), () async {
      String? isLogin = await PreferencesHelper.getToken();
      print("isLogin : $isLogin");

      if (!mounted) return; // Cegah error jika widget dispose sebelum navigasi

      if (isLogin != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    changePage(); // Panggil saat splash mulai
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/dapur.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
