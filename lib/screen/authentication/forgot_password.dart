import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  Future<void> signUp() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
  }
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                alignment: Alignment.centerLeft,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 40),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Image(image: AssetImage('asset/logo.png')),
              ),
              const SizedBox(height: 40),
              const Text(
                'Reset your account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => signUp(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D9D9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Send Link',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}