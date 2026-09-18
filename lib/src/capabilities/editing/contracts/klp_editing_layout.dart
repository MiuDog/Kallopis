import 'klp_editing_style.dart';
import 'klp_editing_viewport.dart';

/// 一次完整重排要求；尺寸與風格不可分批套用。
final class KlpEditingLayout {
	final KlpEditingViewport viewport;
	final KlpEditingStyle style;

	const KlpEditingLayout({required this.viewport, required this.style});

	void validate() => viewport.validate();
}
