import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
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

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items:
                slides.map((slide) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(slide["image"]!, fit: BoxFit.cover),
                      Container(color: Colors.black.withOpacity(0.5)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            slide["text"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              color: Color(0xFFFAF6E9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),

          // Indicator & Buttons
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Bulatan indikator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(slides.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 12 : 8,
                      height: _currentIndex == index ? 12 : 8,
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == index
                                ? Colors.white
                                : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // Tombol hanya tampil di halaman terakhir
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
                                backgroundColor: Color(0xFFFAF6E9),
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
                                backgroundColor: Color(0xFFBBC3A4),
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
