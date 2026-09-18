/// 同一份文字的 Unicode 邊界映射，不負責字素導覽或文件編輯。
final class KlpTextOffsets {

	final String text;
	final List<int> _utf16;
	final List<int> _utf8;

	KlpTextOffsets._(this.text, this._utf16, this._utf8);

	factory KlpTextOffsets(String text) {
		final utf16 = <int>[0];
		final utf8 = <int>[0];
		var offset = 0;
		var bytes = 0;

		// 一次解析並拒絕孤立代理碼，避免編碼器靜默替換原文。
		while (offset < text.length) {
			final unit = text.codeUnitAt(offset);
			if (unit >= 0xd800 && unit <= 0xdbff) {
				if (offset + 1 >= text.length) throw FormatException('Unpaired high surrogate', text, offset);

				final low = text.codeUnitAt(offset + 1);
				if (low < 0xdc00 || low > 0xdfff) throw FormatException('Unpaired high surrogate', text, offset);

				offset += 2;
				bytes += 4;
			}
			else {
				if (unit >= 0xdc00 && unit <= 0xdfff) throw FormatException('Unpaired low surrogate', text, offset);

				offset++;
				if (unit <= 0x7f) {
					bytes++;
				}
				else if (unit <= 0x7ff) {
					bytes += 2;
				}
				else {
					bytes += 3;
				}
			}
			utf16.add(offset);
			utf8.add(bytes);
		}
		return KlpTextOffsets._(text, List.unmodifiable(utf16), List.unmodifiable(utf8));
	}

	int get utf8Length => _utf8.last;
	int get utf16Length => text.length;

	int toUtf8(int utf16Offset) => _utf8[_boundary(_utf16, utf16Offset)];
	int toUtf16(int utf8Offset) => _utf16[_boundary(_utf8, utf8Offset)];

	int _boundary(List<int> offsets, int requested) {
		if (requested < 0 || requested > offsets.last) throw RangeError.range(requested, 0, offsets.last, 'offset');

		// 僅接受精確字碼邊界，不將錯誤位移吸附至附近位置。
		var low = 0;
		var high = offsets.length - 1;
		while (low <= high) {
			final middle = low + ((high - low) ~/ 2);
			final current = offsets[middle];
			if (current == requested) return middle;

			if (current < requested) {
				low = middle + 1;
			}
			else {
				high = middle - 1;
			}
		}
		throw ArgumentError.value(requested, 'offset', 'Offset splits a Unicode scalar');
	}
}
