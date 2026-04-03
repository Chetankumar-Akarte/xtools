import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A confetti particle
class _ConfettiParticle {
  late Offset position;
  late Offset velocity;
  late double rotation;
  late double rotationVelocity;
  late double life;
  final double maxLife;
  final Color color;
  final Size size;

  _ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.maxLife,
    required this.color,
    required this.size,
  })  : life = maxLife,
        rotation = 0,
        rotationVelocity = 0;

  void update(double deltaTime) {
    position += velocity * deltaTime;
    velocity += Offset(0, 9.8 * deltaTime); // gravity
    rotation += rotationVelocity * deltaTime;
    life -= deltaTime;
  }

  bool get isAlive => life > 0;

  double get opacity => life / maxLife;
}

/// Controller for confetti burst animations
class ConfettiController {
  final List<Function(Offset)> _listeners = [];

  void addListener(Function(Offset) callback) {
    _listeners.add(callback);
  }

  void removeListener(Function(Offset) callback) {
    _listeners.remove(callback);
  }

  /// Trigger a confetti burst at the given offset
  void burst({Offset offset = Offset.zero}) {
    for (var listener in _listeners) {
      listener(offset);
    }
  }
}

/// A confetti burst animation widget.
///
/// Creates a burst of confetti particles that fall and rotate.
/// Use the [controller] to trigger confetti at any time.
///
/// Example:
/// ```dart
/// final controller = ConfettiController();
///
/// XConfetti(
///   controller: controller,
///   particleCount: 30,
/// )
///
/// // Trigger confetti
/// ElevatedButton(
///   onPressed: () => controller.burst(offset: Offset(100, 100)),
///   child: Text('Celebrate!'),
/// )
/// ```
class XConfetti extends StatefulWidget {
  /// Controller to trigger confetti bursts
  final ConfettiController? controller;

  /// Number of confetti pieces per burst
  final int particleCount;

  /// Duration of particle lifespan in seconds
  final double particleLife;

  /// Colors to randomly choose from for confetti
  final List<Color> colors;

  /// Child widget to display behind confetti
  final Widget? child;

  /// Whether to allow multiple simultaneous bursts
  final bool allowMultipleBursts;

  const XConfetti({
    super.key,
    this.controller,
    this.particleCount = 30,
    this.particleLife = 2.5,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
    ],
    this.child,
    this.allowMultipleBursts = true,
  });

  @override
  State<XConfetti> createState() => _XConfettiState();
}

class _XConfettiState extends State<XConfetti> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<_ConfettiParticle> _particles = [];
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    _controller = widget.controller ?? ConfettiController();
    _controller.addListener(_handleBurst);
  }

  @override
  void didUpdateWidget(XConfetti oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleBurst);
      _controller = widget.controller ?? ConfettiController();
      _controller.addListener(_handleBurst);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleBurst(Offset offset) {
    if (!widget.allowMultipleBursts && _particles.isNotEmpty) {
      return;
    }

    final random = math.Random();
    for (int i = 0; i < widget.particleCount; i++) {
      final angle = (2 * math.pi * random.nextDouble());
      final speed = 150 + random.nextDouble() * 250;
      final particle = _ConfettiParticle(
        position: offset,
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed - 50,
        ),
        maxLife: widget.particleLife,
        color: widget.colors[random.nextInt(widget.colors.length)],
        size: const Size(4, 8),
      );
      particle.rotationVelocity = (random.nextDouble() - 0.5) * 8;
      _particles.add(particle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        // Update particles
        _particles.removeWhere((p) => !p.isAlive);
        for (var particle in _particles) {
          particle.update(0.016); // ~60fps
        }

        return CustomPaint(
          foregroundPainter: _ConfettiPainter(_particles),
          child: child ?? Container(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleBurst);
    _animationController.dispose();
    super.dispose();
  }
}

/// Painter for rendering confetti particles
class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity);

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size.width,
          height: particle.size.height,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
