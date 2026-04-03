import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Direction of shimmer animation sweep.
enum XShimmerDirection {
  /// Left to right horizontal sweep.
  ltr,

  /// Right to left horizontal sweep.
  rtl,

  /// Top to bottom vertical sweep.
  ttb,

  /// Bottom to top vertical sweep.
  btt,
}

/// Built-in palette options for quick shimmer styling.
enum XShimmerPalette {
  /// Neutral grey palette.
  neutral,

  /// Dark palette useful for dark surfaces.
  dark,

  /// Warm palette with amber tones.
  warm,

  /// Cool palette with cyan tones.
  cool,

  /// Purple palette.
  purple,
}

/// Inherited shimmer theme data for composable shimmer widgets.
@immutable
class XShimmerThemeData {
  /// Base color for shimmer gradients.
  final Color baseColor;

  /// Highlight color for shimmer gradients.
  final Color highlightColor;

  /// Duration of one shimmer cycle.
  final Duration period;

  /// Default shimmer direction.
  final XShimmerDirection direction;

  /// Curve used to transform animation value.
  final Curve curve;

  /// Whether the shimmer should reverse direction each cycle.
  final bool reverse;

  /// Number of loops. `0` means infinite.
  final int loop;

  /// Whether shimmer is enabled.
  final bool enabled;

  /// Blend mode used for shader masking.
  final BlendMode blendMode;

  /// Gradient begin alignment.
  final AlignmentGeometry beginAlignment;

  /// Gradient end alignment.
  final AlignmentGeometry endAlignment;

  /// Optional gradient stops.
  final List<double>? stops;

  /// Delay before the first shimmer cycle begins.
  final Duration initialDelay;

  /// Delay between shimmer cycles.
  final Duration repeatDelay;

  const XShimmerThemeData({
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.period = const Duration(milliseconds: 1500),
    this.direction = XShimmerDirection.ltr,
    this.curve = Curves.linear,
    this.reverse = false,
    this.loop = 0,
    this.enabled = true,
    this.blendMode = BlendMode.srcIn,
    this.beginAlignment = Alignment.topLeft,
    this.endAlignment = Alignment.centerRight,
    this.stops,
    this.initialDelay = Duration.zero,
    this.repeatDelay = Duration.zero,
  });

  /// Returns a copy with specific overrides.
  XShimmerThemeData copyWith({
    Color? baseColor,
    Color? highlightColor,
    Duration? period,
    XShimmerDirection? direction,
    Curve? curve,
    bool? reverse,
    int? loop,
    bool? enabled,
    BlendMode? blendMode,
    AlignmentGeometry? beginAlignment,
    AlignmentGeometry? endAlignment,
    List<double>? stops,
    Duration? initialDelay,
    Duration? repeatDelay,
  }) {
    return XShimmerThemeData(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      period: period ?? this.period,
      direction: direction ?? this.direction,
      curve: curve ?? this.curve,
      reverse: reverse ?? this.reverse,
      loop: loop ?? this.loop,
      enabled: enabled ?? this.enabled,
      blendMode: blendMode ?? this.blendMode,
      beginAlignment: beginAlignment ?? this.beginAlignment,
      endAlignment: endAlignment ?? this.endAlignment,
      stops: stops ?? this.stops,
      initialDelay: initialDelay ?? this.initialDelay,
      repeatDelay: repeatDelay ?? this.repeatDelay,
    );
  }
}

/// Inherited widget to provide shimmer defaults to subtree widgets.
class XShimmerTheme extends InheritedWidget {
  /// The theme data used by shimmer widgets in the subtree.
  final XShimmerThemeData data;

  const XShimmerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns nearest shimmer theme or fallback defaults.
  static XShimmerThemeData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<XShimmerTheme>();
    return inherited?.data ?? const XShimmerThemeData();
  }

  /// Returns nearest shimmer theme if present.
  static XShimmerThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<XShimmerTheme>()?.data;
  }

  @override
  bool updateShouldNotify(XShimmerTheme oldWidget) => data != oldWidget.data;
}

/// A highly customizable shimmer loading effect widget.
@immutable
class XShimmer extends StatefulWidget {
  /// The widget to apply the shimmer effect to.
  final Widget child;

  /// Duration of one complete shimmer cycle.
  final Duration period;

  /// Direction of the shimmer sweep.
  final XShimmerDirection direction;

  /// The gradient to use for shimmer.
  final Gradient gradient;

  /// Number of animation loops (`0` means infinite).
  final int loop;

  /// Whether shimmer animation is currently enabled.
  final bool enabled;

  /// Optional curve applied to animation progress.
  final Curve curve;

  /// Whether the shimmer reverses after each completed sweep.
  final bool reverse;

  /// Blend mode used by shader mask.
  final BlendMode blendMode;

  /// Delay before the first shimmer cycle.
  final Duration initialDelay;

  /// Delay between shimmer cycles.
  final Duration repeatDelay;

  /// Whether to pause when [TickerMode] is disabled.
  final bool pauseWhenTickerDisabled;

  /// Called whenever a forward sweep is completed.
  final ValueChanged<int>? onCycleComplete;

  /// Creates a shimmer effect with a custom gradient.
  const XShimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = XShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
    this.curve = Curves.linear,
    this.reverse = false,
    this.blendMode = BlendMode.srcIn,
    this.initialDelay = Duration.zero,
    this.repeatDelay = Duration.zero,
    this.pauseWhenTickerDisabled = true,
    this.onCycleComplete,
  });

  /// Creates a shimmer effect using base and highlight colors.
  XShimmer.fromColors({
    super.key,
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = XShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
    this.curve = Curves.linear,
    this.reverse = false,
    this.blendMode = BlendMode.srcIn,
    this.initialDelay = Duration.zero,
    this.repeatDelay = Duration.zero,
    this.pauseWhenTickerDisabled = true,
    this.onCycleComplete,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.centerRight,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) : gradient = LinearGradient(
          begin: begin,
          end: end,
          tileMode: tileMode,
          transform: transform,
          colors: <Color>[
            baseColor,
            baseColor,
            highlightColor,
            baseColor,
            baseColor,
          ],
          stops: stops ?? const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
        );

  /// Returns built-in shimmer palette colors.
  static List<Color> palette(XShimmerPalette palette) {
    switch (palette) {
      case XShimmerPalette.dark:
        return const [
          Color(0xFF1F1F1F),
          Color(0xFF2D2D2D),
          Color(0xFF1F1F1F),
        ];
      case XShimmerPalette.warm:
        return const [
          Color(0xFFF2E0C9),
          Color(0xFFFFF2E3),
          Color(0xFFF2E0C9),
        ];
      case XShimmerPalette.cool:
        return const [
          Color(0xFFD7E7EE),
          Color(0xFFEFF7FA),
          Color(0xFFD7E7EE),
        ];
      case XShimmerPalette.purple:
        return const [
          Color(0xFFD9CDF4),
          Color(0xFFEDE6FF),
          Color(0xFFD9CDF4),
        ];
      case XShimmerPalette.neutral:
        return const [
          Color(0xFFE0E0E0),
          Color(0xFFF5F5F5),
          Color(0xFFE0E0E0),
        ];
    }
  }

  /// Shimmer circle avatar placeholder.
  static Widget avatar({
    double radius = 24.0,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return _buildStandardShimmer(
      Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      direction: direction,
    );
  }

  /// Shimmer text block placeholder.
  static Widget text({
    int lines = 2,
    double width = double.infinity,
    double height = 12.0,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    assert(lines > 0, 'lines must be greater than 0');
    return _buildStandardShimmer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          lines,
          (index) => Container(
            width: index == lines - 1 ? width * 0.6 : width,
            height: height,
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      direction: direction,
    );
  }

  /// Shimmer card placeholder.
  static Widget card({
    double width = 150,
    double height = 200,
    double borderRadius = 12,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return _buildStandardShimmer(
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      direction: direction,
    );
  }

  /// Pre-built shimmering list rows.
  static Widget list({
    int itemCount = 5,
    bool hasAvatar = true,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    assert(itemCount > 0, 'itemCount must be greater than 0');
    return ListView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasAvatar) ...[
              avatar(
                radius: 28,
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                direction: direction,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: text(
                lines: 3,
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                direction: direction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reference-like list tile shimmer.
  static Widget listTile({
    bool showAvatar = true,
    bool showTrailing = true,
    bool showBottomBox = false,
    int itemCount = 1,
    Color? baseColor,
    Color? highlightColor,
    double lineHeight = 12,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Column(
          children: [
            Row(
              children: [
                if (showAvatar) ...[
                  avatar(
                    radius: 20,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    period: period,
                    direction: direction,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      XShimmerLine(
                        width: double.infinity,
                        height: lineHeight,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        period: period,
                        direction: direction,
                      ),
                      const SizedBox(height: 8),
                      XShimmerLine(
                        width: 160,
                        height: lineHeight,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        period: period,
                        direction: direction,
                      ),
                    ],
                  ),
                ),
                if (showTrailing) ...[
                  const SizedBox(width: 12),
                  XShimmerRect(
                    width: 52,
                    height: 20,
                    radius: 8,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    period: period,
                    direction: direction,
                  ),
                ],
              ],
            ),
            if (showBottomBox) ...[
              const SizedBox(height: 12),
              XShimmerRect(
                width: double.infinity,
                height: 10,
                radius: 6,
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                direction: direction,
              ),
            ],
          ],
        );
      },
    );
  }

  /// Reference-like profile header shimmer.
  static Widget profileHeader({
    bool showAvatar = true,
    bool showBottomLines = false,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showAvatar) ...[
              XShimmerCircle(
                size: 56,
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                direction: direction,
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XShimmerLine(
                    width: 180,
                    height: 12,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    period: period,
                    direction: direction,
                  ),
                  const SizedBox(height: 8),
                  XShimmerLine(
                    width: 120,
                    height: 10,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    period: period,
                    direction: direction,
                  ),
                  const SizedBox(height: 8),
                  XShimmerLine(
                    width: 220,
                    height: 10,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    period: period,
                    direction: direction,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showBottomLines) ...[
          const SizedBox(height: 16),
          XShimmerLine(
            width: double.infinity,
            height: 10,
            baseColor: baseColor,
            highlightColor: highlightColor,
            period: period,
            direction: direction,
          ),
          const SizedBox(height: 8),
          XShimmerLine(
            width: 280,
            height: 10,
            baseColor: baseColor,
            highlightColor: highlightColor,
            period: period,
            direction: direction,
          ),
        ],
      ],
    );
  }

  /// Reference-like profile page shimmer.
  static Widget profilePage({
    bool showBottomBox = false,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return Column(
      children: [
        XShimmerCircle(
          size: 82,
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: period,
          direction: direction,
        ),
        const SizedBox(height: 14),
        XShimmerLine(
          width: 220,
          height: 12,
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: period,
          direction: direction,
        ),
        const SizedBox(height: 10),
        XShimmerLine(
          width: 140,
          height: 10,
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: period,
          direction: direction,
        ),
        if (showBottomBox) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              6,
              (index) => XShimmerRect(
                width: 88,
                height: 64,
                radius: 12,
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                direction: direction,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Reference-like video grid shimmer.
  static Widget videoGrid({
    int itemCount = 3,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        itemCount,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == itemCount - 1 ? 0 : 12),
            child: Column(
              children: [
                XShimmerRect(
                  width: double.infinity,
                  height: 110,
                  radius: 12,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: period,
                  direction: direction,
                ),
                const SizedBox(height: 8),
                XShimmerLine(
                  width: 60,
                  height: 8,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: period,
                  direction: direction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reference-like youtube feed shimmer.
  static Widget youtubeFeed({
    int itemCount = 3,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XShimmerRect(
              width: double.infinity,
              height: 140,
              radius: 14,
              baseColor: baseColor,
              highlightColor: highlightColor,
              period: period,
              direction: direction,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                XShimmerCircle(
                  size: 32,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: period,
                  direction: direction,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      XShimmerLine(
                        width: double.infinity,
                        height: 10,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        period: period,
                        direction: direction,
                      ),
                      const SizedBox(height: 6),
                      XShimmerLine(
                        width: 160,
                        height: 9,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        period: period,
                        direction: direction,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Reference-like app-store card shimmer.
  static Widget playStoreCards({
    int itemCount = 5,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(right: index == itemCount - 1 ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                XShimmerRect(
                  width: 110,
                  height: 110,
                  radius: 20,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: period,
                  direction: direction,
                ),
                const SizedBox(height: 10),
                XShimmerLine(
                  width: 100,
                  height: 9,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: period,
                  direction: direction,
                ),
                const SizedBox(height: 7),
                XShimmerLine(
                  width: 70,
                  height: 8,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: period,
                  direction: direction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Paragraph article shimmer.
  static Widget articleParagraph({
    int lines = 6,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return text(
      lines: lines,
      width: double.infinity,
      height: 10,
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      direction: direction,
    );
  }

  /// Chat-style shimmer rows.
  static Widget chatList({
    int itemCount = 5,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, index) {
        final isRight = index.isOdd;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment:
                isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              XShimmerRect(
                width: isRight ? 140 : 180,
                height: 34,
                radius: 16,
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                direction: direction,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Table row shimmer.
  static Widget tableRows({
    int rows = 4,
    int columns = 3,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return Column(
      children: List.generate(
        rows,
        (r) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: List.generate(
              columns,
              (c) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: c == columns - 1 ? 0 : 8),
                  child: XShimmerRect(
                    width: double.infinity,
                    height: 24,
                    radius: 6,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    period: period,
                    direction: direction,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Dashboard card shimmer.
  static Widget dashboardCards({
    int itemCount = 4,
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        itemCount,
        (index) => XShimmerRect(
          width: 160,
          height: 92,
          radius: 14,
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: period,
          direction: direction,
        ),
      ),
    );
  }

  static Widget _buildStandardShimmer(
    Widget child, {
    Color? baseColor,
    Color? highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    XShimmerDirection direction = XShimmerDirection.ltr,
  }) {
    return XShimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFFE0E0E0),
      highlightColor: highlightColor ?? const Color(0xFFF5F5F5),
      period: period,
      direction: direction,
      child: child,
    );
  }

  @override
  State<XShimmer> createState() => _XShimmerState();
}

class _XShimmerState extends State<XShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _delayTimer;
  int _completedForwardCycles = 0;
  bool _tickerEnabled = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener(_handleStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: deprecated_member_use
    // TickerMode.valuesOf was introduced in Flutter 3.35+; .of() is the
    // compatible fallback for Flutter >=3.10. Remove this ignore and switch
    // to TickerMode.valuesOf(context).enabled once the minimum Flutter
    // constraint is raised to >=3.35.0.
    final tickerEnabled =
        !widget.pauseWhenTickerDisabled || TickerMode.of(context);
    if (_tickerEnabled != tickerEnabled) {
      _tickerEnabled = tickerEnabled;
      _startOrStopAnimation();
    } else if (_controller.status == AnimationStatus.dismissed &&
        widget.enabled) {
      _startOrStopAnimation();
    }
  }

  @override
  void didUpdateWidget(XShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      _controller.duration = widget.period;
    }
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.reverse != widget.reverse ||
        oldWidget.loop != widget.loop ||
        oldWidget.initialDelay != widget.initialDelay ||
        oldWidget.repeatDelay != widget.repeatDelay ||
        oldWidget.pauseWhenTickerDisabled != widget.pauseWhenTickerDisabled) {
      _completedForwardCycles = 0;
      _startOrStopAnimation(reset: true);
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  void _startOrStopAnimation({bool reset = false}) {
    _delayTimer?.cancel();

    if (reset) {
      _controller.stop();
      _controller.value = 0;
    }

    if (!widget.enabled || !_tickerEnabled) {
      _controller.stop();
      return;
    }

    if (widget.initialDelay > Duration.zero && _controller.value == 0) {
      _delayTimer = Timer(widget.initialDelay, _startForward);
      return;
    }

    _startForward();
  }

  void _startForward() {
    if (!mounted || !widget.enabled || !_tickerEnabled) return;
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.reverse) {
      return;
    }
    _controller.forward(from: 0);
  }

  void _handleStatus(AnimationStatus status) {
    if (!mounted || !widget.enabled || !_tickerEnabled) return;

    if (status == AnimationStatus.completed) {
      _completedForwardCycles++;
      widget.onCycleComplete?.call(_completedForwardCycles);

      final reachedLoopLimit =
          widget.loop > 0 && _completedForwardCycles >= widget.loop;
      if (reachedLoopLimit) return;

      if (widget.reverse) {
        _runAfterDelay(() => _controller.reverse(from: 1));
      } else {
        _runAfterDelay(() => _controller.forward(from: 0));
      }
    } else if (status == AnimationStatus.dismissed && widget.reverse) {
      final reachedLoopLimit =
          widget.loop > 0 && _completedForwardCycles >= widget.loop;
      if (reachedLoopLimit) return;
      _runAfterDelay(() => _controller.forward(from: 0));
    }
  }

  void _runAfterDelay(VoidCallback callback) {
    _delayTimer?.cancel();
    if (widget.repeatDelay <= Duration.zero) {
      callback();
      return;
    }
    _delayTimer = Timer(widget.repeatDelay, () {
      if (!mounted || !widget.enabled || !_tickerEnabled) return;
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final progress =
            widget.curve.transform(_controller.value.clamp(0.0, 1.0));
        return _ShimmerFilterWidget(
          direction: widget.direction,
          gradient: widget.gradient,
          percent: progress,
          blendMode: widget.blendMode,
          child: child,
        );
      },
    );
  }
}

class _ShimmerFilterWidget extends SingleChildRenderObjectWidget {
  final double percent;
  final XShimmerDirection direction;
  final Gradient gradient;
  final BlendMode blendMode;

  const _ShimmerFilterWidget({
    super.child,
    required this.percent,
    required this.direction,
    required this.gradient,
    required this.blendMode,
  });

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient, blendMode);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter renderObject) {
    renderObject
      ..percent = percent
      ..gradient = gradient
      ..direction = direction
      ..blendMode = blendMode;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  XShimmerDirection _direction;
  Gradient _gradient;
  double _percent;
  BlendMode _blendMode;

  _ShimmerFilter(
      this._percent, this._direction, this._gradient, this._blendMode);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double value) {
    if (value == _percent) return;
    _percent = value;
    markNeedsPaint();
  }

  set gradient(Gradient value) {
    if (value == _gradient) return;
    _gradient = value;
    markNeedsPaint();
  }

  set direction(XShimmerDirection value) {
    if (value == _direction) return;
    _direction = value;
    markNeedsPaint();
  }

  set blendMode(BlendMode value) {
    if (value == _blendMode) return;
    _blendMode = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final currentChild = child;
    if (currentChild == null) {
      layer = null;
      return;
    }

    assert(needsCompositing);
    final width = currentChild.size.width;
    final height = currentChild.size.height;

    Rect rect;
    switch (_direction) {
      case XShimmerDirection.rtl:
        final dx = _offset(width, -width, _percent);
        rect = Rect.fromLTWH(dx - width, 0.0, 3 * width, height);
        break;
      case XShimmerDirection.ttb:
        final dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(0.0, dy - height, width, 3 * height);
        break;
      case XShimmerDirection.btt:
        final dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(0.0, dy - height, width, 3 * height);
        break;
      case XShimmerDirection.ltr:
        final dx = _offset(-width, width, _percent);
        rect = Rect.fromLTWH(dx - width, 0.0, 3 * width, height);
        break;
    }

    layer ??= ShaderMaskLayer();
    layer!
      ..shader = _gradient.createShader(rect)
      ..maskRect = offset & size
      ..blendMode = _blendMode;

    context.pushLayer(layer!, super.paint, offset);
  }

  double _offset(double start, double end, double t) =>
      start + (end - start) * t;
}

/// Primitive shimmering line.
class XShimmerLine extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;
  final XShimmerDirection? direction;
  final bool enabled;

  const XShimmerLine({
    super.key,
    this.width = double.infinity,
    this.height = 12,
    this.radius = 4,
    this.baseColor,
    this.highlightColor,
    this.period,
    this.direction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = XShimmerTheme.of(context);
    return XShimmer.fromColors(
      baseColor: baseColor ?? theme.baseColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      period: period ?? theme.period,
      direction: direction ?? theme.direction,
      enabled: enabled && theme.enabled,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Primitive shimmering rectangle.
class XShimmerRect extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;
  final XShimmerDirection? direction;
  final bool enabled;

  const XShimmerRect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
    this.baseColor,
    this.highlightColor,
    this.period,
    this.direction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = XShimmerTheme.of(context);
    return XShimmer.fromColors(
      baseColor: baseColor ?? theme.baseColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      period: period ?? theme.period,
      direction: direction ?? theme.direction,
      enabled: enabled && theme.enabled,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Primitive shimmering circle.
class XShimmerCircle extends StatelessWidget {
  final double size;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;
  final XShimmerDirection? direction;
  final bool enabled;

  const XShimmerCircle({
    super.key,
    this.size = 40,
    this.baseColor,
    this.highlightColor,
    this.period,
    this.direction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = XShimmerTheme.of(context);
    return XShimmer.fromColors(
      baseColor: baseColor ?? theme.baseColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      period: period ?? theme.period,
      direction: direction ?? theme.direction,
      enabled: enabled && theme.enabled,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Spacing helper for shimmer layouts.
class XShimmerGap extends StatelessWidget {
  final double width;
  final double height;

  const XShimmerGap({
    super.key,
    this.width = 0,
    this.height = 0,
  });

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}
