import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 真實公開原語的獨立 target；原生行為由庫擁有。 */
const interactionPrimitiveSpecimenNames = <String>['KlpSemanticRegion', 'KlpExcludeSemantics', 'KlpFocusRegion', 'KlpGestureRegion', 'KlpPointerBlocker', 'KlpPressable', 'KlpStateHighlight', 'KlpVeil', 'KlpActionRegion'];

class InteractionPrimitiveComponentSpecimen extends StatefulWidget {

	/* name：自己的公開元件名稱，避免退回無關的總覽。 */
	final String name;
	const InteractionPrimitiveComponentSpecimen({super.key, required this.name});
	@override
	State<InteractionPrimitiveComponentSpecimen> createState() => _InteractionPrimitiveComponentSpecimenState();
}

class _InteractionPrimitiveComponentSpecimenState extends State<InteractionPrimitiveComponentSpecimen> {

	/*
	 * _label／_value：公開label/value或裝飾child內容；_draft：真正子輸入狀態；_focus：consumer focusNode。
	 * _enabled：公開回呼可選用；_flag／_extra：自己的bool props；_radius：semantic推導的nullable radius。
	 * _nullable／_focusable：語意與action nullable props的三態；_container／_explicit：semantic組裝。
	 * _tone／_shape／_state／_behavior：各target的公開enum索引。
	 * _rootCalls／_childCalls／_inputs／_edits：原元件、子動作、子輸入與控制文字計數。
	 * _hovers／_focusChanges／_hovered／_focused：原pressable狀態回呼；_dx／_dy：pan原位移累計。
	 * _result：最後實際回呼結果，控制變更不冒充回呼。
	 */
	final _label = TextEditingController(text: '原語內容');
	final _value = TextEditingController(text: 'region value');
	final _draft = TextEditingController(text: '原語 child 草稿');
	final _focus = FocusNode();
	bool _enabled = true;
	bool _flag = false;
	bool _extra = false;
	bool _radius = false;
	bool _container = true;
	bool _explicit = false;
	int _nullable = 0;
	int _focusable = 0;
	int _tone = 0;
	int _shape = 0;
	int _state = 0;
	int _behavior = 0;
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	int _hovers = 0;
	int _focusChanges = 0;
	bool _hovered = false;
	bool _focused = false;
	double _dx = 0;
	double _dy = 0;
	String _result = '尚未觸發原事件';

	bool? _boolValue(int index) { if (index == 0) return null; return index == 1; }
	@override
	void dispose() { _label.dispose(); _value.dispose(); _draft.dispose(); _focus.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _root(String event) => setState(() { _rootCalls++; _result = event; });
	void _hover(bool value) => setState(() { _hovers++; _hovered = value; });
	void _focusChanged(bool value) => setState(() { _focusChanges++; _focused = value; });
	void _pan(DragUpdateDetails details) => setState(() { _dx += details.delta.dx; _dy += details.delta.dy; _rootCalls++; _result = 'onPanUpdate'; });
	KeyEventResult _key(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.f2) return KeyEventResult.ignored;
		_root('onKeyEvent：F2');
		return KeyEventResult.handled;
	}
	Widget _control(String label, VoidCallback callback) => KlpButton(label: label, onPressed: callback);
	Widget _callbackControl() => _control('callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _radiusControl() => _control('borderRadius override：$_radius', () => setState(() => _radius = !_radius));

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpSemanticRegion': return [_control('enabled：${_boolValue(_nullable)}', () => setState(() => _nullable = (_nullable + 1) % 3)), _control('focusable：${_boolValue(_focusable)}', () => setState(() => _focusable = (_focusable + 1) % 3)), _control('container：$_container', () => setState(() => _container = !_container)), _control('explicitChildNodes：$_explicit', () => setState(() => _explicit = !_explicit)), _control('value=null：$_flag', () => setState(() => _flag = !_flag))];
			case 'KlpExcludeSemantics': return [_control('child：${_extra ? 'icon' : 'text'}', () => setState(() => _extra = !_extra))];
			case 'KlpFocusRegion': return [_control('autofocus（重建 target）：$_flag', () => setState(() => _flag = !_flag)), _callbackControl(), _control('要求 region 焦點', _focus.requestFocus)];
			case 'KlpGestureRegion': return [_callbackControl(), _control('behavior：${_behavior == 0 ? 'null' : HitTestBehavior.values[_behavior - 1].name}', () => setState(() => _behavior = (_behavior + 1) % (HitTestBehavior.values.length + 1)))];
			case 'KlpPointerBlocker': return [_control('blocking：$_flag', () => setState(() => _flag = !_flag))];
			case 'KlpPressable': return [_callbackControl(), _control('selected：$_flag', () => setState(() => _flag = !_flag)), _control('hoverHighlight：${!_extra}', () => setState(() => _extra = !_extra)), _radiusControl()];
			case 'KlpStateHighlight': return [_control('state：${KlpHighlightState.values[_state].name}', () => setState(() => _state = (_state + 1) % KlpHighlightState.values.length)), _radiusControl()];
			case 'KlpVeil': return [_control('child：${_extra ? 'icon' : 'text'}', () => setState(() => _extra = !_extra))];
			case 'KlpActionRegion': return [_callbackControl(), _control('tone：${KlpActionRegionTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpActionRegionTone.values.length)), _control('shape：${KlpActionRegionShape.values[_shape].name}', () => setState(() => _shape = (_shape + 1) % KlpActionRegionShape.values.length)), _control('selected：$_flag', () => setState(() => _flag = !_flag)), _control('active：$_extra', () => setState(() => _extra = !_extra)), _control('toggled：${_boolValue(_nullable)}', () => setState(() => _nullable = (_nullable + 1) % 3)), _control('expanded：${_boolValue(_focusable)}', () => setState(() => _focusable = (_focusable + 1) % 3))];
			default: return const [];
		}
	}

	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText(_label.text), KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '原語 child 動作', onPressed: _childAction)]);
	Widget _decoration() => _extra ? KlpIcon(KlpIcons.folder, semanticLabel: _label.text) : KlpText(_label.text);
	Widget _gesture() => KlpGestureRegion(
		behavior: _behavior == 0 ? null : HitTestBehavior.values[_behavior - 1],
		onTap: _enabled ? () => _root('onTap') : null,
		onDoubleTap: _enabled ? () => _root('onDoubleTap') : null,
		onSecondaryTap: _enabled ? () => _root('onSecondaryTap') : null,
		onSecondaryTapDown: _enabled ? (details) => _root('onSecondaryTapDown：${details.localPosition}') : null,
		onPanStart: _enabled ? (details) => _root('onPanStart') : null,
		onPanUpdate: _enabled ? _pan : null,
		onPanEnd: _enabled ? (details) => _root('onPanEnd') : null,
		child: SizedBox(height: 200, width: double.infinity, child: KlpSurface(child: Center(child: KlpText(_label.text)))),
	);
	Widget _target(BuildContext context) {
		final borderRadius = _radius ? BorderRadius.circular(context.klp.shape.control * 2) : null;
		switch (widget.name) {
			case 'KlpSemanticRegion': return KlpSemanticRegion(label: _label.text, value: _flag ? null : _value.text, enabled: _boolValue(_nullable), focusable: _boolValue(_focusable), container: _container, explicitChildNodes: _explicit, child: _child());
			case 'KlpExcludeSemantics': return KlpExcludeSemantics(child: _decoration());
			case 'KlpFocusRegion': return KlpFocusRegion(key: ValueKey(_flag), autofocus: _flag, focusNode: _focus, onKeyEvent: _enabled ? _key : null, child: _child());
			case 'KlpGestureRegion': return _gesture();
			case 'KlpPointerBlocker': return KlpPointerBlocker(blocking: _flag, child: _child());
			case 'KlpPressable': return KlpPressable(onPressed: _enabled ? () => _root('onPressed') : null, onLongPress: _enabled ? () => _root('onLongPress') : null, onHover: _hover, onFocusChange: _focusChanged, selected: _flag, hoverHighlight: !_extra, borderRadius: borderRadius, longPressProgressColor: _radius ? context.klp.color.accent : null, child: SizedBox(height: 120, child: Center(child: KlpText(_label.text))));
			case 'KlpStateHighlight': return KlpStateHighlight(state: KlpHighlightState.values[_state], borderRadius: borderRadius, child: _child());
			case 'KlpVeil': return SizedBox(height: 160, child: KlpVeil(child: Center(child: _decoration())));
			case 'KlpActionRegion': return KlpActionRegion(label: _label.text, onPressed: _enabled ? () => _root('onPressed') : null, tone: KlpActionRegionTone.values[_tone], selected: _flag, active: _extra, toggled: _boolValue(_nullable), expanded: _boolValue(_focusable), shape: KlpActionRegionShape.values[_shape], builder: (context, style) => Padding(padding: EdgeInsets.all(context.klp.space.contentInset), child: KlpText(_label.text, color: style.foreground)));
			default: return KlpText('未知原語展示：${widget.name}');
		}
	}
	String _usage() {
		switch (widget.name) {
			case 'KlpSemanticRegion': return 'KlpSemanticRegion(label: label, child: child, value: value, enabled: enabled, focusable: focusable, container: container, explicitChildNodes: explicitChildNodes)';
			case 'KlpExcludeSemantics': return 'KlpExcludeSemantics(child: decorativeChild)';
			case 'KlpFocusRegion': return 'KlpFocusRegion(child: child, autofocus: autofocus, focusNode: focusNode, onKeyEvent: onKeyEvent)';
			case 'KlpGestureRegion': return 'KlpGestureRegion(child: child, behavior: behavior, onTap: onTap, onDoubleTap: onDoubleTap, onSecondaryTap: onSecondaryTap, onSecondaryTapDown: onSecondaryTapDown, onPanStart: onPanStart, onPanUpdate: onPanUpdate, onPanEnd: onPanEnd)';
			case 'KlpPointerBlocker': return 'KlpPointerBlocker(blocking: blocking, child: child)';
			case 'KlpPressable': return 'KlpPressable(child: child, onPressed: onPressed, onLongPress: onLongPress, onHover: onHover, onFocusChange: onFocusChange, selected: selected, hoverHighlight: hoverHighlight, borderRadius: borderRadius, longPressProgressColor: color)';
			case 'KlpStateHighlight': return 'KlpStateHighlight(state: state, child: child, borderRadius: borderRadius)';
			case 'KlpVeil': return 'KlpVeil(child: child)';
			case 'KlpActionRegion': return 'KlpActionRegion(label: label, onPressed: onPressed, builder: builder, tone: tone, selected: selected, active: active, toggled: toggled, expanded: expanded, shape: shape)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _label, placeholder: '公開 label／child 文字', onChanged: _edit),
		if (widget.name == 'KlpSemanticRegion') KlpTextField(controller: _value, placeholder: '公開 value', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target(context))),
		KlpText('root 事件：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText('hover：$_hovered（$_hovers）；focus：$_focused（$_focusChanges）；pan：${_dx.toStringAsFixed(1)},${_dy.toStringAsFixed(1)}'),
		KlpText('最後回呼結果：$_result'),
		if (widget.name == 'KlpFocusRegion') const KlpText('在 child 輸入內按 F2；原 onKeyEvent 只處理 F2 KeyDown。'),
		if (widget.name == 'KlpGestureRegion') const KlpText('在命中區單擊／雙擊／次要按鍵／拖曳；各原回呼分開顯示。'),
		if (widget.name == 'KlpExcludeSemantics') const KlpText('裝飾內容仍繪製，但不放入可及性語意樹；child 沒有互動控件。'),
		if (widget.name == 'KlpSemanticRegion') const KlpText('enabled/focusable 是語意屬性；指標阻擋另見 KlpPointerBlocker。'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
