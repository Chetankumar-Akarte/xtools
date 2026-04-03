import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A particle in the fireworks animation
class _Particle {
  late Offset position;
  late Offset velocity;
  late double life;
  final double maxLife;
  final Color color;
  final double radius;

  _Particle({
    required this.position,
    required this.velocity,
    required this.maxLife,
    required this.color,
    required this.radius,
  }) : life = maxLife;

  void update(double deltaTime) {
    position += velocity * deltaTime;
    velocity += Offset(0, 9.8 * deltaTime); // gravity
    life -= deltaTime;
  }

  bool get isAlive => life > 0;

  double get opacity => life / maxLife;
}

/// A canvas-based fireworks animation widget.
///
/// Creates an explosion effect with particles that fall due to gravity.
/// Use the [controller] to trigger fireworks at any time.
///
/// Example:
/// ```dart
/// final controller = FireworksController();
///
/// // In your widget tree
/// XFireworks(
///   controller: controller,
///   particleCount: 50,
/// )
///
/// // Trigger fireworks on button tap
/// ElevatedButton(
///   onPressed: () => controller.explode(offset),
///   child: Text('Fireworks!'),
/// )
/// ```
class XFireworks extends StatefulWidget {
  /// Controller to trigger fireworks
  final FireworksController? controller;

  /// Number of particles per explosion
  final int particleCount;

  /// Duration of particle lifespan in seconds
  final double particleLife;

  /// Colors to randomly choose from for particles
  final List<Color> colors;

  /// Child widget to display behind fireworks
  final Widget? child;

  const XFireworks({
    super.key,
    this.controller,
    this.particleCount = 50,
    this.particleLife = 2.0,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ],
    this.child,
  });

  @override
  State<XFireworks> createState() => _XFireworksState();
}

class _XFireworksState extends State<XFireworks> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<_Particle> _particles = [];
  FireworksController? _controller;
  late Function(Offset) _handleExplosionFunction;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    _handleExplosionFunction = _handleExplosion;

    _controller = widget.controller ?? FireworksController();
    _controller!._addListener(_handleExplosionFunction);
  }

  @override
  void didUpdateWidget(XFireworks oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _controller?._removeListener(_handleExplosionFunction);
      _controller = widget.controller ?? FireworksController();
      _controller!._addListener(_handleExplosionFunction);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleExplosion(Offset offset) {
    final random = math.Random();
    for (int i = 0; i < widget.particleCount; i++) {
      final angle = (2 * math.pi * i) / widget.particleCount;
      final speed = 200 + random.nextDouble() * 300;
      final particle = _Particle(
        position: offset,
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        maxLife: widget.particleLife,
        color: widget.colors[random.nextInt(widget.colors.length)],
        radius: 2 + random.nextDouble() * 4,
      );
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
          foregroundPainter: _FireworksPainter(_particles),
          child: child ?? Container(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?._removeListener(_handleExplosionFunction);
    _animationController.dispose();
    super.dispose();
  }
}

/// Painter for rendering fireworks particles
class _FireworksPainter extends CustomPainter {
  final List<_Particle> particles;

  _FireworksPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..strokeWidth = particle.radius;

      canvas.drawCircle(
        particle.position,
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_FireworksPainter oldDelegate) => true;
}

/// Controller for triggering fireworks explosions
class FireworksController {
  VoidCallback? _listener;

  void _addListener(Function(Offset) callback) {
    _listener = () => callback(Offset.zero);
  }

  void _removeListener(Function(Offset) callback) {
    _listener = null;
  }

  /// Trigger a fireworks explosion at the given offset
  void explode(Offset offset) {
    _listener?.call();
  }
}
