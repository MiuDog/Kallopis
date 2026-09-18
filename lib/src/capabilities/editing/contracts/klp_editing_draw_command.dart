import 'klp_editing_path.dart';

/// 提供者只能標示用途，實際顏色由本庫解析。
enum KlpEditingPaintRole { text, ink, caret, selection, listMarker }

typedef KlpEditingRect = ({double x, double y, double width, double height});

void _validateRect(KlpEditingRect rect) {
	if (![rect.x, rect.y, rect.width, rect.height, rect.x + rect.width, rect.y + rect.height].every((value) => value.isFinite) || rect.width < 0 || rect.height < 0) throw ArgumentError('Invalid editing rectangle');
}

sealed class KlpEditingDrawCommand {

	const KlpEditingDrawCommand();
}

/// 以語意用途繪製矩形的資料指令；不攜帶原生 painter 或顏色。
final class KlpEditingDrawRect extends KlpEditingDrawCommand {

	final KlpEditingRect rect;
	final KlpEditingPaintRole role;

	KlpEditingDrawRect(this.rect, this.role) { _validateRect(rect); }
}

/// 以語意用途繪製提供者路徑的指令；不擁有筆刷或平台畫布。
final class KlpEditingDrawPath extends KlpEditingDrawCommand {

	final KlpEditingPath path;
	final KlpEditingPaintRole role;

	const KlpEditingDrawPath(this.path, this.role);
}

/// 將矩形裁切範圍推入繪製狀態；只描述操作而不持有畫布。
final class KlpEditingPushClip extends KlpEditingDrawCommand {

	final KlpEditingRect rect;

	KlpEditingPushClip(this.rect) { _validateRect(rect); }
}

/// 結束最近一層裁切的資料指令；配對與執行由繪製流程驗證。
final class KlpEditingPopClip extends KlpEditingDrawCommand {

	const KlpEditingPopClip();
}

/// 六值仿射矩陣依序為 a、b、c、d、tx、ty；不可攜帶平台 Matrix 型別。
final class KlpEditingPushTransform extends KlpEditingDrawCommand {

	final List<double> affine;

	KlpEditingPushTransform(Iterable<double> affine) : affine = List.unmodifiable(affine) {
		if (this.affine.length != 6 || !this.affine.every((value) => value.isFinite)) throw ArgumentError('Invalid editing transform');
	}
}

/// 結束最近一層座標轉換的資料指令；不保存平台矩陣狀態。
final class KlpEditingPopTransform extends KlpEditingDrawCommand {

	const KlpEditingPopTransform();
}
