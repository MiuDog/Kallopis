part of '../klp_code_viewer.dart';

class _KlpCodeFrame extends StatelessWidget {
  const _KlpCodeFrame({required this.kind, required this.style, this.child});

  final _KlpCodeFrameKind kind;
  final _KlpCodeStyle style;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      _KlpCodeFrameKind.outer => ClipRRect(
        borderRadius: BorderRadius.circular(style.cardRadius),
        child: Container(
          decoration: BoxDecoration(
            color: style.stageSurface,
            borderRadius: BorderRadius.circular(style.cardRadius),
            border: Border.all(color: style.divider, width: style.strokeWidth),
          ),
          child: child,
        ),
      ),
      _KlpCodeFrameKind.headerLeading => _buildHeader(
        EdgeInsets.only(left: style.headerPaddingX),
      ),
      _KlpCodeFrameKind.headerSymmetric => _buildHeader(
        EdgeInsets.symmetric(horizontal: style.headerPaddingX),
      ),
      _KlpCodeFrameKind.addedLine => _buildDiffLine(
        style.success.withValues(alpha: style.diffFillOpacity),
      ),
      _KlpCodeFrameKind.deletedLine => _buildDiffLine(
        style.danger.withValues(alpha: style.diffFillOpacity),
      ),
      _KlpCodeFrameKind.unchangedLine => _buildDiffLine(null),
      _KlpCodeFrameKind.terminalDot => DecoratedBox(
        decoration: BoxDecoration(
          color: style.textFaint,
          shape: BoxShape.circle,
        ),
        child: SizedBox.square(dimension: style.terminalDotSize),
      ),
    };
  }

  Widget _buildHeader(EdgeInsetsGeometry padding) {
    return Container(
      decoration: BoxDecoration(
        color: style.surfaceInset,
        border: Border(
          bottom: BorderSide(color: style.divider, width: style.strokeWidth),
        ),
      ),
      child: SizedBox(
        height: style.headerHeight,
        child: Padding(padding: padding, child: child),
      ),
    );
  }

  Widget _buildDiffLine(Color? background) {
    return Container(
      color: background,
      padding: EdgeInsets.symmetric(
        horizontal: style.bodyPaddingX,
        vertical: style.microPaddingY,
      ),
      child: child,
    );
  }
}
