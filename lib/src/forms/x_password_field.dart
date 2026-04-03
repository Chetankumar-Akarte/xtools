import 'package:flutter/material.dart';

/// Password strength levels
enum PasswordStrength {
  /// Very weak password
  weak,

  /// Weak to medium password
  fair,

  /// Medium password
  good,

  /// Strong password
  strong,

  /// Very strong password
  veryStrong,
}

/// A password input field with strength indicator.
///
/// Displays password visibility toggle and optional strength meter.
/// Shows real-time feedback on password strength.
///
/// Example:
/// ```dart
/// XPasswordField(
///   label: 'Password',
///   onChanged: (password) => print('Password: $password'),
///   showStrengthIndicator: true,
/// )
/// ```
class XPasswordField extends StatefulWidget {
  /// Label for the field
  final String label;

  /// Hint text
  final String? hintText;

  /// Initial value
  final String initialValue;

  /// Whether to show strength indicator
  final bool showStrengthIndicator;

  /// Called when password changes
  final ValueChanged<String>? onChanged;

  /// Called for validation
  final String? Function(String?)? validator;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Text input action
  final TextInputAction textInputAction;

  /// Decoration customization
  final InputDecoration? decoration;

  const XPasswordField({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue = '',
    this.showStrengthIndicator = true,
    this.onChanged,
    this.validator,
    this.controller,
    this.textInputAction = TextInputAction.done,
    this.decoration,
  });

  @override
  State<XPasswordField> createState() => _XPasswordFieldState();
}

class _XPasswordFieldState extends State<XPasswordField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  PasswordStrength _strength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue);
    _updateStrength(_controller.text);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength.weak;
    }

    int score = 0;

    // Length
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Uppercase
    if (password.contains(RegExp(r'[A-Z]'))) score++;

    // Lowercase
    if (password.contains(RegExp(r'[a-z]'))) score++;

    // Numbers
    if (password.contains(RegExp(r'[0-9]'))) score++;

    // Special characters
    if (password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]'))) {
      score++;
    }

    if (score <= 1) {
      return PasswordStrength.weak;
    } else if (score <= 2) {
      return PasswordStrength.fair;
    } else if (score <= 3) {
      return PasswordStrength.good;
    } else if (score <= 4) {
      return PasswordStrength.strong;
    } else {
      return PasswordStrength.veryStrong;
    }
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.fair:
        return Colors.orange;
      case PasswordStrength.good:
        return Colors.yellow.shade700;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  void _updateStrength(String password) {
    setState(() {
      _strength = _calculateStrength(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          onChanged: (value) {
            _updateStrength(value);
            widget.onChanged?.call(value);
          },
          validator: widget.validator,
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            labelText: widget.label,
            hintText: widget.hintText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
        if (widget.showStrengthIndicator && _controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_strength.index + 1) / PasswordStrength.values.length,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStrengthColor(_strength),
                    ),
                    minHeight: 4,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getStrengthText(_strength),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStrengthColor(_strength),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
