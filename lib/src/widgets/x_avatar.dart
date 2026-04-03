import 'package:flutter/material.dart';

/// An avatar widget with optional status badge and fallback initials.
///
/// Displays a profile picture with support for online/offline status indicator.
/// Falls back to initials if image fails to load.
///
/// Example:
/// ```dart
/// XAvatar(
///   imageUrl: 'https://example.com/avatar.jpg',
///   name: 'John Doe',
///   radius: 28,
///   status: AvatarStatus.online,
/// )
/// ```
class XAvatar extends StatelessWidget {
  /// URL of the avatar image
  final String? imageUrl;

  /// Name to generate initials from
  final String name;

  /// Radius of the avatar
  final double radius;

  /// Background color (if no image)
  final Color backgroundColor;

  /// Text color for initials
  final Color textColor;

  /// Online/offline status indicator
  final AvatarStatus? status;

  /// Size of the status indicator
  final double statusSize;

  /// Callback when avatar is tapped
  final VoidCallback? onTap;

  const XAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 28,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.status,
    this.statusSize = 12,
    this.onTap,
  });

  String _getInitials(String name) {
    return name
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Avatar circle
          SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : null,
              onBackgroundImageError: imageUrl != null
                  ? (exception, stackTrace) {}
                  : null,
              child: imageUrl == null
                  ? Text(
                      _getInitials(name),
                      style: TextStyle(
                        color: textColor,
                        fontSize: radius * 0.7,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          // Status badge
          if (status != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: statusSize,
                height: statusSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status == AvatarStatus.online
                      ? Colors.green
                      : Colors.grey,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Avatar status indicator
enum AvatarStatus {
  /// User is online
  online,

  /// User is offline
  offline,
}
