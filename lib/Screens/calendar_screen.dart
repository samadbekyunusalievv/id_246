import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Dialogs/delete_dialog.dart';
import '../Widgets/custom_calendar_widget.dart';

class CalendarScreen extends StatefulWidget {
  final List<DateTime> completedDays;

  CalendarScreen({required this.completedDays});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentIndex = DateTime.now().month - 1;
  final List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  DateTime? _selectedDate;
  Map<String, Map<String, Set<String>>> _ritualsByMonth = {};
  TextEditingController _ritualController = TextEditingController();
  Map<String, bool> _isExpandedMap = {};
  Map<String, bool> _addingCustomRitualMap = {};
  Map<String, Color> _dayColors = {};
  final List<Color> _backgroundColors = [
    Color.fromRGBO(241, 181, 181, 1),
    Color.fromRGBO(175, 194, 229, 1),
    Color.fromRGBO(193, 241, 181, 1)
  ];
  final List<String> _predefinedRituals = [
    'Sleep mask',
    'Room ventilation',
    'Black-out curtains',
    'Orthopedic pillow',
    'Air humidifier',
    'Essential oils',
    'Heavy blanket'
  ];

  @override
  void initState() {
    super.initState();
    _loadRituals();
  }

  Future<void> _loadRituals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ritualsJson = prefs.getString('ritualsByMonth');
    if (ritualsJson != null) {
      Map<String, dynamic> decodedJson = json.decode(ritualsJson);
      Map<String, Map<String, Set<String>>> loadedRituals = {};
      Map<String, Color> loadedColors = {};

      decodedJson.forEach((month, days) {
        Map<String, Set<String>> ritualsByDay = {};
        if (days is Map<String, dynamic>) {
          days.forEach((day, ritualsAndColor) {
            if (ritualsAndColor is Map<String, dynamic>) {
              Set<String> rituals =
                  Set<String>.from(ritualsAndColor['rituals']);
              int? colorValue = ritualsAndColor['color'] as int?;
              if (colorValue != null) {
                Color color = Color(colorValue);
                ritualsByDay[day] = rituals;
                loadedColors[day] = color;
              }
            }
          });
        }
        loadedRituals[month] = ritualsByDay;
      });

      setState(() {
        _ritualsByMonth = loadedRituals;
        _dayColors = loadedColors;
      });
    }
  }

  Future<void> _saveRituals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, Map<String, Map<String, dynamic>>> saveData = {};

    _ritualsByMonth.forEach((month, days) {
      Map<String, Map<String, dynamic>> daysData = {};
      days.forEach((day, rituals) {
        if (_dayColors.containsKey(day)) {
          daysData[day] = {
            'rituals': rituals.toList(),
            'color': _dayColors[day]!.value
          };
        }
      });
      saveData[month] = daysData;
    });

    String saveJson = json.encode(saveData);
    await prefs.setString('ritualsByMonth', saveJson);
  }

  void _createRitualForDate(String dateKey, Set<String> rituals) {
    String monthKey = "${_selectedDate!.year}-${_selectedDate!.month}";
    setState(() {
      if (!_ritualsByMonth.containsKey(monthKey)) {
        _ritualsByMonth[monthKey] = {};
      }
      _ritualsByMonth[monthKey]![dateKey] = rituals;
      if (!_dayColors.containsKey(dateKey)) {
        _dayColors[dateKey] = _backgroundColors[_getColorIndex(dateKey)];
      }
    });
    _saveRituals();
  }

  void _toggleRitual(String ritual) {
    if (_selectedDate != null) {
      String monthKey = "${_selectedDate!.year}-${_selectedDate!.month}";
      String dateKey = _selectedDate.toString();
      Set<String>? rituals = _ritualsByMonth[monthKey]?[dateKey] ?? <String>{};
      setState(() {
        if (rituals.contains(ritual)) {
          rituals.remove(ritual);
        } else {
          rituals.add(ritual);
        }
        _ritualsByMonth[monthKey]![dateKey] = rituals;
        _dayColors[dateKey] ??= _backgroundColors[_getColorIndex(dateKey)];
      });
      _saveRituals();
    }
  }

  void _addCustomRitual(String ritual) {
    if (_selectedDate != null && ritual.isNotEmpty) {
      String dateKey = _selectedDate.toString();
      Set<String> rituals =
          _ritualsByMonth["${_selectedDate!.year}-${_selectedDate!.month}"]
                  ?[dateKey] ??
              <String>{};
      rituals.add(ritual);
      _createRitualForDate(dateKey, rituals);
      setState(() {
        _addingCustomRitualMap[dateKey] = false;
        _ritualController.clear();
      });
    }
  }

  void _previousMonth() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + months.length) % months.length;
      _selectedDate = null;
      _isExpandedMap.clear();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % months.length;
      _selectedDate = null;
      _isExpandedMap.clear();
    });
  }

  void _showCalendarDialog() async {
    DateTime? selectedDay = await showCalendarDialog(
      context,
      widget.completedDays,
      _currentIndex,
      (selectedDay) {
        setState(() {
          _selectedDate = selectedDay;
          _updateRitualMapForNewDate(expand: true);
        });
      },
      _ritualsByMonth,
      _dayColors,
    );

    if (selectedDay != null) {
      setState(() {
        _selectedDate = selectedDay;
        _updateRitualMapForNewDate(expand: true);
      });
    }
  }

  void _updateRitualMapForNewDate({bool expand = false}) {
    if (_selectedDate == null) return;
    String monthKey = "${_selectedDate!.year}-${_selectedDate!.month}";
    if (!_ritualsByMonth.containsKey(monthKey)) {
      _ritualsByMonth[monthKey] = {};
    }
    if (!_ritualsByMonth[monthKey]!.containsKey(_selectedDate.toString())) {
      _ritualsByMonth[monthKey]![_selectedDate.toString()] = <String>{};
      if (expand) {
        _isExpandedMap[_selectedDate.toString()] = true;
      }
    }
  }

  void _showDeleteDialog(String monthKey, String dateKey) {
    DateTime date = DateTime.parse(dateKey);

    showDeleteDialog(context, () {
      setState(() {
        _ritualsByMonth[monthKey]!.remove(dateKey);
        _dayColors.remove(dateKey);
        _saveRituals();
      });
    }, date);
  }

  String _formatDate(DateTime date) {
    return "${date.day} ${_getFullMonthName(date.month)}";
  }

  String _getFullMonthName(int month) {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ][month - 1];
  }

  String _getWeekdayName(DateTime date) {
    return [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ][date.weekday - 1];
  }

  int _getColorIndex(String key) {
    int hash = key.hashCode;
    return hash.abs() % _backgroundColors.length;
  }

  Color _getTextColor(Color backgroundColor) {
    if (backgroundColor == _backgroundColors[0]) {
      return Colors.red;
    } else if (backgroundColor == _backgroundColors[1]) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  Widget _customDeleteButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/delete_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildRitualItem(String ritual, String dateKey,
      {bool isCustom = false, required Color textColor}) {
    if (_selectedDate == null ||
        !_ritualsByMonth["${_selectedDate!.year}-${_selectedDate!.month}"]!
            .containsKey(dateKey)) {
      return SizedBox.shrink();
    }

    bool isSelected =
        _ritualsByMonth["${_selectedDate!.year}-${_selectedDate!.month}"]
                    ?[dateKey]
                ?.contains(ritual) ??
            false;

    Color textAndIconColor;
    IconData iconData;
    if (isCustom) {
      textAndIconColor = isSelected ? textColor : Colors.black.withOpacity(0.5);
      iconData = isSelected ? Icons.check_circle : Icons.add_circle_outline;
    } else {
      textAndIconColor =
          isSelected ? Colors.black : Colors.black.withOpacity(0.5);
      iconData = isSelected ? Icons.check_circle : Icons.add_circle_outline;
    }

    Color iconColor = isCustom ? textAndIconColor : Colors.black;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ritual,
            style: GoogleFonts.poppins(
              fontSize: 20.r,
              fontWeight: FontWeight.w500,
              color: textAndIconColor,
            ),
          ),
          GestureDetector(
            onTap: () => _toggleRitual(ritual),
            child: Icon(
              iconData,
              size: 38.r,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentMonthKey = "${DateTime.now().year}-${_currentIndex + 1}";

    List<MapEntry<String, Set<String>>>? sortedRitualEntries =
        _ritualsByMonth[currentMonthKey]?.entries.toList()
          ?..sort(
              (a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));

    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
      ),
      body: Column(
        children: [
          Gap(128.h),
          Container(
            width: 331.w,
            height: 92.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/banner.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Center(
              child: Text(
                'Have a good night sleep!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  height: (30.h / 24.h),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Gap(30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  months[(_currentIndex - 1 + months.length) % months.length],
                  style: GoogleFonts.poppins(
                    fontSize: 32.r,
                    fontWeight: FontWeight.w500,
                    height: (48.h / 32.h),
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: _previousMonth,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 25.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  months[_currentIndex],
                  style: GoogleFonts.poppins(
                    fontSize: 32.r,
                    fontWeight: FontWeight.w500,
                    height: (48.h / 32.h),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: _nextMonth,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 25.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  months[(_currentIndex + 1) % months.length],
                  style: GoogleFonts.poppins(
                    fontSize: 32.r,
                    fontWeight: FontWeight.w500,
                    height: (48.h / 32.h),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Gap(30.h),
          if (_ritualsByMonth[currentMonthKey]?.isEmpty ?? true)
            Center(
              child: Text(
                "You haven't added \n anything this month.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  height: (36.h / 24.h),
                  color: Colors.white,
                ),
              ),
            ),
          Gap(10.h),
          Container(
            height: 48.h,
            width: 331.w,
            child: OutlinedButton(
              onPressed: _showCalendarDialog,
              child: Icon(
                Icons.add,
                size: 18.sp,
                color: Colors.white,
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(43.r),
                ),
              ),
            ),
          ),
          Gap(30.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              children: sortedRitualEntries?.map((entry) {
                    DateTime date = DateTime.parse(entry.key);
                    bool isExpanded = _isExpandedMap[entry.key] ?? false;
                    Color backgroundColor = _dayColors[entry.key] ??
                        _backgroundColors[_getColorIndex(entry.key)];
                    Color textColor = _getTextColor(backgroundColor);
                    return Slidable(
                      key: Key(entry.key),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          CustomSlidableAction(
                            onPressed: (context) {
                              _showDeleteDialog(currentMonthKey, entry.key);
                            },
                            backgroundColor: Colors.transparent,
                            child: _customDeleteButton(() {
                              _showDeleteDialog(currentMonthKey, entry.key);
                            }),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        width: 331.w,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    _getWeekdayName(date),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.r,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: AutoSizeText(
                                      _formatDate(date),
                                      style: GoogleFonts.poppins(
                                        fontSize: 34.r,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 10,
                                      stepGranularity: 1,
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(5, 0.0),
                                    child: IconButton(
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        size: 35.w,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isExpandedMap[entry.key] =
                                              !isExpanded;
                                          if (_isExpandedMap[entry.key] ==
                                              true) {
                                            _selectedDate = date;
                                            _updateRitualMapForNewDate(
                                                expand: true);
                                          }
                                          _dayColors[entry.key] ??=
                                              _backgroundColors[
                                                  _getColorIndex(entry.key)];
                                          _saveRituals();
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                Divider(color: Colors.black, thickness: 1.h),
                                Column(
                                  children: [
                                    ..._predefinedRituals.map((ritual) =>
                                        _buildRitualItem(ritual, entry.key,
                                            isCustom: false,
                                            textColor: textColor)),
                                    ...entry.value
                                        .where((ritual) => !_predefinedRituals
                                            .contains(ritual))
                                        .map((ritual) => _buildRitualItem(
                                            ritual, entry.key,
                                            isCustom: true,
                                            textColor: textColor)),
                                    if (!(_addingCustomRitualMap[entry.key] ??
                                        false))
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _addingCustomRitualMap[entry.key] =
                                                true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Add your ritual',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 24.r,
                                                  fontWeight: FontWeight.w500,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.add_circle_outline,
                                              size: 38.r,
                                              color: textColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (_addingCustomRitualMap[entry.key] ??
                                        false)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _ritualController,
                                              decoration: InputDecoration(
                                                hintText: 'Enter your ritual',
                                                hintStyle: GoogleFonts.poppins(
                                                  fontSize: 24.r,
                                                  fontWeight: FontWeight.w600,
                                                  color: textColor,
                                                  height: (24.h / 24.sp),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: textColor),
                                                ),
                                              ),
                                              style: GoogleFonts.poppins(
                                                fontSize: 24.r,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                                height: (24.h / 24.sp),
                                              ),
                                              autofocus: true,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (_ritualController
                                                  .text.isNotEmpty) {
                                                _addCustomRitual(
                                                    _ritualController.text);
                                              }
                                            },
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              size: 38.r,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    Gap(10.h),
                                    Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isExpandedMap[entry.key] = false;
                                            _ritualController.clear();
                                            _dayColors[entry.key] ??=
                                                _backgroundColors[
                                                    _getColorIndex(entry.key)];
                                            _saveRituals();
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Colors.black, width: 2.w),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                          ),
                                        ),
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(
                                            fontFamily: 'SF Pro Display',
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }
}

Future<DateTime?> showCalendarDialog(
    BuildContext context,
    List<DateTime> completedDays,
    int currentIndex,
    Function(DateTime?) onDaySelected,
    Map<String, Map<String, Set<String>>> ritualsByMonth,
    Map<String, Color> dayColors) async {
  DateTime? selectedDay = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(15.w),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: CustomCalendarWidget(
            initialMonth: DateTime(DateTime.now().year, currentIndex + 1),
            onDaySelected: (selectedDay) {
              onDaySelected(selectedDay);
            },
            completedDays: completedDays,
            ritualsByMonth: ritualsByMonth,
            dayColors: dayColors,
          ),
        ),
      );
    },
  );
  return selectedDay;
}
