part of 'klp_style_value.dart';

/// 中立的三次貝茲曲線控制點，執行演算法仍由本庫掌握。
final class KlpCurve extends KlpStyleValue {

	final double x1;
	final double y1;
	final double x2;
	final double y2;

	KlpCurve(this.x1, this.y1, this.x2, this.y2) {
		_checkCoordinate(x1, 'x1', horizontal: true);
		_checkCoordinate(y1, 'y1', horizontal: false);
		_checkCoordinate(x2, 'x2', horizontal: true);
		_checkCoordinate(y2, 'y2', horizontal: false);
	}

	static void _checkCoordinate(double value, String path, {required bool horizontal}) {
		if (!value.isFinite || (horizontal && (value < 0 || value > 1))) {
			throw KlpContractError('invalid_primitive_value', 'curve.$path: expected finite coordinates with x in [0, 1].');
		}
	}
}
