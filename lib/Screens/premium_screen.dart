import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
        ),
        title: Text(
          'Premium',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            height: 25 / 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/prem_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Centered Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 172.h),
                Container(
                  width: 325.w,
                  height: 173.h,
                  child: Image.asset(
                    'assets/element_center.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
                Text(
                  'A helper in your dream!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.25.h, // Line height 25px / font size 20px = 1.25
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 99.h),
                Text(
                  'Adds free',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.25.h,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'for \$0.49',
                      style: GoogleFonts.poppins(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w700,
                        height:
                            1.25, // Line height 45px / font size 36px = 1.25
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.white,
                      ),
                    ),
                    Text(
                      'for \$0.49',
                      style: GoogleFonts.poppins(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.25.h,
                        color: Color.fromRGBO(103, 156, 253, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    _showDetailsDialog(context); // Open the dialog
                  },
                  child: Container(
                    width: 331.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(175, 194, 229, 1),
                      borderRadius: BorderRadius.circular(47.r),
                    ),
                    child: Center(
                      child: Text(
                        'See Details',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5.h,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
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
                          height: (20 / 14),
                          letterSpacing: -0.4,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Restore',
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: (20 / 14),
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
                          height: (20 / 14),
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

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Container(
            width: 355.w,
            height: 282.h,
            decoration: BoxDecoration(
              color: Color.fromRGBO(246, 148, 140, 1),
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage('assets/premium_alert_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 42.h),
                  Text(
                    'Adds free',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.25.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'for \$0.49',
                        style: GoogleFonts.poppins(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.25.h,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        'for \$0.49',
                        style: GoogleFonts.poppins(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.25.h,
                          color: Color.fromRGBO(103, 156, 253, 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 41.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: Container(
                      width: 331.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 148, 140, 1),
                        borderRadius: BorderRadius.circular(47.r),
                        border: Border.all(
                          color: Colors.white,
                          width: 3.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'See Details',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: Text(
                      'Restore',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5.h,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
