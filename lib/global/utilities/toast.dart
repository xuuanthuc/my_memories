import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_memories/global/style/app_colors.dart';

void appToast(
  BuildContext context, {
  required String message,
  ToastGravity? gravity = ToastGravity.CENTER,
}) {
  FToast fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: AppColors.primary,
    ),
    child: Text(
      message,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: gravity,
    toastDuration: const Duration(seconds: 5),
  );
}
