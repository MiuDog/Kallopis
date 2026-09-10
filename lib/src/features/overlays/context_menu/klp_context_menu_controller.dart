part of '../klp_context_menu.dart';

/// 讓子元件以既有 [KlpContextMenu] 的定位與外觀主動開啟選單。
///
/// controller 尚未掛載時呼叫不會產生作用；同一時間只應掛載到一個 context menu。
class KlpContextMenuController {
	void Function(Offset)? _open;
	VoidCallback? _close;

	bool get isAttached => _open != null;

	void openAt(Offset globalPosition) => _open?.call(globalPosition);

	void close() => _close?.call();

	void _attach({
		required void Function(Offset) open,
		required VoidCallback close,
	}) {
		assert(_open == null, 'A KlpContextMenuController can only have one host.');
		_open = open;
		_close = close;
	}

	void _detach() {
		_open = null;
		_close = null;
	}
}
