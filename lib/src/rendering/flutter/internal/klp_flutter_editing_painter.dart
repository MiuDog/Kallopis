import 'dart:typed_data';
import 'package:flutter/rendering.dart';

import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_path.dart';
import 'package:kallopis/src/features/editing/presentation/klp_bound_editing_style.dart';
import 'klp_flutter_values.dart';

/// 重播核心幾何；不以 Flutter 字體測量建立第二份文字排版。
final class KlpFlutterEditingPainter extends CustomPainter {

	final KlpEditingDrawing drawing;
	final KlpBoundEditingStyle style;

	KlpFlutterEditingPainter(this.drawing, this.style);

	@override
	void paint(Canvas canvas, Size size) {
		final paths = <KlpEditingPath, Path>{};
		final paints = <KlpEditingPaintRole, Paint>{};
		Paint paintFor(KlpEditingPaintRole role) => paints.putIfAbsent(role, () => Paint()..color = klpFlutterColor(style.color(role)));

		// 檢視區尺寸不同時仍使用原始座標並裁切；不可縮放舊 frame 假裝重新排版。
		final saved = canvas.getSaveCount();
		canvas.save();
		try {
			canvas.clipRect(Offset.zero & size);
			canvas.clipRect(Rect.fromLTWH(0, 0, drawing.width, drawing.height));
			for (final command in drawing.commands) {
				switch (command) {
					case KlpEditingDrawRect(:final rect, :final role):
						canvas.drawRect(_rect(rect), paintFor(role));
					case KlpEditingDrawPath(:final path, :final role):
						canvas.drawPath(paths.putIfAbsent(path, () => _path(path)), paintFor(role));
					case KlpEditingPushClip(:final rect):
						canvas.save();
						canvas.clipRect(_rect(rect));
					case KlpEditingPopClip() || KlpEditingPopTransform():
						canvas.restore();
					case KlpEditingPushTransform(:final affine):
						canvas.save();
						canvas.transform(Float64List.fromList([
							affine[0], affine[1], 0, 0,
							affine[2], affine[3], 0, 0,
							0, 0, 1, 0,
							affine[4], affine[5], 0, 1,
						]));
				}
			}
		}
		finally { canvas.restoreToCount(saved); }
	}

	Rect _rect(KlpEditingRect rect) => Rect.fromLTWH(rect.x, rect.y, rect.width, rect.height);

	Path _path(KlpEditingPath source) {
		final path = Path();
		for (final command in source.commands) {
			final v = command.values;
			switch (command.operation) {
				case KlpEditingPathOperation.move: path.moveTo(v[0], v[1]);
				case KlpEditingPathOperation.line: path.lineTo(v[0], v[1]);
				case KlpEditingPathOperation.quadratic: path.quadraticBezierTo(v[0], v[1], v[2], v[3]);
				case KlpEditingPathOperation.cubic: path.cubicTo(v[0], v[1], v[2], v[3], v[4], v[5]);
				case KlpEditingPathOperation.close: path.close();
			}
		}
		return path;
	}

	@override
	bool shouldRepaint(KlpFlutterEditingPainter oldDelegate) => !identical(drawing, oldDelegate.drawing) || !identical(style, oldDelegate.style);
}
