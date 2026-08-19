import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_stroke.dart';

/// 虛線邊框容器。為子元件提供自訂粗細、圓角、顏色與虛線間距的虛線外框。
///
/// 預設使用 theme 的 [KlpShapeTheme.dashedOpacity] 輔助線顏色與 [KlpShapeTheme.control] 圓角。
class KlpDashedBorder extends StatelessWidget {
  const KlpDashedBorder({
    super.key,
    required this.child,
    this.color,
    this.radius,
    this.width,
    this.dashLength,
    this.gapLength,
    this.opacity,
  });

  /// 包裹之子元件。
  final Widget child;

  /// 虛線顏色。`null` 時取自 theme 的 [KlpThemeData.guide]。
  final Color? color;

  /// 邊角圓角半徑。`null` 時取自 theme 的 [KlpShapeTheme.control]。
  final double? radius;

  /// 虛線線寬（粗細）。`null` 時取自 theme 的 [KlpShapeTheme.hairline]。
  final double? width;

  /// 每段虛線長度。`null` 時取自 theme 的 [KlpShapeTheme.dashedLength]。
  final double? dashLength;

  /// 虛線間隔長度。`null` 時取自 theme 的 [KlpShapeTheme.dashedGap]。
  final double? gapLength;

  /// 透明度。
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    return KlpStrokeFrame(
      role: KlpStrokeRole.latent,
      color: color,
      radius: radius,
      width: width,
      dashLength: dashLength,
      gapLength: gapLength,
      opacity: opacity,
      child: child,
    );
  }
}

/// 虛線分隔線。支援水平與垂直兩種方向，以及自訂線寬、顏色與虛線間距。
///
/// 預設使用 theme 的 [KlpShapeTheme.hairline] 粗細與 [KlpShapeTheme.dashedOpacity] 輔助線顏色。
class KlpDashedDivider extends StatelessWidget {
  const KlpDashedDivider({
    super.key,
    this.vertical = false,
    this.width,
    this.color,
    this.dashLength,
    this.gapLength,
    this.opacity,
  });

  /// 是否為垂直分隔線。預設為 `false`（水平分隔線）。
  final bool vertical;

  /// 分隔線線寬（粗細）。`null` 時取自 theme 的 [KlpShapeTheme.hairline]。
  final double? width;

  /// 虛線顏色。`null` 時取自 theme 的 [KlpThemeData.guide]。
  final Color? color;

  /// 每段虛線長度。`null` 時取自 theme 的 [KlpShapeTheme.dashedLength]。
  final double? dashLength;

  /// 虛線間隔長度。`null` 時取自 theme 的 [KlpShapeTheme.dashedGap]。
  final double? gapLength;

  /// 透明度。
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    final shape = context.klp.shape;
    final effectiveWidth = width ?? shape.hairline;
    final baseColor = color ?? context.klpColors.guide;
    final effectiveColor = opacity != null
        ? baseColor.withValues(alpha: opacity!)
        : (color != null
              ? baseColor
              : baseColor.withValues(alpha: shape.dashedOpacity));

    return SizedBox(
      height: vertical ? double.infinity : effectiveWidth,
      width: vertical ? effectiveWidth : double.infinity,
      child: CustomPaint(
        painter: _KlpDashedDividerPainter(
          color: effectiveColor,
          width: effectiveWidth,
          dashLength: dashLength ?? shape.dashedLength,
          gapLength: gapLength ?? shape.dashedGap,
          vertical: vertical,
        ),
      ),
    );
  }
}

class _KlpDashedDividerPainter extends CustomPainter {
  const _KlpDashedDividerPainter({
    required this.color,
    required this.width,
    required this.dashLength,
    required this.gapLength,
    this.vertical = false,
  });

  final Color color;
  final double width;
  final double dashLength;
  final double gapLength;
  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;

    if (vertical) {
      var top = 0.0;
      while (top < size.height) {
        final bottom = (top + dashLength).clamp(0.0, size.height).toDouble();
        canvas.drawLine(
          Offset(size.width / 2, top),
          Offset(size.width / 2, bottom),
          paint,
        );
        top = bottom + gapLength;
      }
    } else {
      var left = 0.0;
      while (left < size.width) {
        final right = (left + dashLength).clamp(0.0, size.width).toDouble();
        canvas.drawLine(
          Offset(left, size.height / 2),
          Offset(right, size.height / 2),
          paint,
        );
        left = right + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _KlpDashedDividerPainter oldDelegate) {
    return color != oldDelegate.color ||
        width != oldDelegate.width ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength ||
        vertical != oldDelegate.vertical;
  }
}
