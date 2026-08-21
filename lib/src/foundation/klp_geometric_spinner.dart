import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';

/// 幾何圖案載入動畫。
///
/// 由四個對稱的小方塊圍繞中心旋轉，並伴隨對比色進行平滑色彩動畫，
/// 適合用於載入狀態、資料請求或背景處理中指示。
class KlpGeometricSpinner extends StatefulWidget {
  const KlpGeometricSpinner({
    super.key,
    this.size,
    this.color,
    this.contrastColor,
    this.duration,
  });

  /// 動畫尺寸（寬高等長）。預設為 `context.klp.space.iconLarge` (24px)。
  final double? size;

  /// 主幾何填色。預設為 `context.klpColors.text`。
  final Color? color;

  /// 對比幾何填色。預設為 `context.klpColors.accent`。
  final Color? contrastColor;

  /// 單次循環週期時長。
  final Duration? duration;

  @override
  State<KlpGeometricSpinner> createState() => _KlpGeometricSpinnerState();
}

class _KlpGeometricSpinnerState extends State<KlpGeometricSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = widget.duration ?? context.klp.motion.spinnerCycle;
    if (context.klp.motion.stateTransition == Duration.zero) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final effectiveSize = widget.size ?? klp.space.iconLarge;
    final effectivePrimary = widget.color ?? tokens.accent;
    final effectiveContrast = widget.contrastColor ?? tokens.interaction;
    final reduceMotion = klp.motion.stateTransition == Duration.zero;

    if (reduceMotion) {
      return Center(
        child: SizedBox.square(
          dimension: effectiveSize,
          child: CustomPaint(
            size: Size.square(effectiveSize),
            painter: _GeometricSpinnerPainter(
              progress: 0.0,
              primaryColor: effectivePrimary,
              contrastColor: effectiveContrast,
              squareFactor: klp.geometry.data.spinnerSquareFactor,
              orbitFactor: klp.geometry.data.spinnerOrbitFactor,
              cornerFactor: klp.geometry.data.spinnerCornerFactor,
            ),
          ),
        ),
      );
    }

    return Center(
      child: SizedBox.square(
        dimension: effectiveSize,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.square(effectiveSize),
              painter: _GeometricSpinnerPainter(
                progress: _controller.value,
                primaryColor: effectivePrimary,
                contrastColor: effectiveContrast,
                squareFactor: klp.geometry.data.spinnerSquareFactor,
                orbitFactor: klp.geometry.data.spinnerOrbitFactor,
                cornerFactor: klp.geometry.data.spinnerCornerFactor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GeometricSpinnerPainter extends CustomPainter {
  const _GeometricSpinnerPainter({
    required this.progress,
    required this.primaryColor,
    required this.contrastColor,
    required this.squareFactor,
    required this.orbitFactor,
    required this.cornerFactor,
  });

  final double progress;
  final Color primaryColor;
  final Color contrastColor;
  final double squareFactor;
  final double orbitFactor;
  final double cornerFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final squareSize = size.width * squareFactor;
    final orbitRadius = size.width * orbitFactor;
    final cornerRadius = Radius.circular(size.width * cornerFactor);

    // 四個小方塊圍繞中心自轉與公轉
    final rotation = progress * 2 * math.pi;

    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 4; i++) {
      final angle = rotation + (i * math.pi / 2);
      final x = center.dx + orbitRadius * math.cos(angle);
      final y = center.dy + orbitRadius * math.sin(angle);

      // 對比色彩動畫
      final phase = (progress + (i / 4.0)) % 1.0;
      final wave = (math.sin(phase * 2 * math.pi) + 1) / 2;
      paint.color =
          Color.lerp(primaryColor, contrastColor, wave) ?? primaryColor;

      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: squareSize,
        height: squareSize,
      );

      canvas.drawRRect(RRect.fromRectAndRadius(rect, cornerRadius), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GeometricSpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.contrastColor != contrastColor ||
        oldDelegate.squareFactor != squareFactor ||
        oldDelegate.orbitFactor != orbitFactor ||
        oldDelegate.cornerFactor != cornerFactor;
  }
}
