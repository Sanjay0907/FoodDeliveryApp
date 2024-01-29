import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';

class ToastService {
  static sendScaffoldAlert(
      {required String msg,
      required String toastStatus,
      required BuildContext context}) {
    showToastWidget(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: greyShade3,
          ),
        ),
        child: Row(
          children: [
            Icon(
              toastStatus == 'SUCCESS'
                  ? Icons.check_circle
                  : toastStatus == 'ERROR'
                      ? Icons.warning_rounded
                      : Icons.warning_rounded,
              color: toastStatus == 'SUCCESS'
                  ? success
                  : toastStatus == 'ERROR'
                      ? error
                      : Colors.amber,
              // color: widget.color,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 68.w,
              child: Text(msg,
                  textAlign: TextAlign.left, style: AppTextStyles.small10),
            ),
            const Spacer(),
          ],
        ),
      ),
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideFromTop,
      context: context,
      duration: const Duration(seconds: 5),
      position: StyledToastPosition.top,
    );
  }
}
