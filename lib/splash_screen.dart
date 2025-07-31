import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'main.dart';
import 'main_screen.dart';



class SplashScreen extends StatefulWidget {
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
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Black fade only on bottom quarter
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: height * 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Text overlays
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top: My Store
                  SizedBox(height: 4.h),
                  Center(
                    child: Text(
                      'My Store',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Bottom: Welcome text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Välkommen',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Hos oss kan du baka tid hos nästan alla Sveriges salonger och mottagningar. Boka frisörer, massage, skönhetsbehandlingar, friskvård och mycket mer.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}