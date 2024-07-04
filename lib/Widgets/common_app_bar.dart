import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  CommonAppBar({required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: null,
      actions: [
        _buildButton(context, 'Calendar', 0),
        _buildButton(context, 'Exercise', 1),
        IconButton(
          icon: Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == 2 ? Colors.white : Color(0xFF0E0E0E),
              border: Border.all(
                color: Colors.white,
                width: currentIndex == 2 ? 0 : 1.w,
              ),
            ),
            child: Icon(
              Icons.settings_outlined,
              size: 22.h,
              color: currentIndex == 2 ? Colors.black : Colors.white,
            ),
          ),
          onPressed: () => onItemTapped(2),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String title, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: 127.w,
        height: 44.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.white : Color(0xFF0E0E0E),
          border: Border.all(
            color: Colors.white,
            width: currentIndex == index ? 0 : 1.w,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: currentIndex == index ? Colors.black : Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
