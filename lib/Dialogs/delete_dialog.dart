import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

Future<void> showDeleteDialog(
    BuildContext context, VoidCallback onConfirm, DateTime date) async {
  final String formattedDate = DateFormat('d MMMM').format(date);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        backgroundColor: Color.fromRGBO(48, 48, 48, 1),
        child: Container(
          width: 260.w,
          padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                "Do you really want to delete \nthis date?",
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.08,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Divider(color: Colors.grey, thickness: 1, height: 1),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.h,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      width: 20,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.h,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
