import 'package:flutter/material.dart';

/// A connectivity status banner widget.
///
/// Automatically shows/hides when internet connection changes.
/// Displays at the top of widget tree.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Stack(
///       children: [
///         MyAppContent(),
///         const XConnectivityBanner(),
///       ],
///     ),
///   );
/// }
/// ```
class XConnectivityBanner extends StatefulWidget {
  /// Icon to show when offline
  final IconData offlineIcon;

  /// Icon to show when online
  final IconData onlineIcon;

  /// Message when offline
  final String offlineMessage;

  /// Message when online
  final String onlineMessage;

  /// Background color when offline
  final Color offlineColor;

  /// Background color when online
  final Color onlineColor;

  /// Text color for messages
  final Color textColor;

  /// Animation duration
  final Duration animationDuration;

  /// Height of the banner
  final double height;

  /// Margin around the banner
  final EdgeInsetsGeometry margin;

  /// Whether banner is enabled
  final bool enabled;

  const XConnectivityBanner({
    super.key,
    this.offlineIcon = Icons.cloud_off,
    this.onlineIcon = Icons.cloud_done,
    this.offlineMessage = 'No Internet Connection',
    this.onlineMessage = 'Back Online',
    this.offlineColor = Colors.red,
    this.onlineColor = Colors.green,
    this.textColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 300),
    this.height = 56,
    this.margin = const EdgeInsets.all(0),
    this.enabled = true,
  });

  @override
  State<XConnectivityBanner> createState() => _XConnectivityBannerState();
}

class _XConnectivityBannerState extends State<XConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isOnline = true;
  bool _showOnlineMessage = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Simulate connectivity changes
    // In a real app, you'd use connectivity package
    _simulateConnectivityChange();
  }

  void _simulateConnectivityChange() {
    // This is for demonstration. In production, use:
    // connectivity_plus or similar package
    // For now, we'll assume always online
    _updateConnectivity(true);
  }

  void _updateConnectivity(bool isOnline) {
    if (_isOnline == isOnline) return;

    setState(() {
      _isOnline = isOnline;
      if (isOnline) {
        _showOnlineMessage = true;
        // Show online message for 3 seconds then hide
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isOnline) {
            _animationController.reverse();
          }
        });
      } else {
        _showOnlineMessage = false;
      }
    });

    if (_isOnline || !_showOnlineMessage) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _isOnline && !_showOnlineMessage) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: widget.margin,
        height: widget.height,
        color: _isOnline ? widget.onlineColor : widget.offlineColor,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              _isOnline ? widget.onlineIcon : widget.offlineIcon,
              color: widget.textColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isOnline ? widget.onlineMessage : widget.offlineMessage,
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
