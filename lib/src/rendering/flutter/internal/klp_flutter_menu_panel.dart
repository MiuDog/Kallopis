import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/features/overlays/declarative/klp_bound_menu.dart';
import 'package:kallopis/src/features/overlays/declarative/klp_menu_item.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_block.dart';
import 'klp_flutter_lucide_icon.dart';
import 'klp_flutter_selection_surface.dart';
import 'klp_flutter_values.dart';

/// 面板與浮層共用同一選單；入口資料決定是否由庫管理開關。
final class KlpFlutterMenu extends StatelessWidget {

	final KlpBoundMenu content;
	const KlpFlutterMenu({required this.content, super.key});

	@override
	Widget build(BuildContext context) => content.triggerLabel == null ? KlpFlutterMenuPanel(content: content) : _MenuPopup(content: content);
}

final class _MenuPopup extends StatefulWidget {

	final KlpBoundMenu content;
	const _MenuPopup({required this.content});

	@override
	State<_MenuPopup> createState() => _MenuPopupState();
}

final class _MenuPopupState extends State<_MenuPopup> {

	final _portal = OverlayPortalController();
	final _focus = FocusNode();

	@override
	void dispose() {
		_focus.dispose();
		super.dispose();
	}

	void _open(KlpBoundMenu expected) {
		if (!mounted || !identical(widget.content, expected) || _portal.isShowing) return;
		setState(_portal.show);
	}

	void _close() {
		if (!mounted || !_portal.isShowing) return;
		setState(_portal.hide);
		_focus.requestFocus();
	}

	@override
	Widget build(BuildContext context) {
		final content = widget.content;
		final style = content.style;
		return OverlayPortal.overlayChildLayoutBuilder(
			controller: _portal,
			overlayLocation: OverlayChildLocation.rootOverlay,
			overlayChildBuilder: (context, info) {
				final anchor = MatrixUtils.transformRect(info.childPaintTransform, Offset.zero & info.childSize);
				return SizedBox.fromSize(size: info.overlaySize, child: Stack(fit: StackFit.expand, children: [
					ModalBarrier(dismissible: true, onDismiss: _close, semanticsLabel: content.label),
					CustomSingleChildLayout(
						delegate: _MenuPopupLayout(anchor, style.width),
						child: KlpFlutterMenuPanel(
							content: content,
							onDismiss: _close,
							isActive: () => mounted && _portal.isShowing && identical(content, widget.content),
						),
					),
				]));
			},
			child: Align(alignment: AlignmentDirectional.topStart, widthFactor: 1, heightFactor: 1, child: SizedBox(
				width: style.width,
				height: style.rowExtent,
				child: Focus(
					focusNode: _focus,
					autofocus: content.autofocus,
					onFocusChange: (_) { if (mounted) setState(() {}); },
					onKeyEvent: (_, event) {
						if (event is! KeyDownEvent) return KeyEventResult.ignored;
						if ([LogicalKeyboardKey.enter, LogicalKeyboardKey.space, LogicalKeyboardKey.arrowDown].contains(event.logicalKey)) {
							_open(content);
							return KeyEventResult.handled;
						}
						return KeyEventResult.ignored;
					},
					child: KlpFlutterSelectionSurface(
						color: klpFlutterColor(style.interaction),
						radius: style.itemRadius,
						selected: _portal.isShowing,
						enabled: true,
						focused: _focus.hasFocus,
						trackFocus: false,
						child: Semantics(button: true, expanded: _portal.isShowing, child: GestureDetector(
							behavior: HitTestBehavior.opaque,
							onTap: () => _open(content),
							child: Padding(padding: EdgeInsets.symmetric(horizontal: style.inset), child: Row(children: [
								Expanded(child: Text(content.triggerLabel!, style: klpFlutterTextStyle(style.text), maxLines: 1, overflow: TextOverflow.ellipsis)),
								SizedBox(width: style.gap),
								RotatedBox(quarterTurns: 1, child: KlpFlutterLucideIcon('chevron-right', size: style.iconExtent, color: klpFlutterColor(style.foreground))),
							])),
						)),
					),
				),
			)),
		);
	}
}

/// 使用實際面板尺寸選擇上／下方；空間不足時限制尺寸並留給面板捲動。
final class _MenuPopupLayout extends SingleChildLayoutDelegate {

	final Rect anchor;
	final double width;
	_MenuPopupLayout(this.anchor, this.width);

	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) => BoxConstraints(maxWidth: width.clamp(0, constraints.maxWidth), maxHeight: constraints.maxHeight);

	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final left = anchor.left.clamp(0.0, size.width - childSize.width);
		final desiredTop = anchor.bottom + childSize.height <= size.height ? anchor.bottom : anchor.top - childSize.height;
		return Offset(left, desiredTop.clamp(0.0, size.height - childSize.height));
	}

	@override
	bool shouldRelayout(_MenuPopupLayout oldDelegate) => oldDelegate.anchor != anchor || oldDelegate.width != width;
}

/// 新選單只渲染已準備資料，不引用舊 Menu Widget 或另一份 theme。
final class KlpFlutterMenuPanel extends StatefulWidget {

	final KlpBoundMenu content;
	final VoidCallback? onDismiss;
	final bool Function()? isActive;
	const KlpFlutterMenuPanel({required this.content, this.onDismiss, this.isActive, super.key});

	@override
	State<KlpFlutterMenuPanel> createState() => _MenuPanelState();
}

final class _MenuPanelState extends State<KlpFlutterMenuPanel> {

	int _highlighted = -1;
	final _focus = FocusNode();
	final _itemKeys = <String, GlobalKey>{};
	final _path = <KlpMenuItem>[];

	KlpBoundMenu get content => widget.content;
	KlpBoundMenuStyle get style => content.style;
	List<KlpMenuItem> get _items => _path.isEmpty ? content.items : _path.last.children;

	@override
	void initState() {
		super.initState();
		// 浮層必須主動接手入口焦點，autofocus 不會取代同 scope 既有焦點。
		if (widget.onDismiss != null) _focus.requestFocus();
	}

	@override
	void didUpdateWidget(KlpFlutterMenuPanel oldWidget) {
		super.didUpdateWidget(oldWidget);
		final oldItems = _path.isEmpty ? oldWidget.content.items : _path.last.children;
		final activeId = _highlighted >= 0 && _highlighted < oldItems.length ? oldItems[_highlighted].id : null;
		// 資料更新後重綁仍有效的路徑，不保存舊 frame 的子項或事件。
		var candidates = content.items;
		final nextPath = <KlpMenuItem>[];
		for (final parent in _path) {
			final index = candidates.indexWhere((item) => item.id == parent.id && item.enabled && item.children.isNotEmpty);
			if (index < 0) break;
			final current = candidates[index];
			nextPath.add(current);
			candidates = current.children;
		}
		_path..clear()..addAll(nextPath);
		_highlighted = _items.indexWhere((item) => item.id == activeId && item.enabled);
		final ids = _items.map((item) => item.id.toString()).toSet();
		_itemKeys.removeWhere((id, _) => !ids.contains(id));
	}

	void _activate(KlpMenuItem item) {
		if (!mounted || widget.isActive?.call() == false || !item.enabled || !_items.any((current) => identical(current, item))) return;
		_focus.requestFocus();
		if (item.children.isEmpty) {
			widget.onDismiss?.call();
			item.onPressed?.call();
			return;
		}
		setState(() { _path.add(item); _highlighted = -1; _itemKeys.clear(); });
		_highlight(_items.indexWhere((child) => child.enabled));
	}

	void _back() {
		if (_path.isEmpty) return;
		final parent = _path.last;
		setState(() { _path.removeLast(); _highlighted = -1; _itemKeys.clear(); });
		_focus.requestFocus();
		_highlight(_items.indexWhere((item) => item.id == parent.id && item.enabled));
	}

	@override
	void dispose() {
		_focus.dispose();
		super.dispose();
	}

	void _highlight(int index) {
		setState(() => _highlighted = index);
		if (index < 0) return;

		// 鍵盤移動到畫面外項目時捲動至可見，保留視窗內選單操作。
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (!mounted || index != _highlighted || index >= _items.length) return;

			final itemContext = _itemKeys[_items[index].id.toString()]?.currentContext;
			if (itemContext != null) Scrollable.ensureVisible(itemContext);
		});
	}

	int _next(int direction) {
		final count = _items.length;
		if (count == 0) return -1;

		var index = _highlighted;
		if (index < 0) index = direction > 0 ? -1 : 0;
		for (var attempt = 0; attempt < count; attempt++) {
			index = (index + direction) % count;
			if (_items[index].enabled) return index;
		}
		return -1;
	}

	KeyEventResult _onKey(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent || widget.isActive?.call() == false) return KeyEventResult.ignored;

		final key = event.logicalKey;
		if (key == LogicalKeyboardKey.escape) {
			widget.onDismiss?.call();
			content.onEscape?.call();
			return KeyEventResult.handled;
		}
		if (key == LogicalKeyboardKey.arrowLeft) {
			_back();
			return KeyEventResult.handled;
		}
		if (key == LogicalKeyboardKey.arrowRight) {
			if (_highlighted >= 0 && _highlighted < _items.length && _items[_highlighted].children.isNotEmpty) _activate(_items[_highlighted]);
			return KeyEventResult.handled;
		}
		if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.arrowUp) {
			_highlight(_next(key == LogicalKeyboardKey.arrowDown ? 1 : -1));
			return KeyEventResult.handled;
		}
		if (key == LogicalKeyboardKey.home || key == LogicalKeyboardKey.end) {
			final items = _items;
			_highlight(key == LogicalKeyboardKey.home ? items.indexWhere((item) => item.enabled) : items.lastIndexWhere((item) => item.enabled));
			return KeyEventResult.handled;
		}
		if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter || key == LogicalKeyboardKey.space) {
			if (_highlighted >= 0 && _highlighted < _items.length) {
				_activate(_items[_highlighted]);
			}
			return KeyEventResult.handled;
		}
		return KeyEventResult.ignored;
	}

	@override
	Widget build(BuildContext context) {
		final text = klpFlutterTextStyle(style.text);
		final panel = DecoratedBox(
			decoration: BoxDecoration(
				color: klpFlutterColor(style.surface),
				borderRadius: BorderRadius.circular(style.panelRadius),
				boxShadow: [BoxShadow(color: klpFlutterColor(style.shadow), blurRadius: style.shadowBlur, offset: Offset(0, style.shadowOffset))],
			),
			child: Padding(padding: EdgeInsets.all(style.padding), child: SingleChildScrollView(child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					_header(text),
					SizedBox(height: style.padding),
					for (var index = 0; index < _items.length; index++) ...[
						if (index > 0 && !_items[index].separatedBefore && !_items[index].dashedSeparatorBefore) SizedBox(height: style.itemGap),
						if (_items[index].separatedBefore || _items[index].dashedSeparatorBefore) _separator(_items[index].dashedSeparatorBefore),
						_item(_items[index], index),
					],
				],
			))),
		);
		return Align(alignment: AlignmentDirectional.topStart, widthFactor: 1, heightFactor: 1, child: SizedBox(width: style.width, child: Focus(focusNode: _focus, autofocus: widget.onDismiss != null || content.autofocus, onKeyEvent: _onKey, child: panel)));
	}

	Widget _header(TextStyle text) {
		final nested = _path.isNotEmpty;
		final label = nested ? _path.last.label : content.label;
		final muted = klpFlutterColor(style.muted);
		return Semantics(button: nested, child: GestureDetector(
			behavior: HitTestBehavior.opaque,
			onTap: nested ? _back : null,
			child: SizedBox(height: style.headerExtent, child: Padding(padding: EdgeInsets.symmetric(horizontal: style.inset), child: Row(children: [
				if (nested) ...[
					RotatedBox(quarterTurns: 2, child: KlpFlutterLucideIcon('chevron-right', size: style.iconExtent, color: muted)),
					SizedBox(width: style.gap),
				],
				Expanded(child: Text(label, style: text.copyWith(color: muted), maxLines: 1, overflow: TextOverflow.ellipsis)),
			]))),
		));
	}

	Widget _item(KlpMenuItem item, int index) {
		final foreground = klpFlutterColor(switch ((item.enabled, item.destructive)) {
			(false, _) => style.muted,
			(true, true) => style.destructive,
			(true, false) => style.foreground,
		});
		final text = klpFlutterTextStyle(style.text).copyWith(color: foreground);
		final key = _itemKeys.putIfAbsent(item.id.toString(), GlobalKey.new);
		return KlpFlutterSelectionSurface(
			key: key,
			color: klpFlutterColor(style.interaction),
			radius: style.itemRadius,
			selected: item.selected,
			enabled: item.enabled,
			focused: index == _highlighted,
			trackFocus: false,
			child: Semantics(
				label: item.label,
				button: true,
				enabled: item.enabled,
				selected: item.selected,
				toggled: item.toggleValue,
				excludeSemantics: true,
				child: GestureDetector(
					behavior: HitTestBehavior.opaque,
					onTap: !item.enabled ? null : () => _activate(item),
					child: SizedBox(height: style.rowExtent, child: Padding(padding: EdgeInsets.symmetric(horizontal: style.inset), child: Row(children: [
						if (item.icon != null) ...[
							Transform.translate(offset: Offset(0, style.iconOffset), child: KlpFlutterLucideIcon(_iconName(item.icon!), size: style.iconExtent, color: foreground)),
							SizedBox(width: style.gap),
						],
						Expanded(child: Text(item.label, style: text, maxLines: 1, overflow: TextOverflow.ellipsis)),
						if (item.shortcut != null) Text(item.shortcut!, style: text.copyWith(color: klpFlutterColor(style.muted))),
						if (item.toggleValue != null) _toggle(item),
						if (item.hasSubmenu) KlpFlutterLucideIcon('chevron-right', size: style.iconExtent, color: foreground),
					]))),
				),
			),
		);
	}

	Widget _toggle(KlpMenuItem item) {
		final on = item.toggleValue!;
		final track = switch ((item.enabled, on)) {
			(false, _) => style.surface,
			(true, true) => style.interaction,
			(true, false) => style.toggleOffTrack,
		};
		final thumb = item.enabled && on ? style.foreground : style.muted;
		return SizedBox(width: style.toggleWidth, height: style.toggleHeight, child: DecoratedBox(
			decoration: BoxDecoration(color: klpFlutterColor(track), borderRadius: BorderRadius.circular(style.toggleTrackRadius)),
			child: Padding(padding: EdgeInsets.all(style.toggleInset), child: Align(alignment: on ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart, child: DecoratedBox(
				decoration: BoxDecoration(color: klpFlutterColor(thumb), borderRadius: BorderRadius.circular(style.toggleThumbRadius)),
				child: SizedBox.square(dimension: style.toggleThumb),
			))),
		));
	}

	Widget _separator(bool dashed) => Padding(padding: EdgeInsets.symmetric(vertical: style.padding), child: SizedBox(height: style.stroke, child: CustomPaint(painter: _MenuDividerPainter(style, dashed))));

	String _iconName(KlpWorkspaceIcon icon) => switch (icon) {
		KlpWorkspaceIcon.search => 'search',
		KlpWorkspaceIcon.settings => 'sliders-horizontal',
		KlpWorkspaceIcon.inbox => 'inbox',
		KlpWorkspaceIcon.calendar => 'calendar',
		KlpWorkspaceIcon.clipboard => 'clipboard-list',
		KlpWorkspaceIcon.archive => 'archive',
		KlpWorkspaceIcon.disclosure => 'chevron-right',
		KlpWorkspaceIcon.folder => 'folder',
		KlpWorkspaceIcon.file => 'file-text',
		KlpWorkspaceIcon.minimize => 'minus',
		KlpWorkspaceIcon.maximize => 'square',
		KlpWorkspaceIcon.restore => 'copy',
		KlpWorkspaceIcon.close => 'x',
		KlpWorkspaceIcon.check => 'check',
		KlpWorkspaceIcon.link => 'link',
		KlpWorkspaceIcon.info => 'info',
		KlpWorkspaceIcon.sparkles => 'sparkles',
		KlpWorkspaceIcon.image => 'image',
		KlpWorkspaceIcon.music => 'music',
		KlpWorkspaceIcon.board => 'layout-dashboard',
		KlpWorkspaceIcon.lightbulb => 'lightbulb',
		KlpWorkspaceIcon.calendarCheck => 'calendar-check',
	};
}

final class _MenuDividerPainter extends CustomPainter {

	final KlpBoundMenuStyle style;
	final bool dashed;
	_MenuDividerPainter(this.style, this.dashed);

	@override
	void paint(Canvas canvas, Size size) {
		final paint = Paint()..color = klpFlutterColor(style.interaction);
		if (!dashed) {
			canvas.drawRect(Offset.zero & size, paint);
			return;
		}
		final step = style.dashLength + style.dashGap;
		if (step <= 0) return;

		for (var left = 0.0; left < size.width; left += step) {
			canvas.drawRect(Rect.fromLTWH(left, 0, style.dashLength.clamp(0, size.width - left), size.height), paint);
		}
	}

	@override
	bool shouldRepaint(_MenuDividerPainter oldDelegate) => oldDelegate.style != style || oldDelegate.dashed != dashed;
}
