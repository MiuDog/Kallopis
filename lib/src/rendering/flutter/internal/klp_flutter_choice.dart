import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../capabilities/state/klp_subscription.dart';
import '../../../foundation/binding/internal/klp_bound_template.dart';
import 'klp_flutter_renderer.dart';
import 'klp_flutter_values.dart';

/// 選擇原語只借用狀態；焦點與訂閱隨 Flutter 放置生命週期管理。
final class KlpFlutterChoice extends StatefulWidget {

	final KlpBoundChoice content;

	const KlpFlutterChoice({required this.content, super.key});

	@override
	State<KlpFlutterChoice> createState() => _KlpFlutterChoiceState();
}

final class _KlpFlutterChoiceState extends State<KlpFlutterChoice> {

	final _focus = FocusNode();
	late KlpSubscription _subscription;
	bool _selected = false;
	bool _focused = false;

	@override
	void initState() {
		super.initState();
		_subscribe();
	}

	@override
	void didUpdateWidget(KlpFlutterChoice oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (!identical(oldWidget.content.selection, widget.content.selection) || oldWidget.content.id != widget.content.id) {
			_subscription.cancel();
			_subscribe();
		}
	}

	void _subscribe() {
		final content = widget.content;

		// 完整放置識別參與選取比對，相同本地名稱不能跨作用域命中。
		_selected = content.selection.value == content.id;
		_subscription = content.selection.subscribe((value) {
			final selected = value == widget.content.id;
			if (!mounted || selected == _selected) return;

			setState(() => _selected = selected);
		});
	}

	@override
	void dispose() {
		_subscription.cancel();
		_focus.dispose();
		super.dispose();
	}

	void _activate() {
		final callback = widget.content.onActivate;
		if (callback == null) return;

		_focus.requestFocus();
		unawaited(Future.sync(callback));
	}

	@override
	Widget build(BuildContext context) {
		final content = widget.content;
		final style = content.style;
		final enabled = content.onActivate != null;
		final background = _selected ? style.selectedBackground : style.background;
		final border = _focused ? Border.all(color: klpFlutterColor(style.focusColor), width: style.focusWidth.value) : null;
		final decoration = BoxDecoration(color: klpFlutterColor(background), borderRadius: BorderRadius.circular(style.radius.value), border: border);
		final visual = DecoratedBox(decoration: decoration, child: Center(child: KlpFlutterRenderer(content: content.child)));
		final extent = SizedBox(height: style.extent.value, width: style.extent.value, child: visual);

		// 滑鼠、鍵盤及輔助科技共用唯一啟動入口，避免重複語意與事件。
		final gesture = GestureDetector(behavior: HitTestBehavior.opaque, excludeFromSemantics: true, onTap: enabled ? _activate : null, child: extent);
		final interaction = FocusableActionDetector(
			enabled: enabled,
			focusNode: _focus,
			includeFocusSemantics: false,
			descendantsAreFocusable: false,
			descendantsAreTraversable: false,
			onFocusChange: (value) => setState(() => _focused = value),
			shortcuts: const {
				SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
				SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
			},
			actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { _activate(); return null; })},
			child: gesture,
		);
		return Semantics(
			container: true,
			button: true,
			label: content.label,
			enabled: enabled,
			selected: _selected,
			focusable: enabled,
			focused: enabled ? _focused : null,
			onTap: enabled ? _activate : null,
			excludeSemantics: true,
			child: interaction,
		);
	}
}
