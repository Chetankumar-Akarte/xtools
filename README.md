# XTools

[![pub package](https://img.shields.io/pub/v/xtools.svg)](https://pub.dev/packages/xtools)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)

A comprehensive collection of **production-ready Flutter utility widgets and helpers** for rapid app development. XTools provides highly customizable, well-documented components that follow Material Design 3 principles.

**[🚀 Try the Live Interactive Demo Here!](https://Chetankumar-Akarte.github.io/xtools/)**

A curated collection of highly customizable Flutter utility widgets...
## At a Glance

- 25+ reusable widgets across effects, loaders, forms, dialogs, and theme utilities
- Flutter/Dart null-safe package with Material 3 friendly defaults
- Rich shimmer system with low-level primitives and ready-made layouts
- Complete runnable gallery in [example/lib/main.dart](example/lib/main.dart)

## Quick Start

```dart
import 'package:xtools/xtools.dart';

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: XTheme.light(seedColor: Colors.indigo),
      home: Scaffold(
        body: Center(
          child: XButton(
            label: 'Open',
            onPressed: () => XToast.success(context, 'Ready to ship'),
          ),
        ),
      ),
    );
  }
}
```

## Contents

- Features
- Installation
- Usage
- Shimmer Showcase
- Examples
- API Reference
- Requirements
- Contributing
- License

## Features

### ✨ Effects & Animations
- **XShimmer** - Customizable shimmer loading effects with multiple directions
- **XFireworks** - Canvas-based fireworks animation widget
- **XConfetti** - Confetti burst animations with controller support
- **XAnimatedCounter** - Smooth rolling number animations

### 📊 Loaders
- **XLoader** - 14+ animated loader styles (circular, dots, pulse, wave, bar, squares, progressive dots, wave dots, newton cradle, and more)
- **XSkeletonLoader** - Layout-matching skeleton placeholders (card, list, profile, grid, paragraph)
- **XLoaderTheme / XLoaderConfig** - Shared loader defaults and per-style tuning

### 🎯 Buttons
- **XButton** - Customizable button with elevated, outlined, text, and gradient variants
- **XLoadingButton** - Button with built-in async loading and success states
- **XCopyButton** - One-tap clipboard copy with visual feedback

### 🗣️ Dialogs & Overlays
- **XToast** - Beautiful toast notifications (success, error, warning, info)
- **XDialog** - Alert, confirm, and input dialogs
- **XBottomSheet** - Modal bottom sheets with list, custom, and action variants

### 📋 Form Utilities
- **XFormValidator** - Email, phone, password, OTP, URL validators and more
- **XRatingBar** - Interactive star/icon rating widget with half-star support
- **XPasswordField** - Password input with strength indicator and visibility toggle

### 🎨 UI Widgets
- **XEmptyState** - Empty state placeholder with icon, title, and action
- **XAvatar** - Profile picture widget with status badge and fallback initials
- **XStepperWidget** - Multi-step progress indicator (horizontal/vertical)
- **XConnectivityBanner** - Automatic offline/online status banner

### 🎭 Theme Utilities
- **XTheme** - Material Design 3 theme factory (light/dark)
- **XTheme.nordLight / XTheme.nordDark** - Built-in Nord palette themes
- **XNordPalette** - Official 16 Nord colors (nord0..nord15)
- **XColorPalette** - Seed-color-based palette generator with utilities

## Installation

Add `xtools` to your `pubspec.yaml`:

```yaml
dependencies:
  xtools: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Import

```dart
import 'package:xtools/xtools.dart';
```

### Quick Examples

#### Shimmer Loading Effect

```dart
// Quick helper
XShimmer.list(itemCount: 5);

// Advanced shimmer with motion controls
XShimmer.fromColors(
  baseColor: Colors.grey.shade300,
  highlightColor: Colors.grey.shade100,
  direction: XShimmerDirection.ltr,
  period: const Duration(milliseconds: 1300),
  reverse: true,
  loop: 3,
  curve: Curves.easeInOut,
  child: Container(width: 100, height: 100),
);

// Composable primitives
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    XShimmerCircle(size: 48),
    SizedBox(height: 10),
    XShimmerLine(width: 180, height: 12),
    SizedBox(height: 8),
    XShimmerRect(width: double.infinity, height: 64, radius: 10),
  ],
);
```

### Shimmer Showcase

The shimmer module supports both low-level composition and high-level preset layouts.

#### 1. Themed Shimmer Defaults

```dart
XShimmerTheme(
  data: const XShimmerThemeData(
    baseColor: Color(0xFFE8E8E8),
    highlightColor: Color(0xFFF8F8F8),
    period: Duration(milliseconds: 1400),
    direction: XShimmerDirection.ltr,
  ),
  child: const XShimmerLine(width: 220, height: 12),
)
```

#### 2. Reference-Style Presets

```dart
// List tile style
XShimmer.listTile(itemCount: 3, showAvatar: true, showTrailing: true);

// Profile and profile-page style
XShimmer.profileHeader(showBottomLines: true);
XShimmer.profilePage(showBottomBox: true);

// Media/store style
XShimmer.youtubeFeed(itemCount: 2);
XShimmer.videoGrid(itemCount: 3);
XShimmer.playStoreCards(itemCount: 5);
```

#### Preset Matrix

| Preset | Best for | Key options |
|---|---|---|
| `XShimmer.listTile` | list rows and settings pages | `showAvatar`, `showTrailing`, `showBottomBox`, `itemCount` |
| `XShimmer.profileHeader` | profile summary skeletons | `showAvatar`, `showBottomLines` |
| `XShimmer.profilePage` | full profile page loading | `showBottomBox` |
| `XShimmer.videoGrid` | short-form media previews | `itemCount` |
| `XShimmer.youtubeFeed` | feed/video cards | `itemCount` |
| `XShimmer.playStoreCards` | store style horizontal cards | `itemCount` |
| `XShimmer.articleParagraph` | article/text blocks | `lines` |
| `XShimmer.chatList` | chat bubbles | `itemCount` |
| `XShimmer.tableRows` | admin/table placeholders | `rows`, `columns` |
| `XShimmer.dashboardCards` | KPI cards and dashboards | `itemCount` |

#### 3. Content Utility Presets

```dart
XShimmer.articleParagraph(lines: 6);
XShimmer.chatList(itemCount: 4);
XShimmer.tableRows(rows: 4, columns: 3);
XShimmer.dashboardCards(itemCount: 4);
```

#### 4. Screenshot-Ready Example Checklist

- Interactive controls card (palette, direction, speed, loops, reverse)
- Core helpers card (list, avatar, card)
- List/profile variants card
- Media/store variants card
- Content utilities card

All of these are already demonstrated in the example app under the effects section.

#### Screenshot Grid Template

Use the section below directly on pub.dev once screenshots are exported from the example app.

| Interactive Controls | Core Helpers |
|---|---|
| ![Interactive Controls](assets/screenshots/shimmer_controls.png) | ![Core Helpers](assets/screenshots/shimmer_core_helpers.png) |

| List/Profile Variants | Media/Store Variants |
|---|---|
| ![List Profile](assets/screenshots/shimmer_list_profile.png) | ![Media Store](assets/screenshots/shimmer_media_store.png) |

| Content Utilities |
|---|
| ![Content Utilities](assets/screenshots/shimmer_content_utilities.png) |

#### Animated Loaders

```dart
// Circular loader
XLoader(
  style: LoaderStyle.circular,
  color: Colors.blue,
  size: 48,
)

// Progressive dots (convenience constructor)
XLoader.progressiveDots(
  color: Colors.blue,
  size: 48,
)

// Two rotating arcs (two-color style)
XLoader.twoRotatingArc(
  color: Colors.blue,
  secondaryColor: Colors.pink,
  size: 48,
)

// Newton cradle style
XLoader.newtonCradle(
  color: Colors.blue,
  size: 48,
)

// Accessibility friendly static loader for reduced-motion situations
XLoader(
  style: LoaderStyle.twoRotatingArc,
  enableAnimations: false,
  semanticLabel: 'Static loading indicator',
)
```

#### Nord Theme (Built-in)

```dart
MaterialApp(
  theme: XTheme.nordLight(),
  darkTheme: XTheme.nordDark(),
  themeMode: ThemeMode.system,
  home: const DemoScreen(),
)

// Access exact Nord colors
const primary = XNordPalette.nord10;
const error = XNordPalette.nord11;
```

The example app includes a Theme Playground card where you can switch between Default and Nord, and also toggle System/Light/Dark modes live.

#### Loader Theme & Config

```dart
XLoaderTheme(
  data: const XLoaderThemeData(
    color: Colors.indigo,
    secondaryColor: Colors.pink,
    size: 44,
    duration: Duration(milliseconds: 1100),
    config: XLoaderConfig(
      dotCount: 6,
      barCount: 6,
      amplitudeFactor: 1.2,
      orbitRadiusFactor: 1.1,
    ),
  ),
  child: const XLoader(style: LoaderStyle.progressiveDots),
)

// Per-widget config override
const XLoader(
  style: LoaderStyle.waveDots,
  config: XLoaderConfig(dotCount: 4, amplitudeFactor: 1.5),
)
```

#### Interactive Loader Gallery (Example)

The example app now includes a Phase 3 loader playground where you can tune:

- size and animation speed
- dot/bar counts
- amplitude and orbit factors
- color presets and animation toggle

Use this section in [example/lib/main.dart](example/lib/main.dart) as a reference when deciding sensible defaults for your app theme.

#### Skeleton Placeholders

```dart
// Card skeleton
XSkeletonLoader(shape: SkeletonShape.card, count: 3)

// List skeleton
XSkeletonLoader(shape: SkeletonShape.list, count: 3)

// Profile skeleton
XSkeletonLoader(shape: SkeletonShape.profile)
```

#### Buttons

```dart
// Basic elevated button
XButton(
  label: 'Click Me',
  onPressed: () {},
)

// Loading button
XLoadingButton(
  label: 'Submit',
  onPressed: () async {
    await Future.delayed(Duration(seconds: 2));
  },
)

// Copy button
XCopyButton(
  text: 'Copy this text!',
  label: 'Copy',
)
```

#### Animations

```dart
// Fireworks animation
final fireworksController = FireworksController();

XFireworks(
  controller: fireworksController,
  child: MyWidget(),
)

// Trigger at position
fireworksController.explode(Offset(100, 100));

// Confetti burst
final confettiController = ConfettiController();

XConfetti(
  controller: confettiController,
  child: MyWidget(),
)

confettiController.burst(offset: Offset(100, 100));

// Animated counter
XAnimatedCounter(
  endValue: 1000,
  duration: Duration(seconds: 2),
  useThousandsSeparator: true,
  prefix: '\$',
)
```

#### Form Utilities

```dart
// Email validation
TextFormField(
  validator: XFormValidator.email(),
)

// Password with strength indicator
XPasswordField(
  label: 'Password',
  showStrengthIndicator: true,
)

// Rating bar
XRatingBar(
  rating: 3.5,
  maxRating: 5,
  onRatingChanged: (rating) => print('Rating: $rating'),
)
```

#### Toasts

```dart
// Success toast
XToast.success(context, 'Operation successful!');

// Error toast
XToast.error(context, 'Something went wrong');

// Custom toast
XToast.show(
  context,
  message: 'Hello!',
  type: XToastType.info,
  duration: Duration(seconds: 4),
);
```

#### Dialogs

```dart
// Alert dialog
XDialog.alert(
  context: context,
  title: 'Alert',
  message: 'This is an alert',
);

// Confirm dialog
final confirmed = await XDialog.confirm(
  context: context,
  title: 'Confirm?',
  message: 'Are you sure?',
  onConfirm: () => print('Confirmed'),
);

// Input dialog
final input = await XDialog.input(
  context: context,
  title: 'Enter name',
  hintText: 'Your name',
);
```

#### Bottom Sheets

```dart
// List bottom sheet
await XBottomSheet.list(
  context: context,
  title: 'Choose option',
  options: ['Option 1', 'Option 2', 'Option 3'],
);

// Action bottom sheet
await XBottomSheet.modal(
  context: context,
  title: 'Actions',
  builder: (context) => ListView(
    children: const [
      ListTile(title: Text('Edit')),
      ListTile(title: Text('Delete')),
      ListTile(title: Text('Share')),
    ],
  ),
);
```

#### Theme

```dart
MaterialApp(
  theme: XTheme.light(seedColor: Colors.blue),
  darkTheme: XTheme.dark(seedColor: Colors.blue),
  themeMode: ThemeMode.system,
)

// Color palette
final palette = XColorPalette.fromSeed(Colors.blue);

Container(
  color: palette.primary,
  child: Text('Primary color'),
)
```

#### Other Widgets

```dart
// Empty state
XEmptyState(
  icon: Icons.shopping_cart_outlined,
  title: 'No Items',
  subtitle: 'Your cart is empty',
  actionLabel: 'Continue Shopping',
)

// Avatar with status
XAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  name: 'John Doe',
  status: AvatarStatus.online,
)

// Step indicator
XStepperWidget(
  steps: ['Personal', 'Address', 'Payment'],
  currentStep: 1,
  orientation: Axis.horizontal,
)

// Connectivity banner
Stack(
  children: [
    MyAppContent(),
    const XConnectivityBanner(),
  ],
)
```

## Examples

Complete working examples are available in the `example/` directory:

```bash
cd example
flutter run
```

The example app demonstrates all widgets with various configurations and use cases.

For shimmer-specific examples and controls, open [example/lib/main.dart](example/lib/main.dart) and view the Effects section.

## Documentation

Each widget includes:
- ✅ Comprehensive dartdoc comments
- ✅ Example usage snippets
- ✅ Parameter descriptions
- ✅ Default values

Hover over any widget in your IDE to see full documentation.

## Widget API Reference

### Effects
- `XShimmer` - Customizable shimmer with multiple directions
- `XFireworks` - Canvas particle explosion animator
- `XConfetti` - Confetti burst with physics
- `XAnimatedCounter` - Number roll-up animation

### Loaders
- `XLoader` - 6 loader animation styles
- `XSkeletonLoader` - Layout-aware skeleton placeholders

### Buttons
- `XButton` - Multi-variant customizable button
- `XLoadingButton` - Async button with loading state
- `XCopyButton` - Clipboard copy button

### Dialogs
- `XToast` - Toast notifications
- `XDialog` - Alert/confirm/input dialogs
- `XBottomSheet` - Modal bottom sheets

### Forms
- `XFormValidator` - 10+ validation methods
- `XRatingBar` - Star rating input
- `XPasswordField` - Password with strength meter

### Widgets
- `XEmptyState` - Empty state placeholder
- `XAvatar` - Avatar with badge
- `XStepperWidget` - Step progress indicator
- `XConnectivityBanner` - Network status banner

### Theme
- `XTheme` - Material 3 theme factory
- `XColorPalette` - Color palette generator

## Requirements

- **Flutter**: >= 3.10.0 (Material Design 3 support)
- **Dart**: >= 3.0.0 (Full null safety)
- **Null Safety**: Fully supported and required

## Compatibility

### Dependency-Free Design
XTools has **zero production dependencies** — it only depends on the Flutter SDK. This means:
- ✅ No version conflicts with other packages
- ✅ No transitive dependency hell
- ✅ Works alongside any other pub.dev packages
- ✅ Safe to use in enterprise projects

### Version Support

| Factor | Status | Details |
|--------|--------|---------|
| **Dart SDK** | `^3.0.0` | Full null safety; supports Dart 3.0–4.x |
| **Flutter** | `>=3.10.0` | Material Design 3 stable; covers ~3 years of versions |
| **Material Design** | Material 3 | Built-in; compatible with MD3 and MD2-based apps |
| **Production Dependencies** | **Zero** | Pure Flutter SDK; no external packages |
| **Dev Dependencies** | `flutter_lints: ^6.0.0` | Never shipped; safe for all projects |

### Known Limitations

| Scenario | Compatibility | Details |
|----------|---------------|---------|
| **Flutter 2.x** | ❌ Not supported | Requires Flutter 3.10+; upgrade recommended |
| **Dart 2.x** | ❌ Not supported | Requires Dart 3.0+; null safety required |
| **Legacy projects** | ⚠️ Requires upgrade | Migrate to null safety first, then upgrade Flutter |

### Safety & Stability
- ✅ Fully null-safe codebase
- ✅ Material 3 stable APIs only (no experimental features)
- ✅ Self-contained widgets (no external SDK calls)
- ✅ Extensive animation disposal to prevent memory leaks
- ✅ Reduced-motion accessibility support

## Performance

All widgets are optimized for performance:
- Efficient animations with proper disposal
- Minimal rebuilds using const constructors
- Conditional rendering for hidden content
- No unnecessary dependencies

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

MIT License - see LICENSE file for details

## Support

For issues, questions, or suggestions:
- 📧 Email: chetan.akarte@gmail.com
- 🐛 GitHub Issues: [GitHub](https://github.com/Chetankumar-Akarte/xtools)
- 💬 Discussions: [Discussions](https://github.com/Chetankumar-Akarte/xtools/discussions)

## Changelog

### Version 1.0.0
- **Initial release**: Comprehensive Flutter utility widgets collection
- **Loaders**: 27 animated styles (pulse, orbit, bounce, shimmer, and 23 more) with theme support
- **Effects**: Shimmer with advanced presets, confetti, fireworks, animated counters
- **Buttons**: Full-featured XButton with loading states and rich styling
- **Dialogs**: Bottom sheets, dialogs, and toast notifications
- **Forms**: Form validators, password fields with strength indicator, rating bars
- **Themes**: Material 3 support with light/dark modes, Nord color palette (16-color system)
- **Widgets**: Avatars, connectivity banner, empty states, steppers
- **Accessibility**: Reduced motion support, WCAG contrast analysis in theme playground
- **Example app**: Interactive gallery with Nord theme switching, Frost/Aurora accent selector, live theme controls

### Version 1.1.0 (planned)
- Enhanced shimmer engine with new animation patterns
- Additional loader styles and presets
- Extended form validators
- WebAssembly support enhancements
- `XShimmerTheme` and `XShimmerThemeData` for subtree defaults
- Reference-style shimmer presets (profile, video, youtube, store, content utilities)
- Expanded example shimmer gallery with interactive controls

---

Made with ❤️ for Flutter developers
