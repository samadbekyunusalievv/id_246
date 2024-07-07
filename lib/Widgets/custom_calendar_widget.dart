import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomCalendarWidget extends StatefulWidget {
  final DateTime initialMonth;
  final Function(DateTime) onDaySelected;
  final List<DateTime> completedDays;

  CustomCalendarWidget({
    required this.initialMonth,
    required this.onDaySelected,
    required this.completedDays,
  });

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  List<DateTime> completedDays = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialMonth;
    _loadCompletedDays();
  }

  Future<void> _loadCompletedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedDays = prefs.getStringList('completedDays');
    if (storedDays != null) {
      setState(() {
        completedDays = storedDays.map((day) {
          DateTime date = DateTime.parse(day);
          return DateTime(date.year, date.month, date.day);
        }).toList();
      });
    }
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isCompletedDay(DateTime day) {
    return completedDays.any((completedDay) => isSameDay(completedDay, day));
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = (ScreenUtil().screenWidth - 16.w) / 7;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(15.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(14, 14, 14, 1),
          borderRadius: BorderRadius.circular(31.r),
          border: Border.all(color: Colors.white, width: 2.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18.h, left: 8.w, right: 8.w),
              child: Column(
                children: [
                  Text(
                    _monthText(_focusedDay.month),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 19.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                        .map(
                          (day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 35,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 1.r,
                mainAxisSpacing: 1.r,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                DateTime day = _calculateDay(index);
                bool isOutside = day.month != _focusedDay.month;
                bool isSelected = isSameDay(day, _selectedDay);
                bool isCompleted = _isCompletedDay(day);

                return GestureDetector(
                  onTap: () {
                    if (!isOutside &&
                        day.isAfter(
                            DateTime.now().subtract(Duration(days: 1)))) {
                      setState(() {
                        _selectedDay = day;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color.fromRGBO(241, 181, 181, 1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3.r),
                      border: isOutside
                          ? null
                          : Border.all(
                              color: Colors.white.withOpacity(0.5), width: 1.w),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isOutside
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.white,
                            ),
                          ),
                          if (isCompleted)
                            Positioned(
                              child: Image.asset(
                                'assets/tick.png',
                                width: 30.w,
                                height: 25.h,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              height: 50.h,
              width: 335.w,
              margin: EdgeInsets.all(10.w),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, _selectedDay);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white, width: 2.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthText(int month) {
    return [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ][month - 1];
  }

  DateTime _calculateDay(int index) {
    DateTime firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    int firstWeekdayOfMonth = firstDayOfMonth.weekday;
    return firstDayOfMonth.add(Duration(days: index - firstWeekdayOfMonth + 1));
  }
}
