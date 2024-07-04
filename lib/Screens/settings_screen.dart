import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:id_246/Screens/premium_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(138.h),
            Text(
              'Adds free',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: Colors.white,
              ),
            ),
            Gap(3.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'for \$0.49',
                  style: GoogleFonts.poppins(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
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
                    height: 1.25,
                    color: Color.fromRGBO(103, 156, 253, 1),
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Container(
              width: 331.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Color.fromRGBO(175, 194, 229, 1),
                borderRadius: BorderRadius.circular(47.r),
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PremiumScreen(),
                    ),
                  );
                },
                child: Text(
                  'See Details',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(47.r),
                  ),
                ),
              ),
            ),
            Gap(20.h),
            Column(
              children: [
                Container(
                  width: 331.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(47.r),
                    border: Border.all(color: Colors.white, width: 3.w),
                  ),
                  child: Center(
                    child: Text(
                      'Privacy Policy',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                Container(
                  width: 331.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(47.r),
                    border: Border.all(color: Colors.white, width: 3.w),
                  ),
                  child: Center(
                    child: Text(
                      'Terms of Use',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(69.h),
            Image.asset(
              'assets/setting_screen.png',
              width: 331.w,
              height: 203.57.h,
            ),
          ],
        ),
      ),
    );
  }
}
