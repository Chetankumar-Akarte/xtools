import 'package:flutter/material.dart';

/// Toast message type
enum XToastType {
  /// Success toast (green)
  success,

  /// Error toast (red)
  error,

  /// Warning toast (orange)
  warning,

  /// Info toast (blue)
  info,
}

/// A utility class to display toast notifications.
///
/// Provides easy methods to show different types of toasts
/// with appropriate icons and colors.
///
/// Example:
/// ```dart
/// XToast.success(context, 'Operation successful!');
/// XToast.error(context, 'Something went wrong');
/// ```
class XToast {
  /// Shows a toast message
  static void show(
    BuildContext context, {
    required String message,
    XToastType type = XToastType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    Color bgColor;
    IconData icon;

    switch (type) {
      case XToastType.success:
        bgColor = Colors.green.shade600;
        icon = Icons.check_circle_outline;
        break;
      case XToastType.error:
        bgColor = Colors.red.shade600;
        icon = Icons.error_outline;
        break;
      case XToastType.warning:
        bgColor = Colors.orange.shade600;
        icon = Icons.warning_amber_outlined;
        break;
      case XToastType.info:
        bgColor = Colors.blue.shade600;
        icon = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      behavior: behavior,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      duration: duration,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Shows a success toast
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: XToastType.success,
      duration: duration,
    );
  }

  /// Shows an error toast
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: XToastType.error,
      duration: duration,
    );
  }

  /// Shows a warning toast
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: XToastType.warning,
      duration: duration,
    );
  }

  /// Shows an info toast
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: XToastType.info,
      duration: duration,
    );
  }
}