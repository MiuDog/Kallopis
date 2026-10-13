import 'package:flutter/material.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/features/actions/command_entries/klp_command_entries.dart';
import 'package:kallopis/src/features/actions/command_registry/klp_command_registry.dart';

/// 同一 popup session 的關閉意圖，由產品採用或保留 open 狀態。
enum KlpCommandPopupDismissReason { escape, outside, executed }

/// 依 caller 錨點及主題呈現已註冊選單，不擁有產品開關或命令資料。
class KlpRegisteredCommandPopup<C> extends StatefulWidget {

	/* registry/getContext 保持產品權威；items 指定公開 menu 排列；label/emptyLabel 提供產品文案。
	 * open/anchor 由產品控制生命週期及同視窗邏輯座標；onResult 保留原值；onDismiss 只交回意圖。 */
	final KlpCommandRegistry<C> registry;
	final C Function() getContext;
	final List<KlpCommandReference> items;
	final String label;
	final String emptyLabel;
	final bool open;
	final Rect anchor;
	final ValueChanged<KlpCommandExecutionResult> onResult;
	final ValueChanged<KlpCommandPopupDismissReason> onDismiss;

	const KlpRegisteredCommandPopup({
		super.key,
		required this.registry,
		required this.getContext,
		required this.items,
		required this.label,
		required this.emptyLabel,
		required this.open,
		required this.anchor,
		required this.onResult,
		required this.onDismiss,
	});

	@override
	State<KlpRegisteredCommandPopup<C>> createState() => _CommandPopupState<C>();
}

class _CommandPopupState<C> extends State<KlpRegisteredCommandPopup<C>> with WidgetsBindingObserver {

	/* entry 擁有唯一 overlay；scope 閉合原生焦點；returnFocus 保存開啟前 owner。
	 * session 隔離過期 callback；dismissed 對同 session 的各意圖去重；scheduled 合併 build 刷新。
	 * theme/locale/direction 是本次 caller 投影，不能建立另一份風格權威。 */
	OverlayEntry? _entry;
	final _scope = FocusScopeNode(debugLabel: 'Kallopis command popup', traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);
	FocusNode? _returnFocus;
	int _session = 0;
	final _dismissed = <KlpCommandPopupDismissReason>{};
	bool _scheduled = false;
	ThemeData? _theme;
	Locale? _locale;
	TextDirection _direction = TextDirection.ltr;

	@override
	void initState() {
		super.initState();

		// 原生視窗尺寸通知只刷新此宿主，不持續安排 frame。
		WidgetsBinding.instance.addObserver(this);
	}

	@override
	void didUpdateWidget(KlpRegisteredCommandPopup<C> oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (oldWidget.open != widget.open || !identical(oldWidget.registry, widget.registry)) {
			_session++;
			_dismissed.clear();
			if (!widget.open) _remove();
		}
	}

	@override
	void didChangeMetrics() => _schedule();

	@override
	void dispose() {
		_session++;
		_remove();
		WidgetsBinding.instance.removeObserver(this);
		_scope.dispose();
		super.dispose();
	}

	void _remove() {
		final entry = _entry;
		if (entry == null) return;

		final restore = _scope.hasFocus;
		_entry = null;
		entry.remove();
		entry.dispose();
		final target = _returnFocus;
		_returnFocus = null;
		if (restore && target?.context != null && target!.canRequestFocus) target.requestFocus();
	}

	void _schedule() {
		if (_scheduled) return;

		_scheduled = true;
		void synchronize(Duration elapsed) {
			_scheduled = false;
			if (!mounted || !widget.open) return;

			if (_entry == null) {
				_returnFocus = FocusManager.instance.primaryFocus;
				_entry = OverlayEntry(builder: _overlay);
				Overlay.of(context).insert(_entry!);
			}
			else {
				_entry!.markNeedsBuild();
			}
		}

		// caller build 完成後才插入／刷新獨立 overlay，避免修改正在 build 的祖先。
		WidgetsBinding.instance.addPostFrameCallback(synchronize);
	}

	bool _current(int owner) => mounted && widget.open && owner == _session;

	void _dismiss(KlpCommandPopupDismissReason reason, int owner) {
		if (_current(owner) && _dismissed.add(reason)) widget.onDismiss(reason);
	}

	void _result(KlpCommandExecutionResult value, int owner) {
		if (!_current(owner)) return;

		widget.onResult(value);
		if (value.status == KlpCommandExecutionStatus.executed) _dismiss(KlpCommandPopupDismissReason.executed, owner);
	}

	Widget _overlay(BuildContext overlayContext) {
		final owner = _session;
		void outside() => _dismiss(KlpCommandPopupDismissReason.outside, owner);
		void escape() => _dismiss(KlpCommandPopupDismissReason.escape, owner);
		void result(KlpCommandExecutionResult value) => _result(value, owner);
		final menu = KlpRegisteredCommandMenu<C>(
			key: ValueKey(owner),
			registry: widget.registry,
			getContext: widget.getContext,
			items: widget.items,
			label: widget.label,
			emptyLabel: widget.emptyLabel,
			onResult: result,
			autoFocus: true,
			onDismiss: escape,
		);
		Widget layout(BuildContext context, BoxConstraints constraints) {
			final klp = context.klp;
			final render = overlayContext.findRenderObject();
			final origin = render is RenderBox ? render.localToGlobal(Offset.zero) : Offset.zero;
			final delegate = _PopupPlacement(
				anchor: widget.anchor.shift(-origin),
				width: klp.geometry.layout.commandMenuWidth,
				inset: klp.geometry.layout.overlayViewportInset,
				direction: _direction,
			);
			final nativeLabel = MaterialLocalizations.of(context).modalBarrierDismissLabel;
			final barrier = Semantics(
				label: nativeLabel.trim().isEmpty ? widget.label : nativeLabel,
				button: true,
				onTap: outside,
				onDismiss: outside,
				child: ExcludeSemantics(child: ModalBarrier(color: klp.color.clear, dismissible: true, onDismiss: outside)),
			);
			return Stack(children: [Positioned.fill(child: barrier), Positioned.fill(child: CustomSingleChildLayout(delegate: delegate, child: menu))]);
		}
		final content = FocusScope(node: _scope, child: LayoutBuilder(builder: layout));

		// 語意隔離必須包住 locale 容器，獨立 overlay 同時沿用最新 caller 風格及方向。
		return BlockSemantics(child: Theme(data: _theme!, child: Localizations.override(context: context, locale: _locale, child: Directionality(textDirection: _direction, child: content))));
	}

	@override
	Widget build(BuildContext context) {
		final anchor = widget.anchor;
		if (!anchor.left.isFinite || !anchor.top.isFinite || !anchor.width.isFinite || !anchor.height.isFinite || anchor.width < 0 || anchor.height < 0) throw ArgumentError.value(anchor, 'anchor', 'Expected finite coordinates and non-negative dimensions');
		if (widget.label.trim().isEmpty || widget.emptyLabel.trim().isEmpty) throw ArgumentError('label and emptyLabel must not be empty');

		_theme = Theme.of(context);
		_locale = Localizations.localeOf(context);
		_direction = Directionality.of(context);
		if (widget.open) _schedule();
		return const SizedBox.shrink();
	}
}

double _finiteLength(double value) => value.isFinite && value > 0 ? value : 0;

class _PopupPlacement extends SingleChildLayoutDelegate {

	/* anchor 已轉 overlay 座標；width/inset 是原風格偏好，僅本次量測夾入有限 viewport；direction 決定對齊邊。 */
	final Rect anchor;
	final double width;
	final double inset;
	final TextDirection direction;

	_PopupPlacement({required this.anchor, required this.width, required this.inset, required this.direction});

	double _inset(Size size) => _finiteLength(inset).clamp(0, size.shortestSide / 2).toDouble();

	double _edge(double start, double extent, double limit) {
		if (start < 0) return (start + extent).clamp(0, limit).toDouble();

		final leading = start.clamp(0, limit).toDouble();
		return leading + extent.clamp(0, limit - leading);
	}

	Rect _anchor(Size size) {
		final left = anchor.left.clamp(0, size.width).toDouble();
		final top = anchor.top.clamp(0, size.height).toDouble();

		// 先夾邊與剩餘長度再相加，巨大合法座標也不溢位。
		final right = _edge(anchor.left, anchor.width, size.width);
		final bottom = _edge(anchor.top, anchor.height, size.height);
		return Rect.fromLTRB(left, top, right, bottom);
	}

	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
		final size = Size(_finiteLength(constraints.maxWidth), _finiteLength(constraints.maxHeight));
		final padding = _inset(size);
		final rect = _anchor(size);
		final above = (rect.top - padding).clamp(0, size.height - 2 * padding).toDouble();
		final below = (size.height - padding - rect.bottom).clamp(0, size.height - 2 * padding).toDouble();
		final panelWidth = _finiteLength(width).clamp(0, size.width - 2 * padding).toDouble();
		return BoxConstraints(minWidth: panelWidth, maxWidth: panelWidth, maxHeight: above > below ? above : below);
	}

	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final padding = _inset(size);
		final rect = _anchor(size);
		final above = (rect.top - padding).clamp(0, size.height - 2 * padding).toDouble();
		final below = (size.height - padding - rect.bottom).clamp(0, size.height - 2 * padding).toDouble();
		final useBelow = childSize.height <= below || (childSize.height > above && below >= above);
		final preferredX = direction == TextDirection.ltr ? rect.left : rect.right - childSize.width;
		final x = preferredX.clamp(padding, size.width - padding - childSize.width).toDouble();
		final preferredY = useBelow ? rect.bottom : rect.top - childSize.height;
		final y = preferredY.clamp(padding, size.height - padding - childSize.height).toDouble();
		return Offset(x, y);
	}

	@override
	bool shouldRelayout(_PopupPlacement oldDelegate) => anchor != oldDelegate.anchor || width != oldDelegate.width || inset != oldDelegate.inset || direction != oldDelegate.direction;
}
