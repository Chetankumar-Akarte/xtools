import 'package:flutter/material.dart';

/// A customizable bottom sheet widget.
///
/// Supports both modal and persistent bottom sheets with smooth animations.
///
/// Example:
/// ```dart
/// XBottomSheet.modal(
///   context: context,
///   title: 'Options',
///   builder: (context) => ListView(
///     children: [...],
///   ),
/// )
/// ```
class XBottomSheet {
  /// Shows a modal bottom sheet
  static Future<T?> modal<T>({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
    double height = 0.6,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: true,
      builder: (context) => _BottomSheetContainer(
        title: title,
        child: builder(context),
      ),
    );
  }

  /// Shows a list bottom sheet with options
  static Future<int?> list({
    required BuildContext context,
    required String title,
    required List<String> options,
    bool isDismissible = true,
  }) async {
    return showModalBottomSheet<int>(
      context: context,
      isDismissible: isDismissible,
      useSafeArea: true,
      builder: (context) => _BottomSheetContainer(
        title: title,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(options[index]),
            onTap: () => Navigator.pop(context, index),
          ),
        ),
      ),
    );
  }

  /// Shows a bottom sheet with custom content and header
  static Future<T?> custom<T>({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: true,
      builder: (context) => _BottomSheetContainer(
        title: title,
        child: builder(context),
      ),
    );
  }

  /// Shows a text action bottom sheet
  static Future<String?> actions({
    required BuildContext context,
    required String title,
    required List<String> actions,
    bool isDismissible = true,
  }) async {
    return showModalBottomSheet<String>(
      context: context,
      isDismissible: isDismissible,
      useSafeArea: true,
      builder: (context) => _BottomSheetContainer(
        title: title,
        child: ListView.builder(
          itemCount: actions.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              actions[index],
              style: TextStyle(
                color: index == actions.length - 1 ? Colors.red : null,
              ),
            ),
            onTap: () => Navigator.pop(context, actions[index]),
          ),
        ),
      ),
    );
  }
}

/// Internal widget that wraps bottom sheet content with header
class _BottomSheetContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheetContainer({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(height: 1),
        // Content
        Expanded(child: child),
      ],
    );
  }
}
