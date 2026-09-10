part of '../klp_navigator_models.dart';

/// 不受 Navigator 固定列高限制的任意元件插槽。
///
/// 搜尋框、虛線分隔線、按鈕列表等元件保留自己的高度、狀態與事件。
@immutable
final class KlpNavigatorComponent extends KlpNavigatorItem {
	const KlpNavigatorComponent({required super.id, required this.child});

	final Widget child;
}
