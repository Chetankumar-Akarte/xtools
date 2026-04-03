import 'package:flutter/material.dart';
import '../effects/x_shimmer.dart';

/// A skeleton placeholder widget that matches the layout of actual content.
///
/// Ideal for showing placeholder layouts while content is loading.
/// Can be customized to show various layouts like cards, lists, and profiles.
///
/// Example:
/// ```dart
/// XSkeletonLoader(
///   shape: SkeletonShape.card,
///   count: 3,
/// )
/// ```
class XSkeletonLoader extends StatelessWidget {
  /// Shape of skeleton elements
  final SkeletonShape shape;

  /// Number of skeleton elements to display
  final int count;

  /// Whether to show shimmer effect
  final bool withShimmer;

  /// Base color for skeleton
  final Color baseColor;

  /// Highlight color for shimmer
  final Color highlightColor;

  /// Spacing between elements
  final double spacing;

  const XSkeletonLoader({
    super.key,
    this.shape = SkeletonShape.card,
    this.count = 1,
    this.withShimmer = true,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildSkeletonContent();
    return withShimmer
        ? XShimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: child,
          )
        : child;
  }

  Widget _buildSkeletonContent() {
    switch (shape) {
      case SkeletonShape.card:
        return _buildCardSkeleton();
      case SkeletonShape.list:
        return _buildListSkeleton();
      case SkeletonShape.profile:
        return _buildProfileSkeleton();
      case SkeletonShape.grid:
        return _buildGridSkeleton();
      case SkeletonShape.paragraph:
        return _buildParagraphSkeleton();
    }
  }

  Widget _buildCardSkeleton() {
    return ListView.separated(
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildLines(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListSkeleton() {
    return ListView.separated(
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildCircle(48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLine(width: double.infinity),
                  const SizedBox(height: 8),
                  _buildLine(width: 0.7),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCircle(80),
          const SizedBox(height: 16),
          _buildLine(width: 0.6),
          const SizedBox(height: 8),
          _buildLine(width: 0.8),
          const SizedBox(height: 24),
          _buildLines(3),
        ],
      ),
    );
  }

  Widget _buildGridSkeleton() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildParagraphSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLine(width: 0.8),
        const SizedBox(height: 8),
        ...[
          for (int i = 0; i < count - 1; i++) ...[
            _buildLine(width: double.infinity),
            const SizedBox(height: 8),
          ],
        ],
        _buildLine(width: 0.6),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildCircle(40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLine(width: 0.7),
              const SizedBox(height: 4),
              _buildLine(width: 0.5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLines(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < count; i++) ...[
          _buildLine(width: i == count - 1 ? 0.6 : double.infinity),
          if (i < count - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildLine({double height = 12, required double width}) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Shape of skeleton placeholder
enum SkeletonShape {
  /// Card layout with header and content
  card,

  /// List item layout with avatar and text
  list,

  /// Profile layout with avatar, name, and bio
  profile,

  /// Grid layout
  grid,

  /// Paragraph layout
  paragraph,
}
