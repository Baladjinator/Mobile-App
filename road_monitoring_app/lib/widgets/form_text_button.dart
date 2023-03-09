import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:road_monitoring_app/themes/constants.dart';

class FormTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const FormTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0.h,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).splashColor,
          backgroundColor: contrastColorDarkTheme,
          padding: EdgeInsets.symmetric(vertical: 15.0.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0.sp,
          ),
        ),
      ),
    );
  }
}
