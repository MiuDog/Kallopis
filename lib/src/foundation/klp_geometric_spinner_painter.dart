part of 'klp_geometric_spinner.dart';

/// 繪製四個繞中心旋轉並交替色彩的幾何方塊。
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
		final rotation = progress * 2 * math.pi;
		final paint = Paint()..style = PaintingStyle.fill;

		for (var index = 0; index < 4; index++) {
			final angle = rotation + (index * math.pi / 2);
			final x = center.dx + orbitRadius * math.cos(angle);
			final y = center.dy + orbitRadius * math.sin(angle);
			final phase = (progress + (index / 4.0)) % 1.0;
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
