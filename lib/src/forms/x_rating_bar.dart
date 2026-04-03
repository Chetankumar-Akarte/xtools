import 'package:flutter/material.dart';

/// A customizable rating bar widget using stars.
///
/// Allows users to select a rating by tapping on stars.
/// Can be interactive or display-only.
///
/// Example:
/// ```dart
/// XRatingBar(
///   rating: 3.5,
///   onRatingChanged: (rating) => print('Rating: $rating'),
/// )
/// ```
class XRatingBar extends StatefulWidget {
  /// Current rating value
  final double rating;

  /// Maximum rating (typically 5)
  final int maxRating;

  /// Size of each star
  final double size;

  /// Color of filled stars
  final Color filledColor;

  /// Color of unfilled stars
  final Color unfilledColor;

  /// Whether the rating bar is interactive
  final bool isInteractive;

  /// Callback when rating changes
  final ValueChanged<double>? onRatingChanged;

  /// Whether to allow half-star ratings
  final bool allowHalfRating;

  /// Icon to use instead of star
  final IconData icon;

  const XRatingBar({
    super.key,
    this.rating = 0.0,
    this.maxRating = 5,
    this.size = 28,
    this.filledColor = Colors.amber,
    this.unfilledColor = Colors.grey,
    this.isInteractive = true,
    this.onRatingChanged,
    this.allowHalfRating = false,
    this.icon = Icons.star,
  }) : assert(rating >= 0 && rating <= maxRating, 'Rating must be between 0 and maxRating');

  @override
  State<XRatingBar> createState() => _XRatingBarState();
}

class _XRatingBarState extends State<XRatingBar> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(XRatingBar oldWidget) {
    if (oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setRating(int starIndex, Offset tapPosition) {
    if (!widget.isInteractive) return;

    double newRating = (starIndex + 1).toDouble();

    if (widget.allowHalfRating) {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final dx = tapPosition.dx;
      final starWidth = size.width / widget.maxRating;
      final isLeftHalf = (dx % starWidth) < starWidth / 2;

      if (isLeftHalf) {
        newRating = starIndex + 0.5;
      }
    }

    setState(() {
      _currentRating = newRating;
    });

    widget.onRatingChanged?.call(_currentRating);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isInteractive
          ? (details) {
              final starIndex =
                  (details.localPosition.dx / (widget.size + 4)).toInt();
              if (starIndex >= 0 && starIndex < widget.maxRating) {
                _setRating(starIndex, details.localPosition);
              }
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.maxRating,
          (index) {
            final isFilled = _currentRating >= index + 1;
            final isHalfFilled =
                _currentRating > index && _currentRating < index + 1;

            if (isHalfFilled && widget.allowHalfRating) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: widget.size,
                    color: widget.unfilledColor,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRect(
                      child: Icon(
                        widget.icon,
                        size: widget.size,
                        color: widget.filledColor,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                widget.icon,
                size: widget.size,
                color: isFilled ? widget.filledColor : widget.unfilledColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
