import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xtools/xtools.dart';

void main() => runApp(const XToolsDemoApp());

enum _NordAccentGroup { frost, aurora }

const List<Color> _frostAccents = [
  XNordPalette.nord7,
  XNordPalette.nord8,
  XNordPalette.nord9,
  XNordPalette.nord10,
];

const List<Color> _auroraAccents = [
  XNordPalette.nord11,
  XNordPalette.nord12,
  XNordPalette.nord13,
  XNordPalette.nord14,
  XNordPalette.nord15,
];

// ─── WCAG 2.1 contrast utilities ─────────────────────────────────────────
double _relativeLuminance(Color c) {
  double linearise(double v) =>
      v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) * ((v + 0.055) / 1.055);
  final r = linearise(c.r);
  final g = linearise(c.g);
  final b = linearise(c.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrastRatio(Color fg, Color bg) {
  final l1 = _relativeLuminance(fg);
  final l2 = _relativeLuminance(bg);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

String _wcagGrade(double ratio, {bool largeText = false}) {
  final aaThreshold = largeText ? 3.0 : 4.5;
  if (ratio >= 7.0) return 'AAA';
  if (ratio >= aaThreshold) return 'AA';
  return 'Fail';
}
// ──────────────────────────────────────────────────────────────────────────────

class XToolsDemoApp extends StatefulWidget {
  const XToolsDemoApp({super.key});

  @override
  State<XToolsDemoApp> createState() => _XToolsDemoAppState();
}

class _XToolsDemoAppState extends State<XToolsDemoApp> {
  bool _useNordTheme = false;
  ThemeMode _themeMode = ThemeMode.light;
  _NordAccentGroup _nordAccentGroup = _NordAccentGroup.frost;
  int _nordAccentIndex = 3;

  Color get _selectedNordAccent {
    final palette = _nordAccentGroup == _NordAccentGroup.frost
        ? _frostAccents
        : _auroraAccents;
    final safeIndex = _nordAccentIndex.clamp(0, palette.length - 1);
    return palette[safeIndex];
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = _useNordTheme
        ? XTheme.nordLight()
        : XTheme.light(seedColor: Colors.indigo);
    final baseDarkTheme = _useNordTheme
        ? XTheme.nordDark()
        : XTheme.dark(seedColor: Colors.indigo);

    final themed = _applyDemoTypography(
      _useNordTheme ? _applyNordAccent(baseTheme) : baseTheme,
    );
    final darkThemed = _applyDemoTypography(
      _useNordTheme ? _applyNordAccent(baseDarkTheme) : baseDarkTheme,
    );

    return MaterialApp(
      title: 'xTools Demo',
      theme: themed,
      darkTheme: darkThemed,
      themeMode: _themeMode,
      home: _DemoScreen(
        useNordTheme: _useNordTheme,
        themeMode: _themeMode,
        nordAccentGroup: _nordAccentGroup,
        nordAccentIndex: _nordAccentIndex,
        selectedNordAccent: _selectedNordAccent,
        onThemeFamilyChanged: (useNord) {
          setState(() => _useNordTheme = useNord);
        },
        onThemeModeChanged: (mode) {
          setState(() => _themeMode = mode);
        },
        onNordAccentGroupChanged: (group) {
          setState(() {
            _nordAccentGroup = group;
            final max =
                (group == _NordAccentGroup.frost ? _frostAccents : _auroraAccents)
                        .length -
                    1;
            _nordAccentIndex = _nordAccentIndex.clamp(0, max);
          });
        },
        onNordAccentIndexChanged: (index) {
          setState(() => _nordAccentIndex = index);
        },
      ),
    );
  }

  ThemeData _applyNordAccent(ThemeData base) {
    final scheme = base.colorScheme;
    final accent = _selectedNordAccent;
    final secondary = _nordAccentGroup == _NordAccentGroup.frost
        ? XNordPalette.nord9
        : XNordPalette.nord14;
    final tertiary = _nordAccentGroup == _NordAccentGroup.frost
        ? XNordPalette.nord8
        : XNordPalette.nord15;

    final nextScheme = scheme.copyWith(
      primary: accent,
      secondary: secondary,
      tertiary: tertiary,
      surfaceTint: accent,
      inversePrimary: accent,
    );

    return base.copyWith(
      colorScheme: nextScheme,
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: accent,
        foregroundColor: nextScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: nextScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent.withValues(alpha: 0.7)),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        foregroundColor: nextScheme.onSurface,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
    );
  }

  ThemeData _applyDemoTypography(ThemeData base) {
    final josefinText = GoogleFonts.josefinSansTextTheme(base.textTheme);
    final textTheme = josefinText.copyWith(
      displayLarge: GoogleFonts.eczar(textStyle: josefinText.displayLarge),
      displayMedium: GoogleFonts.eczar(textStyle: josefinText.displayMedium),
      displaySmall: GoogleFonts.eczar(textStyle: josefinText.displaySmall),
      headlineLarge: GoogleFonts.eczar(textStyle: josefinText.headlineLarge),
      headlineMedium: GoogleFonts.eczar(textStyle: josefinText.headlineMedium),
      headlineSmall: GoogleFonts.eczar(textStyle: josefinText.headlineSmall),
      titleLarge: GoogleFonts.eczar(textStyle: josefinText.titleLarge),
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.eczar(
          textStyle: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: base.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _DemoScreen extends StatefulWidget {
  final bool useNordTheme;
  final ThemeMode themeMode;
  final _NordAccentGroup nordAccentGroup;
  final int nordAccentIndex;
  final Color selectedNordAccent;
  final ValueChanged<bool> onThemeFamilyChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<_NordAccentGroup> onNordAccentGroupChanged;
  final ValueChanged<int> onNordAccentIndexChanged;

  const _DemoScreen({
    required this.useNordTheme,
    required this.themeMode,
    required this.nordAccentGroup,
    required this.nordAccentIndex,
    required this.selectedNordAccent,
    required this.onThemeFamilyChanged,
    required this.onThemeModeChanged,
    required this.onNordAccentGroupChanged,
    required this.onNordAccentIndexChanged,
  });

  @override
  State<_DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<_DemoScreen> {
  double _currentRating = 0;
  int _currentStep = 0;
  XShimmerPalette _shimmerPalette = XShimmerPalette.neutral;
  XShimmerDirection _shimmerDirection = XShimmerDirection.ltr;
  double _shimmerPeriodMs = 1500;
  bool _shimmerReverse = false;
  bool _shimmerEnabled = true;
  int _shimmerLoops = 0;
  int _shimmerCompletedCycles = 0;
  int _loaderColorPresetIndex = 0;
  double _loaderSize = 44;
  double _loaderDurationMs = 1100;
  int _loaderDotCount = 3;
  int _loaderBarCount = 3;
  double _loaderAmplitude = 1.0;
  double _loaderOrbit = 1.0;
  bool _loaderAnimate = true;
  int _loaderPresetIndex = 0;
  String _loaderCategory = 'All';
  final FireworksController _fireworksController = FireworksController();
  final ConfettiController _confettiController = ConfettiController();
  final List<List<Color>> _loaderColorPresets = const [
    [Colors.indigo, Colors.pink],
    [Colors.teal, Colors.orange],
    [Colors.deepPurple, Colors.cyan],
    [Colors.blueGrey, Colors.amber],
  ];
  final List<String> _loaderCategories = const [
    'All',
    'Dots',
    'Orbit',
    'Arcs',
    'Physics',
    'Geometry',
  ];
  final List<_LoaderPreset> _loaderPresets = const [
    _LoaderPreset(
      name: 'Balanced',
      colorPresetIndex: 0,
      size: 44,
      durationMs: 1100,
      dotCount: 5,
      barCount: 5,
      amplitude: 1.0,
      orbit: 1.0,
      animate: true,
      category: 'All',
    ),
    _LoaderPreset(
      name: 'Calm',
      colorPresetIndex: 1,
      size: 40,
      durationMs: 1700,
      dotCount: 4,
      barCount: 4,
      amplitude: 0.8,
      orbit: 0.9,
      animate: true,
      category: 'Dots',
    ),
    _LoaderPreset(
      name: 'Pulse',
      colorPresetIndex: 2,
      size: 50,
      durationMs: 850,
      dotCount: 6,
      barCount: 6,
      amplitude: 1.4,
      orbit: 1.1,
      animate: true,
      category: 'Arcs',
    ),
    _LoaderPreset(
      name: 'Orbit+',
      colorPresetIndex: 3,
      size: 52,
      durationMs: 900,
      dotCount: 6,
      barCount: 5,
      amplitude: 1.1,
      orbit: 1.6,
      animate: true,
      category: 'Orbit',
    ),
    _LoaderPreset(
      name: 'Static A11y',
      colorPresetIndex: 0,
      size: 44,
      durationMs: 1100,
      dotCount: 5,
      barCount: 5,
      amplitude: 1.0,
      orbit: 1.0,
      animate: false,
      category: 'All',
    ),
  ];

  List<Color> get _activeShimmerColors => XShimmer.palette(_shimmerPalette);
  List<Color> get _activeLoaderColors =>
      _loaderColorPresets[_loaderColorPresetIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.useNordTheme
              ? 'xTools Component Gallery - Nord'
              : 'xTools Component Gallery',
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
                    
          // ==================== THEME SECTION ====================
          _buildSectionHeader('Theme & Colors'),

          _buildWidgetCard(
            title: 'Theme Playground',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme family', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(value: false, label: Text('Default')),
                    ButtonSegment<bool>(value: true, label: Text('Nord')),
                  ],
                  selected: {widget.useNordTheme},
                  onSelectionChanged: (selection) {
                    widget.onThemeFamilyChanged(selection.first);
                  },
                ),
                const SizedBox(height: 14),
                Text('Theme mode', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Dark')),
                  ],
                  selected: {widget.themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light},
                  onSelectionChanged: (selection) {
                    widget.onThemeModeChanged(selection.first);
                  },
                ),
                if (widget.useNordTheme) ...[  // show accent + contrast badge
                  const SizedBox(height: 14),
                  Text('Nord Accent', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SegmentedButton<_NordAccentGroup>(
                    segments: const [
                      ButtonSegment<_NordAccentGroup>(value: _NordAccentGroup.frost, label: Text('Frost')),
                      ButtonSegment<_NordAccentGroup>(value: _NordAccentGroup.aurora, label: Text('Aurora')),
                    ],
                    selected: {widget.nordAccentGroup},
                    onSelectionChanged: (selection) {
                      widget.onNordAccentGroupChanged(selection.first);
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      (widget.nordAccentGroup == _NordAccentGroup.frost ? _frostAccents : _auroraAccents).length,
                      (index) {
                        final color = (widget.nordAccentGroup == _NordAccentGroup.frost
                            ? _frostAccents
                            : _auroraAccents)[index];
                        final selected = index == widget.nordAccentIndex;
                        return ChoiceChip(
                          label: Text('Accent ${index + 1}'),
                          selected: selected,
                          onSelected: (_) => widget.onNordAccentIndexChanged(index),
                          avatar: CircleAvatar(backgroundColor: color, radius: 8),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ContrastBadge(accent: widget.selectedNordAccent),
                ],
                const SizedBox(height: 12),
                Text(
                  widget.useNordTheme
                      ? 'Nord active with ${widget.nordAccentGroup.name} emphasis.'
                      : 'Default Material seed theme active (Indigo).',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          _buildWidgetCard(
            title: 'XColorPalette - Color Utilities',
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  widget.useNordTheme ? 'Nord swatches' : 'Seed Color: Colors.indigo',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: (widget.useNordTheme
                            ? [
                                XNordPalette.nord0,
                                XNordPalette.nord3,
                                XNordPalette.nord6,
                                XNordPalette.nord8,
                                XNordPalette.nord10,
                                XNordPalette.nord11,
                                XNordPalette.nord14,
                                XNordPalette.nord15,
                                widget.selectedNordAccent,
                              ]
                            : [
                                Colors.indigo,
                                Colors.indigo.withValues(alpha: 0.8),
                                Colors.indigo.withValues(alpha: 0.6),
                                Colors.indigo.withValues(alpha: 0.4),
                                Colors.indigo.withValues(alpha: 0.2),
                              ])
                        .map((color) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),

          // ==================== EFFECTS SECTION ====================
          _buildSectionHeader('Effects Widgets'),
          
          _buildWidgetCard(
            title: 'XShimmer - Interactive Controls',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: 210,
                      child: DropdownButtonFormField<XShimmerPalette>(
                        initialValue: _shimmerPalette,
                        decoration: const InputDecoration(labelText: 'Palette'),
                        items: XShimmerPalette.values
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _shimmerPalette = value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 210,
                      child: DropdownButtonFormField<XShimmerDirection>(
                        initialValue: _shimmerDirection,
                        decoration: const InputDecoration(labelText: 'Direction'),
                        items: XShimmerDirection.values
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _shimmerDirection = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Speed: ${_shimmerPeriodMs.round()} ms'),
                Slider(
                  min: 600,
                  max: 2800,
                  divisions: 11,
                  value: _shimmerPeriodMs,
                  label: '${_shimmerPeriodMs.round()} ms',
                  onChanged: (value) => setState(() => _shimmerPeriodMs = value),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Enabled'),
                        value: _shimmerEnabled,
                        onChanged: (value) => setState(() => _shimmerEnabled = value),
                      ),
                    ),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Reverse'),
                        value: _shimmerReverse,
                        onChanged: (value) => setState(() => _shimmerReverse = value),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Loops: '),
                    SegmentedButton<int>(
                      selected: <int>{_shimmerLoops},
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Infinite')),
                        ButtonSegment(value: 1, label: Text('1')),
                        ButtonSegment(value: 3, label: Text('3')),
                      ],
                      onSelectionChanged: (selection) {
                        setState(() {
                          _shimmerLoops = selection.first;
                          _shimmerCompletedCycles = 0;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Completed cycles: $_shimmerCompletedCycles'),
              ],
            ),
          ),

          _buildWidgetCard(
            title: 'XShimmer - Custom Gradient + Motion Controls',
            child: XShimmerTheme(
              data: XShimmerThemeData(
                baseColor: _activeShimmerColors[0],
                highlightColor: _activeShimmerColors[1],
                period: Duration(milliseconds: _shimmerPeriodMs.round()),
                direction: _shimmerDirection,
                reverse: _shimmerReverse,
                loop: _shimmerLoops,
                enabled: _shimmerEnabled,
              ),
              child: XShimmer.fromColors(
                baseColor: _activeShimmerColors[0],
                highlightColor: _activeShimmerColors[1],
                direction: _shimmerDirection,
                period: Duration(milliseconds: _shimmerPeriodMs.round()),
                reverse: _shimmerReverse,
                loop: _shimmerLoops,
                enabled: _shimmerEnabled,
                curve: Curves.easeInOut,
                blendMode: BlendMode.srcIn,
                onCycleComplete: (count) {
                  if (mounted) {
                    setState(() => _shimmerCompletedCycles = count);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    XShimmerCircle(size: 56),
                    SizedBox(height: 12),
                    XShimmerLine(width: 220, height: 12),
                    SizedBox(height: 8),
                    XShimmerLine(width: 140, height: 10),
                    SizedBox(height: 8),
                    XShimmerRect(width: double.infinity, height: 56, radius: 12),
                  ],
                ),
              ),
            ),
          ),

          _buildWidgetCard(
            title: 'XShimmer - Core Helpers',
            child: Column(
              children: [
                XShimmer.list(
                  itemCount: 2,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    XShimmer.avatar(
                      radius: 24,
                      baseColor: _activeShimmerColors[0],
                      highlightColor: _activeShimmerColors[1],
                      direction: _shimmerDirection,
                      period: Duration(milliseconds: _shimmerPeriodMs.round()),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: XShimmer.card(
                        width: double.infinity,
                        height: 72,
                        baseColor: _activeShimmerColors[0],
                        highlightColor: _activeShimmerColors[1],
                        direction: _shimmerDirection,
                        period: Duration(milliseconds: _shimmerPeriodMs.round()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _buildWidgetCard(
            title: 'XShimmer - ListTile/Profile Variants',
            child: Column(
              children: [
                XShimmer.listTile(
                  itemCount: 2,
                  showTrailing: true,
                  showBottomBox: true,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 14),
                XShimmer.profileHeader(
                  showBottomLines: true,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 14),
                XShimmer.profilePage(
                  showBottomBox: true,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
              ],
            ),
          ),

          _buildWidgetCard(
            title: 'XShimmer - Media + Store Layouts',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                XShimmer.videoGrid(
                  itemCount: 3,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 16),
                XShimmer.youtubeFeed(
                  itemCount: 2,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 16),
                XShimmer.playStoreCards(
                  itemCount: 4,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
              ],
            ),
          ),

          _buildWidgetCard(
            title: 'XShimmer - Content Utilities',
            child: Column(
              children: [
                XShimmer.articleParagraph(
                  lines: 5,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 14),
                XShimmer.chatList(
                  itemCount: 4,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 14),
                XShimmer.tableRows(
                  rows: 3,
                  columns: 4,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
                const SizedBox(height: 14),
                XShimmer.dashboardCards(
                  itemCount: 4,
                  baseColor: _activeShimmerColors[0],
                  highlightColor: _activeShimmerColors[1],
                  direction: _shimmerDirection,
                  period: Duration(milliseconds: _shimmerPeriodMs.round()),
                ),
              ],
            ),
          ),
          
          // XAnimatedCounter
          _buildWidgetCard(
            title: 'XAnimatedCounter - Roll-up Numbers',
            child: Center(
              child: XAnimatedCounter(
                startValue: 0,
                endValue: 99999,
                duration: const Duration(seconds: 3),
                prefix: '\$',
                suffix: ' USD',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          // XFireworks
          _buildWidgetCard(
            title: 'XFireworks - Particle Explosion',
            child: GestureDetector(
              onTap: () => _fireworksController.explode(Offset(150, 100)),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    XFireworks(
                      controller: _fireworksController,
                      particleCount: 50,
                      colors: [Colors.red, Colors.orange, Colors.yellow],
                    ),
                    const Text('Tap to explode!', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          
          // XConfetti
          _buildWidgetCard(
            title: 'XConfetti - Celebration Effect',
            child: GestureDetector(
              onTap: () => _confettiController.burst(offset: Offset(150, 100)),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    XConfetti(
                      controller: _confettiController,
                      particleCount: 30,
                    ),
                    const Text('Tap to celebrate!', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          
          // ==================== LOADERS SECTION ====================
          _buildSectionHeader('Loader Widgets'),
          
          _buildWidgetCard(
            title: 'XLoader - All Styles',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phase 3.1 quick presets', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_loaderPresets.length, (index) {
                    final preset = _loaderPresets[index];
                    return ChoiceChip(
                      label: Text(preset.name),
                      selected: _loaderPresetIndex == index,
                      onSelected: (_) => _applyLoaderPreset(index),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Text('Phase 3 interactive controls', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<String>(
                    segments: _loaderCategories
                        .map((category) => ButtonSegment<String>(value: category, label: Text(category)))
                        .toList(),
                    selected: {_loaderCategory},
                    onSelectionChanged: (selection) {
                      setState(() => _loaderCategory = selection.first);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<int>(
                        initialValue: _loaderColorPresetIndex,
                        decoration: const InputDecoration(labelText: 'Color preset'),
                        items: List.generate(_loaderColorPresets.length, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(_loaderPaletteName(index)),
                          );
                        }),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _loaderColorPresetIndex = value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Animate'),
                        value: _loaderAnimate,
                        onChanged: (value) => setState(() => _loaderAnimate = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Size: ${_loaderSize.round()}'),
                Slider(
                  min: 30,
                  max: 72,
                  divisions: 14,
                  value: _loaderSize,
                  onChanged: (value) => setState(() => _loaderSize = value),
                ),
                Text('Speed: ${_loaderDurationMs.round()} ms'),
                Slider(
                  min: 500,
                  max: 2200,
                  divisions: 17,
                  value: _loaderDurationMs,
                  onChanged: (value) => setState(() => _loaderDurationMs = value),
                ),
                Text('Dot count: $_loaderDotCount | Bar count: $_loaderBarCount'),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 3,
                        max: 8,
                        divisions: 5,
                        value: _loaderDotCount.toDouble(),
                        onChanged: (value) => setState(() => _loaderDotCount = value.round()),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        min: 3,
                        max: 8,
                        divisions: 5,
                        value: _loaderBarCount.toDouble(),
                        onChanged: (value) => setState(() => _loaderBarCount = value.round()),
                      ),
                    ),
                  ],
                ),
                Text('Amplitude: ${_loaderAmplitude.toStringAsFixed(1)} | Orbit: ${_loaderOrbit.toStringAsFixed(1)}'),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        value: _loaderAmplitude,
                        onChanged: (value) => setState(() => _loaderAmplitude = value),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        value: _loaderOrbit,
                        onChanged: (value) => setState(() => _loaderOrbit = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _stylesForCategory().map((style) {
                    return XLoaderTheme(
                      data: XLoaderThemeData(
                        color: _activeLoaderColors[0],
                        secondaryColor: _activeLoaderColors[1],
                        size: _loaderSize,
                        duration: Duration(milliseconds: _loaderDurationMs.round()),
                        enableAnimations: _loaderAnimate,
                        config: XLoaderConfig(
                          dotCount: _loaderDotCount,
                          barCount: _loaderBarCount,
                          amplitudeFactor: _loaderAmplitude,
                          orbitRadiusFactor: _loaderOrbit,
                        ),
                      ),
                      child: Container(
                        width: 128,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _activeLoaderColors[0].withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: _loaderSize,
                              height: _loaderSize,
                              child: XLoader(
                                style: style,
                                semanticLabel: '${_formatLoaderStyleName(style)} loader',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatLoaderStyleName(style),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Convenience constructors', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _LoaderDemoChip(label: 'progressiveDots', child: XLoader.progressiveDots(color: Colors.indigo, size: 36)),
                    _LoaderDemoChip(label: 'twoRotatingArc', child: XLoader.twoRotatingArc(color: Colors.indigo, secondaryColor: Colors.pink, size: 36)),
                    _LoaderDemoChip(label: 'newtonCradle', child: XLoader.newtonCradle(color: Colors.indigo, size: 36)),
                  ],
                ),
              ],
            ),
          ),

          _buildWidgetCard(
            title: 'XLoader - Theme, Config & Accessibility',
            child: XLoaderTheme(
              data: const XLoaderThemeData(
                color: Colors.indigo,
                secondaryColor: Colors.pink,
                size: 44,
                duration: Duration(milliseconds: 1100),
                config: XLoaderConfig(
                  dotCount: 5,
                  barCount: 5,
                  amplitudeFactor: 1.2,
                  orbitRadiusFactor: 1.1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _LoaderDemoChip(
                        label: 'Theme default',
                        child: XLoader(style: LoaderStyle.progressiveDots),
                      ),
                      _LoaderDemoChip(
                        label: 'Config override',
                        child: XLoader(
                          style: LoaderStyle.waveDots,
                          config: XLoaderConfig(dotCount: 4, amplitudeFactor: 1.5),
                        ),
                      ),
                      _LoaderDemoChip(
                        label: 'No animation',
                        child: XLoader(
                          style: LoaderStyle.twoRotatingArc,
                          enableAnimations: false,
                          semanticLabel: 'Static loading indicator',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tip: use semanticLabel for screen readers and enableAnimations for reduced-motion contexts.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          
          // XSkeletonLoader
          _buildWidgetCard(
            title: 'XSkeletonLoader - Placeholder Layouts',
            child: Column(
              children: [
                Text('Card Skeleton:', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                XSkeletonLoader(
                  shape: SkeletonShape.card,
                  withShimmer: true,
                ),
                const SizedBox(height: 16),
                Text('Profile Skeleton:', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                XSkeletonLoader(
                  shape: SkeletonShape.profile,
                  withShimmer: true,
                ),
              ],
            ),
          ),
          
          // ==================== BUTTONS SECTION ====================
          _buildSectionHeader('Button Widgets'),
          
          _buildWidgetCard(
            title: 'XButton - All Variants',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                XButton(
                  label: 'Elevated',
                  variant: XButtonVariant.elevated,
                  onPressed: () => XToast.show(context, message: 'Elevated pressed', type: XToastType.info),
                ),
                XButton(
                  label: 'Outlined',
                  variant: XButtonVariant.outlined,
                  onPressed: () => XToast.show(context, message: 'Outlined pressed', type: XToastType.info),
                ),
                XButton(
                  label: 'Text',
                  variant: XButtonVariant.text,
                  onPressed: () => XToast.show(context, message: 'Text pressed', type: XToastType.info),
                ),
                XButton(
                  label: 'Gradient',
                  variant: XButtonVariant.gradient,
                  onPressed: () => XToast.show(context, message: 'Gradient pressed', type: XToastType.info),
                ),
              ],
            ),
          ),
          
          _buildWidgetCard(
            title: 'XLoadingButton - Async State',
            child: Center(
              child: XLoadingButton(
                label: 'Load Data',
                onPressed: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  XToast.success(context, 'Data loaded successfully!');
                },
              ),
            ),
          ),
          
          _buildWidgetCard(
            title: 'XCopyButton - Clipboard',
            child: Center(
              child: XCopyButton(
                text: 'Tap to copy: Hello xTools!',
                feedbackMessage: 'Copied to clipboard!',
              ),
            ),
          ),
          
          // ==================== DIALOGS SECTION ====================
          _buildSectionHeader('Dialog Widgets'),
          
          _buildWidgetCard(
            title: 'XToast - All Types',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => XToast.success(context, 'Action successful!'),
                  child: const Text('Success'),
                ),
                ElevatedButton(
                  onPressed: () => XToast.error(context, 'An error occurred!'),
                  child: const Text('Error'),
                ),
                ElevatedButton(
                  onPressed: () => XToast.warning(context, 'Be careful!'),
                  child: const Text('Warning'),
                ),
                ElevatedButton(
                  onPressed: () => XToast.info(context, 'Information!'),
                  child: const Text('Info'),
                ),
              ],
            ),
          ),
          
          _buildWidgetCard(
            title: 'XDialog - Alert & Confirm',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => XDialog.alert(
                    context: context,
                    title: 'Alert',
                    message: 'This is an alert dialog',
                  ),
                  child: const Text('Alert'),
                ),
                ElevatedButton(
                  onPressed: () => XDialog.confirm(
                    context: context,
                    title: 'Confirm',
                    message: 'Do you want to continue?',
                    onConfirm: () => XToast.success(context, 'Confirmed!'),
                  ),
                  child: const Text('Confirm'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final value = await XDialog.input(
                      context: context,
                      title: 'Input',
                      message: 'Enter your name',
                    );
                    if (!mounted) return;
                    XToast.show(
                      context, // ignore: use_build_context_synchronously
                      message: 'You entered: $value',
                      type: XToastType.info,
                    );
                  },
                  child: const Text('Input'),
                ),
              ],
            ),
          ),
          
          _buildWidgetCard(
            title: 'XBottomSheet - List & Actions',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => XBottomSheet.list(
                    context: context,
                    title: 'Choose Option',
                    options: ['Option 1', 'Option 2', 'Option 3'],
                  ),
                  child: const Text('List Sheet'),
                ),
                ElevatedButton(
                  onPressed: () => XBottomSheet.modal(
                    context: context,
                    title: 'Actions',
                    builder: (context) => ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(['Edit', 'Share', 'Delete'][index]),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  child: const Text('Actions Sheet'),
                ),
              ],
            ),
          ),
          
          // ==================== FORMS SECTION ====================
          _buildSectionHeader('Form Widgets'),
          
          _buildWidgetCard(
            title: 'XPasswordField - With Strength Meter',
            child: XPasswordField(
              label: 'Password',
            ),
          ),
          
          _buildWidgetCard(
            title: 'XRatingBar - Star Rating',
            child: Center(
              child: XRatingBar(
                rating: _currentRating,
                maxRating: 5,
                onRatingChanged: (rating) {
                  setState(() => _currentRating = rating);
                  XToast.show(context, message: 'Rating: $rating', type: XToastType.info);
                },
                filledColor: Colors.amber,
                unfilledColor: Colors.grey[300]!,
              ),
            ),
          ),
          
          _buildWidgetCard(
            title: 'XFormValidator - Email Validation',
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: XFormValidator.email(),
            ),
          ),
          
          // ==================== WIDGETS SECTION ====================
          _buildSectionHeader('UI Widgets'),
          
          _buildWidgetCard(
            title: 'XAvatar - With Status Badge',
            child: Center(
              child: XAvatar(
                name: 'John Doe',
                radius: 40,
                status: AvatarStatus.online,
              ),
            ),
          ),
          
          _buildWidgetCard(
            title: 'XEmptyState - No Data Placeholder',
            child: Center(
              child: XEmptyState(
                icon: Icons.inbox_outlined,
                title: 'No Items Found',
                subtitle: 'Start by creating your first item',
                actionLabel: 'Create Item',
                onAction: () => XToast.info(context, 'Create button tapped'),
              ),
            ),
          ),
          
          _buildWidgetCard(
            title: 'XStepperWidget - Progress Steps',
            child: Center(
              child: XStepperWidget(
                steps: const ['Info', 'Address', 'Payment', 'Review'],
                currentStep: _currentStep,
                onStepTapped: (index) => setState(() => _currentStep = index),
              ),
            ),
          ),
          
          _buildWidgetCard(
            title: 'XConnectivityBanner - Status Indicator',
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const XConnectivityBanner(),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLoaderStyleName(LoaderStyle style) {
    final raw = style.name;
    final withSpaces = raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return withSpaces;
  }

  String _loaderPaletteName(int index) {
    switch (index) {
      case 0:
        return 'Indigo / Pink';
      case 1:
        return 'Teal / Orange';
      case 2:
        return 'Purple / Cyan';
      case 3:
        return 'BlueGrey / Amber';
      default:
        return 'Custom';
    }
  }

  void _applyLoaderPreset(int index) {
    final preset = _loaderPresets[index];
    setState(() {
      _loaderPresetIndex = index;
      _loaderColorPresetIndex = preset.colorPresetIndex;
      _loaderSize = preset.size;
      _loaderDurationMs = preset.durationMs;
      _loaderDotCount = preset.dotCount;
      _loaderBarCount = preset.barCount;
      _loaderAmplitude = preset.amplitude;
      _loaderOrbit = preset.orbit;
      _loaderAnimate = preset.animate;
      _loaderCategory = preset.category;
    });
  }

  List<LoaderStyle> _stylesForCategory() {
    switch (_loaderCategory) {
      case 'Dots':
        return const [
          LoaderStyle.dots,
          LoaderStyle.progressiveDots,
          LoaderStyle.staggeredDotsWave,
          LoaderStyle.waveDots,
          LoaderStyle.inkDrop,
          LoaderStyle.twistingDots,
          LoaderStyle.beat,
          LoaderStyle.stretchedDots,
        ];
      case 'Orbit':
        return const [
          LoaderStyle.threeRotatingDots,
          LoaderStyle.fourRotatingDots,
          LoaderStyle.horizontalRotatingDots,
          LoaderStyle.hexagonDots,
          LoaderStyle.dotsTriangle,
          LoaderStyle.halfTriangleDot,
          LoaderStyle.squares,
        ];
      case 'Arcs':
        return const [
          LoaderStyle.circular,
          LoaderStyle.twoRotatingArc,
          LoaderStyle.discreteCircle,
          LoaderStyle.discreteCircular,
          LoaderStyle.threeArchedCircle,
          LoaderStyle.pulse,
        ];
      case 'Physics':
        return const [
          LoaderStyle.bouncingBall,
          LoaderStyle.fallingDot,
          LoaderStyle.newtonCradle,
          LoaderStyle.bar,
          LoaderStyle.wave,
        ];
      case 'Geometry':
        return const [
          LoaderStyle.flickr,
          LoaderStyle.hexagonDots,
          LoaderStyle.halfTriangleDot,
          LoaderStyle.dotsTriangle,
          LoaderStyle.squares,
        ];
      default:
        return LoaderStyle.values;
    }
  }

  Widget _buildWidgetCard({required String title, required Widget child}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Contrast Badge ──────────────────────────────────────────────────────────
class _ContrastBadge extends StatelessWidget {
  final Color accent;
  const _ContrastBadge({required this.accent});

  @override
  Widget build(BuildContext context) {
    final onLight = _contrastRatio(accent, XNordPalette.nord6);
    final onDark = _contrastRatio(accent, XNordPalette.nord0);
    final whiteOn = _contrastRatio(Colors.white, accent);
    final darkOn = _contrastRatio(XNordPalette.nord0, accent);

    final hex =
        '#${accent.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              hex,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(6),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2.2),
            1: FlexColumnWidth(1.0),
            2: FlexColumnWidth(0.7),
            3: FlexColumnWidth(0.7),
          },
          children: [
            _tableHeader(context),
            _tableRow(context, 'White on accent', whiteOn, false),
            _tableRow(context, 'Dark (nord0) on accent', darkOn, false),
            _tableRow(context, 'Accent on light (nord6)', onLight, false),
            _tableRow(context, 'Accent on dark (nord0)', onDark, false),
          ],
        ),
      ],
    );
  }

  TableRow _tableHeader(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(fontWeight: FontWeight.w700);
    return TableRow(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      children: [
        _cell('Pair', style),
        _cell('Ratio', style),
        _cell('AA', style),
        _cell('AAA', style),
      ],
    );
  }

  TableRow _tableRow(
      BuildContext context, String label, double ratio, bool large) {
    final pass = Theme.of(context).colorScheme.tertiary;
    final fail = Theme.of(context).colorScheme.error;
    final bodyStyle = Theme.of(context).textTheme.labelSmall;

    Widget gradeCell(String grade) {
      final ok = grade != 'Fail';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Center(
          child: Text(
            grade,
            style: bodyStyle?.copyWith(
              color: ok ? pass : fail,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return TableRow(
      children: [
        _cell(label, bodyStyle),
        _cell('${ratio.toStringAsFixed(2)}:1', bodyStyle),
        gradeCell(_wcagGrade(ratio, largeText: large)),
        gradeCell(ratio >= 7.0 ? 'AAA' : 'Fail'),
      ],
    );
  }

  Widget _cell(String text, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Text(text, style: style),
    );
  }
}
// ──────────────────────────────────────────────────────────────────────────────

class _LoaderDemoChip extends StatelessWidget {
  final String label;
  final Widget child;

  const _LoaderDemoChip({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95,
      child: Column(
        children: [
          child,
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _LoaderPreset {
  final String name;
  final int colorPresetIndex;
  final double size;
  final double durationMs;
  final int dotCount;
  final int barCount;
  final double amplitude;
  final double orbit;
  final bool animate;
  final String category;

  const _LoaderPreset({
    required this.name,
    required this.colorPresetIndex,
    required this.size,
    required this.durationMs,
    required this.dotCount,
    required this.barCount,
    required this.amplitude,
    required this.orbit,
    required this.animate,
    required this.category,
  });
}