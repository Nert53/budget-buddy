import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarSuccess {
  static void show({
    required BuildContext context,
    required String message,
  }) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      icon: Icon(
        Icons.check_circle_outline_outlined,
        color: Colors.white,
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Colors.green,
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
      messageColor: Theme.of(context).colorScheme.onErrorContainer,
      icon: Icon(
        Icons.error_outline_outlined,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
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
      messageColor: Colors.white,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.white,
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Colors.orange[800]!,
    ).show(context);
  }
}
