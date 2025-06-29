import 'package:daily_catering/api/get_customer.dart';
import 'package:daily_catering/pages/login_page.dart';
import 'package:flutter/material.dart';

import 'onboard_page.dart'; // Ganti jika nama file atau path berbeda

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() {
      isLoading = true;
    });
    final res = await UserService().registerUser(
      email: emailController.text,
      name: nameController.text,
      password: passwordController.text,
    );
    if (res["data"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else if (res["errors"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maaf, ${res["message"]}"),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });

    // } else {
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFAF6E9)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingPage()),
            );
          },
        ),
        title: const Text(
          "Daftar Akun",
          style: TextStyle(color: Color(0xFFFAF6E9)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cabe.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/dapur.png",
                    height: 275,
                    width: 400,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFAF6E9),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    filled: true,
                    fillColor: Color(0xFFFAF6E9),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    filled: true,
                    fillColor: Color(0xFFFAF6E9),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Color(0xFFFAF6E9),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      if (name.isEmpty || email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Semua field harus diisi."),
                          ),
                        );
                        return;
                      }

                      _registerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFBBC3A4),
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
