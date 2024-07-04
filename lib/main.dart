import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Screens/main_screen.dart';
import 'Screens/onboarding_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: OnboardingScreen(),
          routes: {
            '/onboarding': (context) => OnboardingScreen(),
            '/main': (context) => MainScreen(),
          },
        );
      },
    );
  }
}
