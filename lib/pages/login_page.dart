import 'package:daily_catering/api/get_customer.dart';
import 'package:daily_catering/api/preferences.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'onboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _loginUser() async {
    setState(() {
      isLoading = true;
    });

    final res = await UserService().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res["data"] != null) {
      final token = res["data"]["token"];

      if (token != null) {
        await PreferencesHelper.saveToken(token);
        print("Token disimpan: $token");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login berhasil!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Token tidak ditemukan dalam respon."),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        title: const Text("Login", style: TextStyle(color: Color(0xFFFAF6E9))),
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
                    height: 250,
                    width: 400,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Masuk ke Akun Anda",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFAF6E9),
                  ),
                ),
                const SizedBox(height: 30),
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
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: const Color(0xFFFAF6E9),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email dan password wajib diisi"),
                          ),
                        );
                        return;
                      }

                      _loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFBBC3A4),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                            : const Text(
                              "Login",
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
