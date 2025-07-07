import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> slides = [
    {
      "image":
          "https://www.hipwee.com/wp-content/uploads/2020/07/hipwee-FitnessChef-GroupShot550px-x-440px.jpg",
      "text": "Selamat Datang ",
    },
    {
      "image":
          "https://bisnisukm.com/uploads/2016/07/bisnis-katering-makanan-sehat-peminatnya-kian-meningkat.jpg",
      "text": "Temukan Menu Makan Bergizi Gratis",
    },
    {
      "image": "https://www.lalamove.com/hubfs/usaha%20katering%20%281%29.jpg",
      "text": "Login atau Daftar untuk Mulai",
    },
  ];

  int _currentIndex = 0;
  late final AnimationController _fadeSlideController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeSlideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeSlideController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeSlideController, curve: Curves.easeIn),
    );

    _fadeSlideController.forward();
  }

  @override
  void dispose() {
    _fadeSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Gambar + Parallax Zoom effect
          CarouselSlider.builder(
            itemCount: slides.length,
            itemBuilder: (context, index, realIndex) {
              final image = slides[index]["image"]!;
              final text = slides[index]["text"]!;

              return AnimatedBuilder(
                animation: _fadeSlideController,
                builder: (context, child) {
                  final zoom = 1 + (_fadeSlideController.value * 0.02);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Transform.scale(
                        scale: zoom,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  Center(child: Container(color: Colors.black)),
                          errorWidget:
                              (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                      Container(color: Colors.black.withOpacity(0.5)),
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Color(0xFFFAF6E9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
                _fadeSlideController.reset();
                _fadeSlideController.forward();
              },
            ),
          ),

          // Indikator + Tombol Login/Register
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(slides.length, (index) {
                    final isActive = _currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 12 : 8,
                      height: isActive ? 12 : 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                      transform:
                          isActive
                              ? Matrix4.translationValues(
                                0,
                                math.sin(
                                      DateTime.now().millisecondsSinceEpoch /
                                          150,
                                    ) *
                                    1.5,
                                0,
                              )
                              : Matrix4.identity(),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: isLastPage ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedSlide(
                    offset: isLastPage ? Offset.zero : const Offset(0, 1),
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFAF6E9),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Login"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBBC3A4),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Daftar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
