import 'package:daily_catering/api/preferences.dart';
import 'package:daily_catering/pages/kelola_kategori.dart';
import 'package:daily_catering/pages/kelola_menu.dart';
import 'package:daily_catering/pages/onboard_page.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/cabe.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Fade-in content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Profile Header (WhatsApp-style)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            "assets/images/dapur.png",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Admin ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "admin@dailycatering.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Admin Menu
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5C5470),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: ListView(
                        children: [
                          _buildMenuItem(
                            icon: Icons.fastfood,
                            title: "Kelola Menu Makanan",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const KelolaMenuPage(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.people_alt_outlined,
                            title: "Kelola Kategori Makanan",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const KelolaKategoriPage(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: "Logout",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Konfirmasi Logout"),
                                    content: const Text(
                                      "Apakah Anda yakin ingin logout?",
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text("Batal"),
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: const Text("Logout"),
                                        onPressed: () async {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Tutup dialog
                                          await PreferencesHelper.clearToken(); // Hapus token
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => OnboardingPage(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
