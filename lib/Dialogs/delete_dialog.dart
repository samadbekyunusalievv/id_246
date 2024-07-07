import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

Future<void> showDeleteDialog(
    BuildContext context, VoidCallback onConfirm, DateTime date) async {
  final String formattedDate = DateFormat('d MMMM').format(date);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: Color.fromRGBO(48, 48, 48, 1),
          child: Container(
            width: 270.w,
            height: 138.h,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Gap(16.h),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 17.r,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.41,
                        height: 22 / 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(10.h),
                    Text(
                      "Do you really want to delete\n this date?",
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 13.r,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.08,
                        color: Colors.white,
                        height: 16 / 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(10.h),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              onConfirm();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 17.r,
                                height: 22 / 17,
                              ),
                            ),
                          ),
                          Gap(70.w),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17.r,
                                height: 22 / 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 96.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1.h,
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                  ),
                ),
                Positioned(
                  top: 96.h,
                  left: 135.w,
                  bottom: 0,
                  child: Container(
                    width: 1.w,
                    color: Color.fromRGBO(255, 255, 255, 0.2),
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
