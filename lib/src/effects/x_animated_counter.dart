import 'package:flutter/material.dart';

/// An animated counter widget that rolls up numbers.
///
/// Animates from one number to another with a smooth rolling effect.
/// Perfect for displaying stats, scores, or counts with visual appeal.
///
/// Example:
/// ```dart
/// XAnimatedCounter(
///   endValue: 1000,
///   duration: Duration(seconds: 2),
///   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
/// )
/// ```
class XAnimatedCounter extends StatefulWidget {
  /// The final value to animate to
  final int endValue;

  /// The initial value (defaults to 0)
  final int startValue;

  /// Duration of the animation
  final Duration duration;

  /// Text style for the counter
  final TextStyle? style;

  /// Whether to add thousands separator (e.g., 1,000)
  final bool useThousandsSeparator;

  /// Prefix text (e.g., '$' for currency)
  final String prefix;

  /// Suffix text (e.g., ' items')
  final String suffix;

  /// Curve for the animation
  final Curve curve;

  /// Alignment of the text
  final TextAlign textAlign;

  /// Called when animation completes
  final VoidCallback? onComplete;

  const XAnimatedCounter({
    super.key,
    required this.endValue,
    this.startValue = 0,
    this.duration = const Duration(seconds: 2),
    this.style,
    this.useThousandsSeparator = true,
    this.prefix = '',
    this.suffix = '',
    this.curve = Curves.easeOut,
    this.textAlign = TextAlign.center,
    this.onComplete,
  });

  @override
  State<XAnimatedCounter> createState() => _XAnimatedCounterState();
}

class _XAnimatedCounterState extends State<XAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = IntTween(
      begin: widget.startValue,
      end: widget.endValue,
    ).animate(CurvedAnimation(curve: widget.curve, parent: _controller));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(XAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endValue != widget.endValue ||
        oldWidget.startValue != widget.startValue ||
        oldWidget.duration != widget.duration) {
      _controller.reset();
      _animation = IntTween(
        begin: widget.startValue,
        end: widget.endValue,
      ).animate(
        CurvedAnimation(curve: widget.curve, parent: _controller),
      );
      _controller.forward();
    }
  }

  String _formatNumber(int value) {
    if (!widget.useThousandsSeparator) {
      return value.toString();
    }
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final formattedNumber = _formatNumber(_animation.value);
        final displayText =
            '${widget.prefix}$formattedNumber${widget.suffix}';

        return Text(
          displayText,
          textAlign: widget.textAlign,
          style: widget.style ??
              Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// A counter widget that animates between two values on demand.
///
/// Unlike [XAnimatedCounter], this widget allows you to update the target
/// value multiple times, with smooth transitions between changes.
///
/// Example:
/// ```dart
/// class MyCounter extends StatefulWidget {
///   @override
///   State<MyCounter> createState() => _MyCounterState();
/// }
///
/// class _MyCounterState extends State<MyCounter> {
///   int _count = 0;
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         XAnimatedCounterValue(
///           value: _count,
///           style: TextStyle(fontSize: 48),
///         ),
///         ElevatedButton(
///           onPressed: () => setState(() => _count++),
///           child: Text('Increment'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
class XAnimatedCounterValue extends StatefulWidget {
  /// The current value to display
  final int value;

  /// Duration of the animation between values
  final Duration duration;

  /// Text style for the counter
  final TextStyle? style;

  /// Whether to add thousands separator
  final bool useThousandsSeparator;

  /// Prefix text
  final String prefix;

  /// Suffix text
  final String suffix;

  /// Curve for the animation
  final Curve curve;

  /// Alignment of the text
  final TextAlign textAlign;

  const XAnimatedCounterValue({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 500),
    this.style,
    this.useThousandsSeparator = true,
    this.prefix = '',
    this.suffix = '',
    this.curve = Curves.easeInOut,
    this.textAlign = TextAlign.center,
  });

  @override
  State<XAnimatedCounterValue> createState() => _XAnimatedCounterValueState();
}

class _XAnimatedCounterValueState extends State<XAnimatedCounterValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = IntTween(
      begin: widget.value,
      end: widget.value,
    ).animate(CurvedAnimation(curve: widget.curve, parent: _controller));
  }

  @override
  void didUpdateWidget(XAnimatedCounterValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _animation = IntTween(
        begin: _previousValue,
        end: widget.value,
      ).animate(
        CurvedAnimation(curve: widget.curve, parent: _controller),
      );
      _controller.forward();
      _previousValue = widget.value;
    }
  }

  String _formatNumber(int value) {
    if (!widget.useThousandsSeparator) {
      return value.toString();
    }
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final formattedNumber = _formatNumber(_animation.value);
        final displayText =
            '${widget.prefix}$formattedNumber${widget.suffix}';

        return Text(
          displayText,
          textAlign: widget.textAlign,
          style: widget.style ??
              Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
