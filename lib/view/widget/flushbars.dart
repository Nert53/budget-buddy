import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';

class FlushbarSuccess {
  static void show({
    required BuildContext context,
    required String message,
  }) {
    Flushbar(
      message: message,
      messageColor: Colors.black,
      icon: Icon(
        Icons.check_circle_outline_outlined,
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(10),
      leftBarIndicatorColor: successColor,
      backgroundColor: Colors.green[200]!,
    ).show(context);
  }
}

class FlushbarError {
  static void show({
    required BuildContext context,
    required String message,
  }) {
    Flushbar(
      message: message,
      messageColor: Colors.black,
      icon: Icon(
        Icons.error_outline_outlined,
        color: Colors.black,
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(10),
      leftBarIndicatorColor: Theme.of(context).colorScheme.error,
      backgroundColor: Colors.red[200]!,
    ).show(context);
  }
}

class FlushbarWarning {
  static void show({
    required BuildContext context,
    required String message,
  }) {
    Flushbar(
      message: message,
      messageColor: Colors.black,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.black,
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(10),
      leftBarIndicatorColor: warningColor,
      backgroundColor: Colors.orange[300]!,
    ).show(context);
  }
}
