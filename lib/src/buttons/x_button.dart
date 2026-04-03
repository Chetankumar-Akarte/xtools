import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Button style variants
enum XButtonVariant {
  /// Filled button with elevation
  elevated,

  /// Outlined button with border
  outlined,

  /// Text-only button
  text,

  /// Gradient-filled button
  gradient,
}

/// A customizable button widget with multiple variants.
///
/// Supports elevated, outlined, text, and gradient styles.
/// Can include an optional icon and custom colors.
///
/// Example:
/// ```dart
/// XButton(
///   label: 'Click me',
///   onPressed: () => print('Clicked'),
///   variant: XButtonVariant.elevated,
///   icon: Icons.check,
/// )
/// ```
class XButton extends StatelessWidget {
  /// Button label text
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether button is in loading state
  final bool isLoading;

  /// Button style variant
  final XButtonVariant variant;

  /// Optional icon to display
  final IconData? icon;

  /// Custom color for the button
  final Color? color;

  /// Custom gradient (used when variant = gradient)
  final Gradient? gradient;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Border radius
  final double borderRadius;

  /// Loading indicator color
  final Color? loadingColor;

  const XButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = XButtonVariant.elevated,
    this.icon,
    this.color,
    this.gradient,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.primaryColor;
    final loadingIndicatorColor = loadingColor ?? Colors.white;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          );

    switch (variant) {
      case XButtonVariant.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: child,
          ),
        );
      case XButtonVariant.text:
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: child,
          ),
        );
      case XButtonVariant.gradient:
        return SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onPressed,
                borderRadius: BorderRadius.circular(borderRadius),
                child: Center(child: child),
              ),
            ),
          ),
        );
      case XButtonVariant.elevated:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: 0,
            ),
            child: child,
          ),
        );
    }
  }
}

/// A button that automatically shows loading state.
///
/// Perfect for async operations. Shows loading spinner while [onPressed] completes.
///
/// Example:
/// ```dart
/// XLoadingButton(
///   label: 'Submit',
///   onPressed: () async {
///     await submitForm();
///   },
/// )
/// ```
class XLoadingButton extends StatefulWidget {
  /// Button label text
  final String label;

  /// Async callback when button is pressed
  final Future<void> Function()? onPressed;

  /// Button style variant
  final XButtonVariant variant;

  /// Optional icon
  final IconData? icon;

  /// Custom color
  final Color? color;

  /// Loading state text (optional)
  final String? loadingText;

  /// Success state text (optional)
  final String? successText;

  /// Show success state for this duration
  final Duration successDuration;

  /// Gradient for gradient variant
  final Gradient? gradient;

  /// Border radius
  final double borderRadius;

  const XLoadingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = XButtonVariant.elevated,
    this.icon,
    this.color,
    this.loadingText,
    this.successText,
    this.successDuration = const Duration(milliseconds: 1500),
    this.gradient,
    this.borderRadius = 8,
  });

  @override
  State<XLoadingButton> createState() => _XLoadingButtonState();
}

class _XLoadingButtonState extends State<XLoadingButton> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _handlePressed() async {
    if (_isLoading || _isSuccess) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed?.call();

      if (mounted && widget.successText != null) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        await Future.delayed(widget.successDuration);

        if (mounted) {
          setState(() {
            _isSuccess = false;
          });
        }
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayLabel = widget.label;
    if (_isLoading && widget.loadingText != null) {
      displayLabel = widget.loadingText!;
    } else if (_isSuccess && widget.successText != null) {
      displayLabel = widget.successText!;
    }

    return XButton(
      label: displayLabel,
      onPressed: _handlePressed,
      isLoading: _isLoading,
      variant: widget.variant,
      icon: _isSuccess ? Icons.check : widget.icon,
      color: widget.color,
      gradient: widget.gradient,
      borderRadius: widget.borderRadius,
    );
  }
}

/// A button that copies text to clipboard.
///
/// Shows visual feedback when text is copied.
///
/// Example:
/// ```dart
/// XCopyButton(
///   text: 'Copy me!',
///   label: 'Copy',
/// )
/// ```
class XCopyButton extends StatefulWidget {
  /// Text to copy to clipboard
  final String text;

  /// Button label
  final String label;

  /// Icon to show
  final IconData icon;

  /// Feedback message
  final String feedbackMessage;

  /// Duration to show feedback
  final Duration feedbackDuration;

  /// Button variant
  final XButtonVariant variant;

  /// Button color
  final Color? color;

  /// Border radius
  final double borderRadius;

  const XCopyButton({
    super.key,
    required this.text,
    this.label = 'Copy',
    this.icon = Icons.copy,
    this.feedbackMessage = 'Copied!',
    this.feedbackDuration = const Duration(milliseconds: 1500),
    this.variant = XButtonVariant.outlined,
    this.color,
    this.borderRadius = 8,
  });

  @override
  State<XCopyButton> createState() => _XCopyButtonState();
}

class _XCopyButtonState extends State<XCopyButton> {
  bool _isCopied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.text));

    if (!mounted) return;

    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.feedbackMessage),
        duration: widget.feedbackDuration,
      ),
    );

    await Future.delayed(widget.feedbackDuration);

    if (mounted) {
      setState(() {
        _isCopied = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return XButton(
      label: widget.label,
      onPressed: _copyToClipboard,
      variant: widget.variant,
      icon: _isCopied ? Icons.check : widget.icon,
      color: widget.color,
      borderRadius: widget.borderRadius,
    );
  }
}