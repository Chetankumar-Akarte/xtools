import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Different loader animation styles.
enum LoaderStyle {
  /// Rotating circular loader.
  circular,

  /// Bouncing dots.
  dots,

  /// Pulsing ring animation.
  pulse,

  /// Vertical bars wave animation.
  wave,

  /// Horizontal bar loader.
  bar,

  /// Orbiting squares loader.
  squares,

  /// Progressive dots appearing in sequence.
  progressiveDots,

  /// Staggered dots wave animation.
  staggeredDotsWave,

  /// Three dots wave animation.
  waveDots,

  /// Ink drop style pulse.
  inkDrop,

  /// Two dots twisting around center.
  twistingDots,

  /// Single bouncing ball loader.
  bouncingBall,

  /// Three rotating dots around center.
  threeRotatingDots,

  /// Four rotating dots around center.
  fourRotatingDots,

  /// Single dot falling and rebounding.
  fallingDot,

  /// Two opposite rotating arcs.
  twoRotatingArc,

  /// Discrete concentric circle pulses.
  discreteCircle,

  /// Alias naming matching reference package.
  discreteCircular,

  /// Three arched circle segments.
  threeArchedCircle,

  /// Two-color crossing dots inspired by Flickr.
  flickr,

  /// Hexagon dot orbit.
  hexagonDots,

  /// Three-dot beat pulse.
  beat,

  /// Horizontal rotating dots row.
  horizontalRotatingDots,

  /// Dot stretch/compress animation.
  stretchedDots,

  /// Half-triangle rotating dot group.
  halfTriangleDot,

  /// Triangle dot orbit.
  dotsTriangle,

  /// Newton cradle swinging balls.
  newtonCradle,
}

/// Per-style configuration object for [XLoader].
@immutable
class XLoaderConfig {
  /// Number of dots used by dot-based styles.
  final int dotCount;

  /// Number of bars used by wave-like bar styles.
  final int barCount;

  /// Multiplier for vertical movement/amplitude in wave/bounce styles.
  final double amplitudeFactor;

  /// Multiplier for orbit radius in rotating styles.
  final double orbitRadiusFactor;

  const XLoaderConfig({
    this.dotCount = 3,
    this.barCount = 3,
    this.amplitudeFactor = 1.0,
    this.orbitRadiusFactor = 1.0,
  });

  /// Returns a copy with selective overrides.
  XLoaderConfig copyWith({
    int? dotCount,
    int? barCount,
    double? amplitudeFactor,
    double? orbitRadiusFactor,
  }) {
    return XLoaderConfig(
      dotCount: dotCount ?? this.dotCount,
      barCount: barCount ?? this.barCount,
      amplitudeFactor: amplitudeFactor ?? this.amplitudeFactor,
      orbitRadiusFactor: orbitRadiusFactor ?? this.orbitRadiusFactor,
    );
  }
}

/// Theme data for [XLoader] subtree defaults.
@immutable
class XLoaderThemeData {
  /// Default loader style.
  final LoaderStyle style;

  /// Default primary color.
  final Color color;

  /// Default secondary color for multi-color styles.
  final Color? secondaryColor;

  /// Default loader size.
  final double size;

  /// Default animation cycle duration.
  final Duration duration;

  /// Default stroke width for arc/ring styles.
  final double strokeWidth;

  /// Default semantic label used by assistive technologies.
  final String semanticLabel;

  /// Default enable/disable setting for animations.
  final bool enableAnimations;

  /// Default per-style config.
  final XLoaderConfig config;

  const XLoaderThemeData({
    this.style = LoaderStyle.circular,
    this.color = Colors.blue,
    this.secondaryColor,
    this.size = 48,
    this.duration = const Duration(seconds: 1),
    this.strokeWidth = 2.5,
    this.semanticLabel = 'Loading',
    this.enableAnimations = true,
    this.config = const XLoaderConfig(),
  });

  /// Returns a copy with selective overrides.
  XLoaderThemeData copyWith({
    LoaderStyle? style,
    Color? color,
    Color? secondaryColor,
    double? size,
    Duration? duration,
    double? strokeWidth,
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) {
    return XLoaderThemeData(
      style: style ?? this.style,
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      config: config ?? this.config,
    );
  }
}

/// Inherited theme to provide default loader options to subtree widgets.
class XLoaderTheme extends InheritedWidget {
  /// Loader theme data.
  final XLoaderThemeData data;

  const XLoaderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns nearest theme, or default data if absent.
  static XLoaderThemeData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<XLoaderTheme>();
    return inherited?.data ?? const XLoaderThemeData();
  }

  /// Returns nearest theme if present.
  static XLoaderThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<XLoaderTheme>()?.data;
  }

  @override
  bool updateShouldNotify(XLoaderTheme oldWidget) => data != oldWidget.data;
}

/// A collection of animated loaders for loading states.
///
/// Provides multiple loader animations to suit different UI styles.
/// Use the [style] parameter to choose between various animations.
class XLoader extends StatefulWidget {
  /// The loader animation style.
  final LoaderStyle? style;

  /// Primary color of the loader.
  final Color? color;

  /// Optional secondary color used in multi-color styles.
  final Color? secondaryColor;

  /// Size of the loader.
  final double? size;

  /// Duration of one animation cycle.
  final Duration? duration;

  /// Stroke width used by arc/ring-based loaders.
  final double? strokeWidth;

  /// Semantic label for screen readers.
  final String? semanticLabel;

  /// Whether this loader should animate.
  ///
  /// If null, theme/default behavior is used.
  final bool? enableAnimations;

  /// Per-style configuration overrides.
  final XLoaderConfig? config;

  const XLoader({
    super.key,
    this.style,
    this.color,
    this.secondaryColor,
    this.size,
    this.duration,
    this.strokeWidth,
    this.semanticLabel,
    this.enableAnimations,
    this.config,
  });

  /// Convenience constructor for progressive dots loader.
  const XLoader.progressiveDots({
    Key? key,
    required Color color,
    double size = 48,
    Duration duration = const Duration(milliseconds: 950),
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.progressiveDots,
          color: color,
          size: size,
          duration: duration,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for staggered dots wave loader.
  const XLoader.staggeredDotsWave({
    Key? key,
    required Color color,
    double size = 48,
    Duration duration = const Duration(milliseconds: 900),
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.staggeredDotsWave,
          color: color,
          size: size,
          duration: duration,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for wave dots loader.
  const XLoader.waveDots({
    Key? key,
    required Color color,
    double size = 48,
    Duration duration = const Duration(milliseconds: 900),
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.waveDots,
          color: color,
          size: size,
          duration: duration,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for bouncing ball loader.
  const XLoader.bouncingBall({
    Key? key,
    required Color color,
    double size = 48,
    Duration duration = const Duration(milliseconds: 900),
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.bouncingBall,
          color: color,
          size: size,
          duration: duration,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for three rotating dots loader.
  const XLoader.threeRotatingDots({
    Key? key,
    required Color color,
    double size = 48,
    Duration duration = const Duration(milliseconds: 1200),
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.threeRotatingDots,
          color: color,
          size: size,
          duration: duration,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for two rotating arc loader.
  const XLoader.twoRotatingArc({
    Key? key,
    required Color color,
    Color? secondaryColor,
    double size = 48,
    Duration duration = const Duration(milliseconds: 1100),
    double strokeWidth = 3,
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.twoRotatingArc,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          duration: duration,
          strokeWidth: strokeWidth,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for discrete circle loader.
  const XLoader.discreteCircle({
    Key? key,
    required Color color,
    Color? secondaryColor,
    double size = 48,
    Duration duration = const Duration(milliseconds: 1300),
    double strokeWidth = 3,
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.discreteCircle,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          duration: duration,
          strokeWidth: strokeWidth,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  /// Convenience constructor for newton cradle loader.
  const XLoader.newtonCradle({
    Key? key,
    required Color color,
    double size = 48,
    Duration duration = const Duration(milliseconds: 1200),
    String? semanticLabel,
    bool? enableAnimations,
    XLoaderConfig? config,
  }) : this(
          key: key,
          style: LoaderStyle.newtonCradle,
          color: color,
          size: size,
          duration: duration,
          semanticLabel: semanticLabel,
          enableAnimations: enableAnimations,
          config: config,
        );

  @override
  State<XLoader> createState() => _XLoaderState();
}

class _XLoaderState extends State<XLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(XLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimationState(reset: oldWidget.duration != widget.duration);
  }

  void _syncAnimationState({bool reset = false}) {
    final resolved = _resolve(context);
    if (_controller.duration != resolved.duration) {
      _controller.duration = resolved.duration;
      reset = true;
    }

    if (resolved.animate) {
      if (reset || !_controller.isAnimating) {
        _controller
          ..stop()
          ..repeat();
      }
    } else {
      _controller.stop();
      _controller.value = 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolve(context);

    final loader = SizedBox(
      width: resolved.size,
      height: resolved.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return _buildByStyle(
            style: resolved.style,
            progress: _controller.value,
            color: resolved.color,
            secondaryColor: resolved.secondaryColor,
            size: resolved.size,
            strokeWidth: resolved.strokeWidth,
            config: resolved.config,
          );
        },
      ),
    );

    return Semantics(
      label: resolved.semanticLabel,
      value: resolved.animate ? 'in progress' : 'static',
      child: loader,
    );
  }

  Widget _buildByStyle({
    required LoaderStyle style,
    required double progress,
    required Color color,
    required Color secondaryColor,
    required double size,
    required double strokeWidth,
    required XLoaderConfig config,
  }) {
    switch (style) {
      case LoaderStyle.circular:
        return _CircularLoader(
          progress: progress,
          color: color,
          strokeWidth: strokeWidth,
        );
      case LoaderStyle.dots:
        return _DotsLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.pulse:
        return _PulseLoader(
          progress: progress,
          color: color,
          size: size,
          strokeWidth: strokeWidth,
        );
      case LoaderStyle.wave:
        return _WaveLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.bar:
        return _BarLoader(
          progress: progress,
          color: color,
          size: size,
        );
      case LoaderStyle.squares:
        return _SquaresLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.progressiveDots:
        return _ProgressiveDotsLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.staggeredDotsWave:
        return _StaggeredDotsWaveLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.waveDots:
        return _WaveDotsLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.inkDrop:
        return _InkDropLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          strokeWidth: strokeWidth,
        );
      case LoaderStyle.twistingDots:
        return _TwistingDotsLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          config: config,
        );
      case LoaderStyle.bouncingBall:
        return _BouncingBallLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.threeRotatingDots:
        return _ThreeRotatingDotsLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.fourRotatingDots:
        return _FourRotatingDotsLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          config: config,
        );
      case LoaderStyle.fallingDot:
        return _FallingDotLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.twoRotatingArc:
        return _TwoRotatingArcLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          strokeWidth: strokeWidth,
        );
      case LoaderStyle.discreteCircle:
      case LoaderStyle.discreteCircular:
        return _DiscreteCircleLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          strokeWidth: strokeWidth,
        );
      case LoaderStyle.threeArchedCircle:
        return _ThreeArchedCircleLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          strokeWidth: strokeWidth,
        );
      case LoaderStyle.flickr:
        return _FlickrLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          config: config,
        );
      case LoaderStyle.hexagonDots:
        return _HexagonDotsLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          config: config,
        );
      case LoaderStyle.beat:
        return _BeatLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.horizontalRotatingDots:
        return _HorizontalRotatingDotsLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.stretchedDots:
        return _StretchedDotsLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
      case LoaderStyle.halfTriangleDot:
        return _HalfTriangleDotLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          config: config,
        );
      case LoaderStyle.dotsTriangle:
        return _DotsTriangleLoader(
          progress: progress,
          color: color,
          secondaryColor: secondaryColor,
          size: size,
          config: config,
        );
      case LoaderStyle.newtonCradle:
        return _NewtonCradleLoader(
          progress: progress,
          color: color,
          size: size,
          config: config,
        );
    }
  }

  _ResolvedLoader _resolve(BuildContext context) {
    final theme = XLoaderTheme.maybeOf(context) ?? const XLoaderThemeData();

    final style = widget.style ?? theme.style;
    final color = widget.color ?? theme.color;
    final secondaryColor = widget.secondaryColor ??
        theme.secondaryColor ??
        color.withValues(alpha: 0.55);
    final size = widget.size ?? theme.size;
    final duration = widget.duration ?? theme.duration;
    final strokeWidth = widget.strokeWidth ?? theme.strokeWidth;
    final semanticLabel = widget.semanticLabel ?? theme.semanticLabel;
    final config = widget.config ?? theme.config;

    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    // ignore: deprecated_member_use
    // TickerMode.valuesOf was introduced in Flutter 3.35+; .of() is the
    // compatible fallback for Flutter >=3.10. Remove this ignore and switch
    // to TickerMode.valuesOf(context).enabled once the minimum Flutter
    // constraint is raised to >=3.35.0.
    final tickerEnabled = TickerMode.of(context);
    final requestedAnimation =
        widget.enableAnimations ?? theme.enableAnimations;
    final animate = requestedAnimation && !disableAnimations && tickerEnabled;

    return _ResolvedLoader(
      style: style,
      color: color,
      secondaryColor: secondaryColor,
      size: size,
      duration: duration,
      strokeWidth: strokeWidth,
      semanticLabel: semanticLabel,
      config: config,
      animate: animate,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _ResolvedLoader {
  final LoaderStyle style;
  final Color color;
  final Color secondaryColor;
  final double size;
  final Duration duration;
  final double strokeWidth;
  final String semanticLabel;
  final XLoaderConfig config;
  final bool animate;

  const _ResolvedLoader({
    required this.style,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.duration,
    required this.strokeWidth,
    required this.semanticLabel,
    required this.config,
    required this.animate,
  });
}

class _CircularLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double strokeWidth;

  const _CircularLoader({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: progress * 2 * math.pi,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _DotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _DotsLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(2, 8);
    final dotSize = size * 0.16;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final phase = (progress + (index * 0.12)) % 1.0;
        final scale = 0.5 + 0.5 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi));
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dotSize * 0.14),
          child: Transform.scale(
            scale: scale,
            child: _dot(color: color, size: dotSize),
          ),
        );
      }),
    );
  }
}

class _PulseLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;

  const _PulseLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final scale = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi));
    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: strokeWidth),
        ),
      ),
    );
  }
}

class _WaveLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _WaveLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final barCount = config.barCount.clamp(3, 8);
    final barWidth = size * 0.08;
    final barHeight = size * 0.62;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(barCount, (index) {
        final alpha = 0.3 +
            (0.7 *
                math.sin(
                  (progress * 2 * math.pi) + (index * math.pi / barCount),
                ));
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: barWidth * 0.2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              width: barWidth,
              height: barHeight,
              color: color.withValues(alpha: alpha),
            ),
          ),
        );
      }),
    );
  }
}

class _BarLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;

  const _BarLoader({
    required this.progress,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: size * 0.12,
        width: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: color.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}

class _SquaresLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _SquaresLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final center = size * 0.5;
    final radius = size * 0.24 * config.orbitRadiusFactor.clamp(0.5, 1.8);
    final square = size * 0.16;

    return Stack(
      children: List.generate(4, (index) {
        final angle = (index * math.pi / 2) + (progress * 2 * math.pi);
        return Positioned(
          left: center + radius * math.cos(angle) - square * 0.5,
          top: center + radius * math.sin(angle) - square * 0.5,
          child: Container(
            width: square,
            height: square,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _ProgressiveDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _ProgressiveDotsLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 8);
    final dotSize = size * 0.15;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final phase = (progress + (index * 0.18)) % 1.0;
        final scale = 0.55 + (0.45 * phase);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dotSize * 0.12),
          child: Transform.scale(
            scale: scale,
            child: _dot(
              color: color.withValues(alpha: 0.35 + (0.65 * phase)),
              size: dotSize,
            ),
          ),
        );
      }),
    );
  }
}

class _StaggeredDotsWaveLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _StaggeredDotsWaveLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 9);
    final dotSize = size * 0.14;
    final amp = size * 0.14 * config.amplitudeFactor.clamp(0.4, 2.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final phase = progress * 2 * math.pi + (index * 0.7);
        final dy = math.sin(phase) * amp;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dotSize * 0.15),
          child: Transform.translate(
            offset: Offset(0, -dy),
            child: _dot(color: color, size: dotSize),
          ),
        );
      }),
    );
  }
}

class _WaveDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _WaveDotsLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 7);
    final dotSize = size * 0.18;
    final amp = size * 0.16 * config.amplitudeFactor.clamp(0.4, 2.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final phase = progress * 2 * math.pi + (index * 0.8);
        final dy = math.sin(phase) * amp;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dotSize * 0.1),
          child: Transform.translate(
            offset: Offset(0, -dy),
            child: _dot(color: color, size: dotSize),
          ),
        );
      }),
    );
  }
}

class _InkDropLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final double strokeWidth;

  const _InkDropLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final pulse = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi));
    final ripple1 = (progress + 0.15) % 1.0;
    final ripple2 = (progress + 0.55) % 1.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        _ring(size * (0.35 + ripple1 * 0.65),
            secondaryColor.withValues(alpha: (1 - ripple1) * 0.45)),
        _ring(size * (0.35 + ripple2 * 0.65),
            color.withValues(alpha: (1 - ripple2) * 0.35)),
        Transform.scale(
          scale: pulse,
          child: _dot(color: color, size: size * 0.22),
        ),
      ],
    );
  }

  Widget _ring(double ringSize, Color ringColor) {
    return Container(
      width: ringSize,
      height: ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: strokeWidth),
      ),
    );
  }
}

class _TwistingDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final XLoaderConfig config;

  const _TwistingDotsLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final center = size * 0.5;
    final dotSize = size * 0.2;
    final radius = size * 0.24 * config.orbitRadiusFactor.clamp(0.5, 1.8);
    final angle = progress * 2 * math.pi;

    final x1 = center + radius * math.cos(angle);
    final y1 = center + radius * math.sin(angle);
    final x2 = center + radius * math.cos(angle + math.pi);
    final y2 = center + radius * math.sin(angle + math.pi);

    return Stack(
      children: [
        Positioned(
            left: x1 - dotSize * 0.5,
            top: y1 - dotSize * 0.5,
            child: _dot(color: color, size: dotSize)),
        Positioned(
            left: x2 - dotSize * 0.5,
            top: y2 - dotSize * 0.5,
            child: _dot(color: secondaryColor, size: dotSize)),
      ],
    );
  }
}

class _BouncingBallLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _BouncingBallLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final ballSize = size * 0.2;
    final groundY = size * 0.78;
    final maxBounce = size * 0.52 * config.amplitudeFactor.clamp(0.4, 2.0);
    final bounce = (math.sin(progress * math.pi).abs()) * maxBounce;

    return Stack(
      children: [
        Positioned(
          left: size * 0.1,
          right: size * 0.1,
          top: groundY,
          child: Container(
            height: 2,
            color: color.withValues(alpha: 0.35),
          ),
        ),
        Positioned(
          left: (size - ballSize) / 2,
          top: groundY - ballSize - bounce,
          child: _dot(color: color, size: ballSize),
        ),
      ],
    );
  }
}

class _ThreeRotatingDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _ThreeRotatingDotsLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final dotCount = config.dotCount.clamp(3, 6);
    final dotSize = size * 0.16;
    final orbitRadius = size * 0.27 * config.orbitRadiusFactor.clamp(0.5, 1.8);
    final center = size * 0.5;

    return Stack(
      children: List.generate(dotCount, (index) {
        final angle = progress * 2 * math.pi + (index * 2 * math.pi / dotCount);
        return Positioned(
          left: center + orbitRadius * math.cos(angle) - dotSize * 0.5,
          top: center + orbitRadius * math.sin(angle) - dotSize * 0.5,
          child: _dot(color: color, size: dotSize),
        );
      }),
    );
  }
}

class _FourRotatingDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final XLoaderConfig config;

  const _FourRotatingDotsLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final center = size * 0.5;
    final dotSize = size * 0.15;
    final radius = size * 0.26 * config.orbitRadiusFactor.clamp(0.5, 1.8);

    return Stack(
      children: List.generate(4, (index) {
        final angle = progress * 2 * math.pi + (index * math.pi / 2);
        final useSecondary = index.isOdd;
        return Positioned(
          left: center + radius * math.cos(angle) - dotSize * 0.5,
          top: center + radius * math.sin(angle) - dotSize * 0.5,
          child:
              _dot(color: useSecondary ? secondaryColor : color, size: dotSize),
        );
      }),
    );
  }
}

class _FallingDotLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _FallingDotLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final dotSize = size * 0.18;
    final topY = size * 0.1;
    final bottomY = size * 0.72;
    final t = 0.5 - 0.5 * math.cos(progress * 2 * math.pi);
    final y = topY + (bottomY - topY) * t;
    final stretch = 1.0 +
        0.35 *
            (1.0 - (2 * t - 1).abs()) *
            config.amplitudeFactor.clamp(0.4, 2.0);

    return Stack(
      children: [
        Positioned(
          left: size * 0.32,
          right: size * 0.32,
          top: size * 0.84,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18 + 0.24 * t),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          left: (size - dotSize) / 2,
          top: y,
          child: Transform.scale(
            scaleX: 1 / stretch,
            scaleY: stretch,
            child: _dot(color: color, size: dotSize),
          ),
        ),
      ],
    );
  }
}

class _TwoRotatingArcLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final double strokeWidth;

  const _TwoRotatingArcLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final rotation = progress * 2 * math.pi;
    return Transform.rotate(
      angle: rotation,
      child: CustomPaint(
        painter: _TwoArcPainter(
          primary: color,
          secondary: secondaryColor,
          strokeWidth: strokeWidth,
        ),
        size: Size.square(size),
      ),
    );
  }
}

class _DiscreteCircleLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final double strokeWidth;

  const _DiscreteCircleLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final t = progress;
    final scale1 = 0.35 + (0.65 * t);
    final scale2 = 0.35 + (0.65 * ((t + 0.33) % 1.0));
    final scale3 = 0.35 + (0.65 * ((t + 0.66) % 1.0));

    return Stack(
      alignment: Alignment.center,
      children: [
        _ring(size * scale1, color.withValues(alpha: 1.0 - t), strokeWidth),
        _ring(
          size * scale2,
          secondaryColor.withValues(alpha: 0.75),
          strokeWidth,
        ),
        _ring(size * scale3, color.withValues(alpha: 0.45), strokeWidth),
      ],
    );
  }

  Widget _ring(double ringSize, Color ringColor, double stroke) {
    return Container(
      width: ringSize,
      height: ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: stroke),
      ),
    );
  }
}

class _ThreeArchedCircleLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final double strokeWidth;

  const _ThreeArchedCircleLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: progress * 2 * math.pi,
      child: CustomPaint(
        size: Size.square(size),
        painter: _ThreeArcPainter(
          color: color,
          secondaryColor: secondaryColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _FlickrLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final XLoaderConfig config;

  const _FlickrLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final dotSize = size * 0.25;
    final span = size * 0.22 * config.orbitRadiusFactor.clamp(0.5, 1.8);
    final x = math.sin(progress * 2 * math.pi) * span;

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
            offset: Offset(-x, 0), child: _dot(color: color, size: dotSize)),
        Transform.translate(
            offset: Offset(x, 0),
            child: _dot(color: secondaryColor, size: dotSize)),
      ],
    );
  }
}

class _HexagonDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final XLoaderConfig config;

  const _HexagonDotsLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final center = size * 0.5;
    final dotSize = size * 0.13;
    final radius = size * 0.24 * config.orbitRadiusFactor.clamp(0.5, 1.8);

    return Stack(
      children: [
        ...List.generate(6, (index) {
          final angle = progress * 2 * math.pi + (index * math.pi / 3);
          final useSecondary = index.isOdd;
          return Positioned(
            left: center + radius * math.cos(angle) - dotSize * 0.5,
            top: center + radius * math.sin(angle) - dotSize * 0.5,
            child: _dot(
                color: useSecondary ? secondaryColor : color, size: dotSize),
          );
        }),
        Positioned(
          left: center - dotSize * 0.5,
          top: center - dotSize * 0.5,
          child: Transform.scale(
            scale: 0.65 + 0.35 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi)),
            child: _dot(color: color.withValues(alpha: 0.8), size: dotSize),
          ),
        ),
      ],
    );
  }
}

class _BeatLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _BeatLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 5);
    final dotSize = size * 0.18;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final phase = progress * 2 * math.pi + (index * 0.6);
        final scale = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(phase));
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dotSize * 0.18),
          child: Transform.scale(
              scale: scale, child: _dot(color: color, size: dotSize)),
        );
      }),
    );
  }
}

class _HorizontalRotatingDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _HorizontalRotatingDotsLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 7);
    final dotSize = size * 0.14;
    final spacing = dotSize * 0.45;

    return Transform.rotate(
      angle: progress * 2 * math.pi,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final opacity =
              (0.35 + (index + 1) / (count + 1) * 0.65).clamp(0.0, 1.0);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing * 0.5),
            child: _dot(color: color.withValues(alpha: opacity), size: dotSize),
          );
        }),
      ),
    );
  }
}

class _StretchedDotsLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _StretchedDotsLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 7);
    final base = size * 0.13;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final phase = (progress + index * 0.15) % 1.0;
        final stretch = 0.7 + 0.8 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi));
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: base * 0.18),
          child: Transform.scale(
            scaleX: stretch,
            scaleY: 1 / stretch.clamp(0.75, 1.45),
            child: _dot(color: color, size: base),
          ),
        );
      }),
    );
  }
}

class _HalfTriangleDotLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final XLoaderConfig config;

  const _HalfTriangleDotLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final center = size * 0.5;
    final dotSize = size * 0.16;
    final radius = size * 0.24 * config.orbitRadiusFactor.clamp(0.5, 1.8);
    final start = -math.pi / 2 + progress * math.pi;

    return Stack(
      children: List.generate(3, (index) {
        final angle = start + (index * math.pi / 2);
        final useSecondary = index == 1;
        return Positioned(
          left: center + radius * math.cos(angle) - dotSize * 0.5,
          top: center + radius * math.sin(angle) - dotSize * 0.5,
          child:
              _dot(color: useSecondary ? secondaryColor : color, size: dotSize),
        );
      }),
    );
  }
}

class _DotsTriangleLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double size;
  final XLoaderConfig config;

  const _DotsTriangleLoader({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final center = size * 0.5;
    final dotSize = size * 0.15;
    final radius = size * 0.26 * config.orbitRadiusFactor.clamp(0.5, 1.8);
    final rotation = progress * 2 * math.pi;

    return Stack(
      children: List.generate(3, (index) {
        final angle = rotation + (index * 2 * math.pi / 3) - math.pi / 2;
        final c = index == 1 ? secondaryColor : color;
        return Positioned(
          left: center + radius * math.cos(angle) - dotSize * 0.5,
          top: center + radius * math.sin(angle) - dotSize * 0.5,
          child: _dot(color: c, size: dotSize),
        );
      }),
    );
  }
}

class _NewtonCradleLoader extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final XLoaderConfig config;

  const _NewtonCradleLoader({
    required this.progress,
    required this.color,
    required this.size,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final count = config.dotCount.clamp(3, 7);
    final ballSize = size * 0.14;
    final spacing = ballSize * 0.35;
    final maxAngle = 0.65 * config.amplitudeFactor.clamp(0.4, 2.0);
    final phase = progress * 2 * math.pi;
    final leftAngle =
        math.sin(phase).isNegative ? 0.0 : math.sin(phase) * maxAngle;
    final rightAngle = math.sin(phase) > 0 ? 0.0 : math.sin(phase) * maxAngle;

    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (index) {
          final angle = index == 0
              ? leftAngle
              : index == count - 1
                  ? rightAngle
                  : 0.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Transform.rotate(
              angle: angle,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 1.5,
                    height: size * 0.23,
                    color: color.withValues(alpha: 0.35),
                  ),
                  _dot(color: color, size: ballSize),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ThreeArcPainter extends CustomPainter {
  final Color color;
  final Color secondaryColor;
  final double strokeWidth;

  const _ThreeArcPainter({
    required this.color,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final colors = <Color>[color, secondaryColor, color.withValues(alpha: 0.7)];

    for (var i = 0; i < 3; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = colors[i];
      canvas.drawArc(
        rect.deflate(strokeWidth + i * strokeWidth * 0.5),
        (i * 2 * math.pi / 3) + 0.25,
        math.pi * 0.72,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ThreeArcPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _TwoArcPainter extends CustomPainter {
  final Color primary;
  final Color secondary;
  final double strokeWidth;

  const _TwoArcPainter({
    required this.primary,
    required this.secondary,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paintPrimary = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = primary;

    final paintSecondary = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = secondary;

    canvas.drawArc(
      rect.deflate(strokeWidth),
      0.15,
      math.pi * 0.95,
      false,
      paintPrimary,
    );
    canvas.drawArc(
      rect.deflate(strokeWidth),
      math.pi + 0.25,
      math.pi * 0.95,
      false,
      paintSecondary,
    );
  }

  @override
  bool shouldRepaint(covariant _TwoArcPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

Widget _dot({required Color color, required double size}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}
