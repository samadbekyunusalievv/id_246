import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Static/exercise_data.dart';
import '../Widgets/custom_calendar_widget.dart';
import 'main_screen.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  PageController _pageController = PageController();
  Timer? _timer;
  int _start = 1;
  int _currentPage = 0;
  bool _isPreparation = true;
  List<DateTime> completedDays = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedDays();
  }

  Future<void> _loadCompletedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedDays = prefs.getStringList('completedDays');
    if (storedDays != null) {
      setState(() {
        completedDays = storedDays.map((day) => DateTime.parse(day)).toList();
      });
    }
    print('Loaded completedDays: $completedDays');
  }

  Future<void> _saveCompletedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedDays = completedDays
        .map((day) => DateTime(day.year, day.month, day.day).toIso8601String())
        .toList();
    await prefs.setStringList('completedDays', storedDays);
    print('Saved completedDays: $storedDays');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          if (_isPreparation) {
            _showLetsGoDialog();
            _start = 3;
            _isPreparation = false;
          } else if (_currentPage < exercises.length - 1) {
            _showNextExerciseDialog();
          } else {
            _timer!.cancel();
            DateTime today = DateTime.now();
            DateTime dateOnly = DateTime(today.year, today.month, today.day);
            setState(() {
              if (!completedDays.any((day) => day == dateOnly)) {
                completedDays.add(dateOnly);
              }
            });
            _saveCompletedDays();
            _updateCalendar();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          }
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _start = _isPreparation ? 1 : 3;
    });
    _startTimer();
  }

  void _showLetsGoDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: Material(
                type: MaterialType.transparency,
                child: Image.asset(
                  'assets/lets_go_dialog_image.png',
                  width: 331.w,
                  height: 187.h,
                ),
              ),
            ),
          ],
        );
      },
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
      _startTimer();
    });
  }

  void _showNextExerciseDialog() {
    _timer?.cancel();
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
            height: 306.h,
            decoration: BoxDecoration(
              color: Color.fromRGBO(103, 156, 253, 1),
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage('assets/next_exercise_image.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 52.h),
                  Text(
                    'Great! \nYou\'ve done the \nexercise, now the next\n one will begin!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.r,
                      height: 1.25.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 64.83.h),
                  Container(
                    width: 331.w,
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentPage++;
                          _start = 1;
                          _isPreparation = true;
                        });
                        Navigator.of(context).pop();
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        _resetTimer();
                      },
                      child: Text(
                        'Next Exercise',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 3.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(47.r),
                        ),
                      ),
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

  void _updateCalendar() {
    print('Updating Calendar with completedDays: $completedDays');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomCalendarWidget(
          initialMonth: DateTime.now(),
          onDaySelected: (DateTime day) {
            print("Selected day: $day");
          },
          completedDays: completedDays,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: Column(
        children: [
          if (_currentPage >= 2)
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (_currentPage > 2) {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          exercises[_currentPage - 2],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          if (_currentPage < exercises.length + 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildOnboardingPage(
                  context,
                  "Try this 30-day challenge for the best sleep ever!",
                  "assets/exercise_onboarding.png",
                  1,
                  true,
                ),
                _buildSecondOnboardingPage(
                  context,
                  "You have 1 second to review the exercise, after that 3 seconds timer will be started automatically to perform it! After finishing the complex, the mark will be in the calendar. Enjoy!",
                  2,
                ),
                ..._buildExercisePages(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(BuildContext context, String text,
      String imagePath, int page, bool isFirstPage) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 190.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.25,
              ),
              children: [
                TextSpan(text: 'Try this '),
                TextSpan(
                  text: '30-day',
                  style: TextStyle(color: Color.fromRGBO(175, 194, 229, 1)),
                ),
                TextSpan(text: ' challenge\n for the best sleep ever!'),
              ],
            ),
          ),
          SizedBox(height: 53.h),
          Image.asset(
            imagePath,
            width: 355.w,
            height: 206.48.h,
          ),
          SizedBox(height: 142.52.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.25,
              ),
              children: [
                TextSpan(text: '$page/'),
                TextSpan(
                  text: '2',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          OutlinedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              'Continue',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(47.r),
              ),
              fixedSize: Size(331.w, 48.h),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSecondOnboardingPage(
      BuildContext context, String text, int page) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 180.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(text: 'You have '),
                      TextSpan(
                        text: '1 second',
                        style:
                            TextStyle(color: Color.fromRGBO(175, 194, 229, 1)),
                      ),
                      TextSpan(
                          text: ' to\n review the exercise, after\n that '),
                      TextSpan(
                        text: '3 seconds',
                        style:
                            TextStyle(color: Color.fromRGBO(175, 194, 229, 1)),
                      ),
                      TextSpan(
                          text:
                              ' timer will be started automatically to perform it! After finishing\n the complex, the mark will\n be in the calendar. \nEnjoy!'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 222.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.25,
                  ),
                  children: [
                    TextSpan(text: '$page/'),
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              OutlinedButton(
                onPressed: () {
                  _startTimer();
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  'Start',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(175, 194, 229, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(47.r),
                  ),
                  fixedSize: Size(331.w, 48.h),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
          Positioned(
            top: 456.h,
            left: 100.w,
            child: Stack(
              children: [
                Text(
                  'LETS',
                  style: GoogleFonts.poppins(
                    fontSize: 64.sp,
                    fontWeight: FontWeight.w500,
                    height: 64.h / 80.h,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  'LETS',
                  style: GoogleFonts.poppins(
                    fontSize: 64.sp,
                    height: 64.h / 80.h,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(103, 156, 253, 1),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 500.h,
            left: 75.w,
            child: Stack(
              children: [
                Text(
                  'GO!',
                  style: GoogleFonts.poppins(
                    fontSize: 128.sp,
                    fontWeight: FontWeight.w500,
                    height: 128.h / 160.h,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  'GO!',
                  style: GoogleFonts.poppins(
                    fontSize: 128.sp,
                    fontWeight: FontWeight.w500,
                    height: 128.h / 160.h,
                    color: Color.fromRGBO(103, 156, 253, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExercisePages() {
    List<Widget> pages = [];
    for (int i = 0; i < exercises.length; i++) {
      pages.add(
        Column(
          children: [
            SizedBox(height: 26.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'assets/exercise${i + 1}.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Text(
                        descriptions[i],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.25.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '${_start.toString()} sec',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: 331.w,
              height: 12.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.r),
                color: Color.fromRGBO(175, 194, 229, 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13.r),
                child: LinearProgressIndicator(
                  value: _start / (_isPreparation ? 3 : 5),
                  backgroundColor: Color.fromRGBO(175, 194, 229, 1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(103, 156, 253, 1)),
                  minHeight: 12.h,
                ),
              ),
            ),
            SizedBox(height: 54.h),
          ],
        ),
      );
    }
    return pages;
  }
}
