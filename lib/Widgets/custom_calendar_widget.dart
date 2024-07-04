import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialMonth;
    print('Init State - Completed Days: ${widget.completedDays}');
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      widget.onDaySelected(selectedDay);
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isCompletedDay(DateTime day) {
    bool isCompleted = widget.completedDays
        .any((completedDay) => isSameDay(completedDay, day));
    print(
        'Checking if ${day.toIso8601String().split('T')[0]} is completed: $isCompleted');
    return isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(15.w),
      child: Container(
        width: 346.w,
        height: 427.h,
        decoration: BoxDecoration(
          color: Color.fromRGBO(14, 14, 14, 1),
          borderRadius: BorderRadius.circular(31.r),
          border: Border.all(color: Colors.white, width: 2.w),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18.h, left: 8.w, right: 8.w),
              child: Column(
                children: [
                  Text(
                    _focusedDay.month == 1
                        ? 'JANUARY'
                        : _focusedDay.month == 2
                            ? 'FEBRUARY'
                            : _focusedDay.month == 3
                                ? 'MARCH'
                                : _focusedDay.month == 4
                                    ? 'APRIL'
                                    : _focusedDay.month == 5
                                        ? 'MAY'
                                        : _focusedDay.month == 6
                                            ? 'JUNE'
                                            : _focusedDay.month == 7
                                                ? 'JULY'
                                                : _focusedDay.month == 8
                                                    ? 'AUGUST'
                                                    : _focusedDay.month == 9
                                                        ? 'SEPTEMBER'
                                                        : _focusedDay.month ==
                                                                10
                                                            ? 'OCTOBER'
                                                            : _focusedDay
                                                                        .month ==
                                                                    11
                                                                ? 'NOVEMBER'
                                                                : 'DECEMBER',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.5.h,
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
                                  height: 1.5.h,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: GridView.builder(
                  itemCount: 35,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 1.w,
                    mainAxisSpacing: 1.h,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    DateTime firstDayOfMonth =
                        DateTime(_focusedDay.year, _focusedDay.month, 1);
                    int firstWeekdayOfMonth = firstDayOfMonth.weekday;
                    DateTime day = firstDayOfMonth
                        .add(Duration(days: index - firstWeekdayOfMonth + 1));
                    bool isOutside = day.month != _focusedDay.month;
                    bool isSelected =
                        isSameDay(day, _selectedDay ?? DateTime(1970, 1, 1));
                    bool isCompleted = _isCompletedDay(day);

                    return GestureDetector(
                      onTap: () {
                        if (!isOutside &&
                            day.isAfter(
                                DateTime.now().subtract(Duration(days: 1)))) {
                          _onDaySelected(day, _focusedDay);
                        }
                      },
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color.fromRGBO(241, 181, 181, 1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(3.r),
                          border: isOutside
                              ? null
                              : Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.w,
                                ),
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
                                  height: 1.2.h,
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
              ),
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
}
