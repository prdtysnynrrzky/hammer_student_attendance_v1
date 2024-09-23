// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hammer_student_attendance/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/illustrations/vector2.png",
              width: 250,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/illustrations/vector1.png",
              width: 250,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/illustrations/pattern1.png",
              width: 250,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/illustrations/pattern2.png",
              width: 250,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/logo/logo.png',
                  width: 250,
                )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
                      curve: Curves.easeIn,
                      duration: 500.ms,
                    )
                    .shimmer(
                      delay: 700.ms,
                      duration: 2300.ms,
                      curve: Curves.easeInOut,
                    ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Developed by ",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "prdtysnynrrzky",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ).animate().fadeIn(
                        delay: 200.ms,
                        curve: Curves.easeIn,
                        duration: 1000.ms,
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
