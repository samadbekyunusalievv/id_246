import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Centered Image and Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 325.w,
                  height: 173.h,
                  child: Image.asset(
                    'assets/element_center.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20.h),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Color(0xFF91B3FA),
                      Color(0xFF588CF8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    'Dream Quest',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 36.sp,
                      height: (45 / 36),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Continue Button
                Container(
                  height: 48.h,
                  width: 331.w,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: (24.h / 16.h),
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(47.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Terms of Use and Privacy Policy
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle terms of use press
                      },
                      child: Text(
                        'Terms of Use',
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: (20.h / 14.h),
                          letterSpacing: -0.4,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    TextButton(
                      onPressed: () {
                        // Handle privacy policy press
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: (20.h / 14.h),
                          letterSpacing: -0.4,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
