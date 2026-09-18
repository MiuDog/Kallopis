import 'klp_editing_stamp.dart';
import 'klp_text_offsets.dart';

/// 權威發布的單一區塊輸入視窗；位移均相對此文字，以 UTF-8 byte 表示。
/// 此物件只驗證與轉接，不取得文件、字素選取或組字交易的所有權。
/// 來源座標屬於此版本的投影文字，包含組字預覽時不可當成已提交文件座標。
final class KlpEditingTextWindow {

	final KlpEditingStamp stamp;
	final String blockId;
	final int sourceStartUtf8;
	final KlpTextOffsets offsets;
	final int? anchorUtf8;
	final int? focusUtf8;
	final int? composingStartUtf8;
	final int? composingEndUtf8;

	KlpEditingTextWindow({
		required this.stamp,
		required this.blockId,
		required this.sourceStartUtf8,
		required String text,
		this.anchorUtf8,
		this.focusUtf8,
		this.composingStartUtf8,
		this.composingEndUtf8,
	}) : offsets = KlpTextOffsets(text) {
		if (blockId.trim().isEmpty) throw ArgumentError('Input window requires a block identity');
		if (sourceStartUtf8 < 0) throw ArgumentError.value(sourceStartUtf8, 'sourceStartUtf8');
		if ((anchorUtf8 == null) != (focusUtf8 == null)) throw ArgumentError('Selection endpoints must both be present or absent');
		if ((composingStartUtf8 == null) != (composingEndUtf8 == null)) throw ArgumentError('Composition endpoints must both be present or absent');

		// 同一份文字驗證所有位置；空組字仍屬進行中，不能當成平台已結束。
		for (final offset in [anchorUtf8, focusUtf8, composingStartUtf8, composingEndUtf8]) {
			if (offset != null) offsets.toUtf16(offset);
		}
		if (composingStartUtf8 != null) {
			if (anchorUtf8 == null) throw ArgumentError('Composition requires a selection');
			if (composingStartUtf8! > composingEndUtf8!) throw ArgumentError('Composition range must be ordered');
		}
	}

	String get text => offsets.text;
	int? get anchorUtf16 => anchorUtf8 == null ? null : offsets.toUtf16(anchorUtf8!);
	int? get focusUtf16 => focusUtf8 == null ? null : offsets.toUtf16(focusUtf8!);
	int? get composingStartUtf16 => composingStartUtf8 == null ? null : offsets.toUtf16(composingStartUtf8!);
	int? get composingEndUtf16 => composingEndUtf8 == null ? null : offsets.toUtf16(composingEndUtf8!);

	int toSourceUtf8(int localUtf16, KlpEditingStamp expected) {
		stamp.requireExact(expected);
		return sourceStartUtf8 + offsets.toUtf8(localUtf16);
	}

	int toLocalUtf16(int sourceUtf8, KlpEditingStamp expected) {
		stamp.requireExact(expected);
		return offsets.toUtf16(sourceUtf8 - sourceStartUtf8);
	}
}
