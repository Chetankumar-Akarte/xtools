import 'package:flutter/material.dart';

/// A customizable dialog widget.
///
/// Supports alert, confirm, and input dialog types.
/// Easy to use with material design 3 styling.
///
/// Example:
/// ```dart
/// XDialog.confirm(
///   context: context,
///   title: 'Confirm?',
///   message: 'Are you sure?',
///   onConfirm: () => print('Confirmed'),
/// )
/// ```
class XDialog {
  /// Shows a simple alert dialog
  static Future<void> alert({
    required BuildContext context,
    required String title,
    String? message,
    String actionLabel = 'OK',
    VoidCallback? onAction,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: onAction ?? () => Navigator.pop(context),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog with OK and Cancel buttons
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.pop(context, false);
            },
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context, true);
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog with an input field
  static Future<String?> input({
    required BuildContext context,
    required String title,
    String? message,
    String hintText = '',
    String submitLabel = 'Submit',
    String cancelLabel = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message != null) ...[
              Text(message),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(submitLabel),
          ),
        ],
      ),
    );
  }

  /// Shows a custom dialog with a builder widget
  static Future<T?> custom<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }
}
