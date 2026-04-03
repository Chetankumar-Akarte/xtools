import 'package:flutter/material.dart';

/// A multi-step progress indicator widget.
///
/// Shows progress through a sequence of steps with optional titles and descriptions.
/// Can be horizontal or vertical.
///
/// Example:
/// ```dart
/// XStepperWidget(
///   steps: ['Personal', 'Address', 'Payment', 'Confirm'],
///   currentStep: 1,
///   orientation: Axis.horizontal,
/// )
/// ```
class XStepperWidget extends StatelessWidget {
  /// List of step titles
  final List<String> steps;

  /// Index of the current step
  final int currentStep;

  /// Orientation of stepper (horizontal or vertical)
  final Axis orientation;

  /// Color for completed steps
  final Color completedColor;

  /// Color for current step
  final Color currentColor;

  /// Color for incomplete steps
  final Color incompleteColor;

  /// Size of step circles
  final double stepSize;

  /// Callback when step is tapped
  final ValueChanged<int>? onStepTapped;

  /// Descriptions for each step (optional)
  final List<String>? descriptions;

  const XStepperWidget({
    super.key,
    required this.steps,
    required this.currentStep,
    this.orientation = Axis.horizontal,
    this.completedColor = Colors.green,
    this.currentColor = Colors.blue,
    this.incompleteColor = Colors.grey,
    this.stepSize = 40,
    this.onStepTapped,
    this.descriptions,
  }) : assert(
    currentStep >= 0 && currentStep < steps.length,
    'currentStep must be between 0 and steps.length - 1',
  );

  @override
  Widget build(BuildContext context) {
    if (orientation == Axis.horizontal) {
      return _buildHorizontalStepper();
    } else {
      return _buildVerticalStepper();
    }
  }

  Widget _buildHorizontalStepper() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          steps.length * 2 - 1,
          (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              return _buildStepCircle(stepIndex);
            } else {
              final lineIndex = index ~/ 2;
              return _buildConnector(lineIndex);
            }
          },
        ),
      ),
    );
  }

  Widget _buildVerticalStepper() {
    return Column(
      children: List.generate(
        steps.length,
        (index) {
          return Column(
            children: [
              _buildStepRow(index),
              if (index < steps.length - 1) _buildVerticalConnector(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepRow(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepCircle(index),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                steps[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStepColor(index),
                ),
              ),
              if (descriptions != null && descriptions!.length > index)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    descriptions![index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepCircle(int index) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final color = isCompleted
        ? completedColor
        : isCurrent
            ? currentColor
            : incompleteColor;

    return GestureDetector(
      onTap: () => onStepTapped?.call(index),
      child: Container(
        width: stepSize,
        height: stepSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: isCompleted
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: stepSize * 0.5,
                )
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: stepSize * 0.4,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildConnector(int index) {
    final isCompleted = index < currentStep;
    final color = isCompleted ? completedColor : incompleteColor;

    return Container(
      width: 30,
      height: 2,
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildVerticalConnector() {
    return Padding(
      padding: EdgeInsets.only(left: stepSize * 0.5 - 1),
      child: Container(
        width: 2,
        height: 30,
        color: incompleteColor,
      ),
    );
  }

  Color _getStepColor(int index) {
    if (index < currentStep) {
      return completedColor;
    } else if (index == currentStep) {
      return currentColor;
    }
    return incompleteColor;
  }
}
