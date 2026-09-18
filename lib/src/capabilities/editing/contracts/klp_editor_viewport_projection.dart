import 'klp_editing_stamp.dart';

/// 與 drawing 同幀的垂直 viewport 權威；範圍來自核心 Flow extent。
final class KlpEditorViewportProjection {
	final KlpEditingStamp stamp;
	final double width;
	final double height;
	final double contentExtent;
	final double scrollY;

	KlpEditorViewportProjection({required this.stamp, required this.width, required this.height, required this.contentExtent, required this.scrollY}) {
		if (![width, height, contentExtent, scrollY, maxScrollY].every((value) => value.isFinite) || width <= 0 || height <= 0 || contentExtent < 0 || scrollY < 0 || scrollY > maxScrollY) {
			throw ArgumentError('Invalid editor viewport projection');
		}
	}

	double get maxScrollY => contentExtent > height ? contentExtent - height : 0;
}
