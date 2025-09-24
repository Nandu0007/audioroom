import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFF03DAC6), Color(0xFF1976D2)],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1976D2).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mic,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'AudioRoom',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please sign in to continue',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () {
                  // For demo purposes, navigate directly to home
                  Get.to(() => HomeScreen());
                },
                icon: Icon(Icons.login),
                label: Text("Continue as Guest"),
              ),
              SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar("Coming soon", "Full authentication is under development.");
                },
                icon: Icon(Icons.email),
                label: Text("Sign in With Email"),
              ),
              SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar("Coming soon", "Google Sign-in is under development.");
                },
                icon: Icon(Icons.login),
                label: Text("Sign in With Google"),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
