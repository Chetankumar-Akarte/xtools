import 'package:flutter/material.dart';

/// An empty state placeholder widget.
///
/// Shows when there's no data to display with optional action button.
/// Provides a clean, user-friendly way to handle empty states.
///
/// Example:
/// ```dart
/// XEmptyState(
///   icon: Icons.shopping_cart_outlined,
///   title: 'No Items',
///   subtitle: 'Your cart is empty',
///   actionLabel: 'Continue Shopping',
///   onAction: () => Navigator.pop(context),
/// )
/// ```
class XEmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Subtitle or description text
  final String? subtitle;

  /// Label for the action button
  final String? actionLabel;

  /// Callback when action button is pressed
  final VoidCallback? onAction;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon
  final Color iconColor;

  /// Padding around content
  final EdgeInsetsGeometry padding;

  const XEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80,
    this.iconColor = Colors.grey,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
