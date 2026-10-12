import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 每個名稱只展示自己的公開 constructor，不以其他元件補 coverage。 */
const foundationDetailSpecimenNames = <String>['KlpIcon', 'KlpInlineCode', 'KlpRichText', 'KlpShortcutHint', 'KlpDashedBorder', 'KlpDashedDivider', 'KlpGeometricSpinner', 'KlpPresenceIndicator', 'KlpSegmentedProgress', 'KlpStrokeFrame'];

class FoundationDetailComponentSpecimen extends StatefulWidget {

	/* name：自己的公開 target 路由，環境更新不重設內部資料。 */
	final String name;
	const FoundationDetailComponentSpecimen({super.key, required this.name});
	@override
	State<FoundationDetailComponentSpecimen> createState() => _FoundationDetailComponentSpecimenState();
}

class _FoundationDetailComponentSpecimenState extends State<FoundationDetailComponentSpecimen> {

	/*
	 * _text：公開文字／label／semanticLabel；_draft：框線 child 原生草稿。
	 * _override：可選用幾何參數；_color：可選用語意顏色；_opacity：虛線透明度。
	 * _flag：自己的 weight／active／vertical／selectable；_extra：icon／rich nodes 分支。
	 * _unsafe／_missing：rich node 公開狀態；_enabled：原 rich callback 是否提供。
	 * _role／_state：stroke 公開 enum；_duration：spinner 週期並明示重建；_segments／_value：合法進度。
	 * _rootCalls／_childCalls／_inputs／_edits：實際 root、child、input、控制文字分開。
	 * _result：最後一次原回呼結果，不把控制參數變更當元件回呼。
	 */
	final _text = TextEditingController(text: '細節展示');
	final _draft = TextEditingController(text: '框線內容草稿');
	bool _override = false;
	bool _color = false;
	bool _opacity = false;
	bool _flag = false;
	bool _extra = false;
	bool _unsafe = false;
	bool _missing = false;
	bool _enabled = true;
	int _role = 0;
	int _state = 0;
	int _duration = 0;
	int _segments = 4;
	double _value = .25;
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發回呼';

	@override
	void dispose() { _text.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _openLink(String value) => setState(() { _rootCalls++; _result = 'onOpenLink：$value'; });
	void _openMention(String value) => setState(() { _rootCalls++; _result = 'onOpenMention：$value'; });
	Widget _control(String label, VoidCallback callback) => KlpButton(label: label, onPressed: callback);
	Widget _overrideControl() => _control('幾何 override：$_override', () => setState(() => _override = !_override));
	Widget _colorControl() => _control('color override：$_color', () => setState(() => _color = !_color));
	Widget _opacityControl() => _control('opacity：${_opacity ? .4 : 'null'}', () => setState(() => _opacity = !_opacity));

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpIcon': return [_control('weight：${_flag ? 'thin' : 'regular'}', () => setState(() => _flag = !_flag)), _control('icon：${_extra ? 'folder' : 'check'}', () => setState(() => _extra = !_extra)), _overrideControl(), _colorControl()];
			case 'KlpInlineCode': return [_overrideControl(), _colorControl()];
			case 'KlpRichText': return [_control('nodes：$_extra', () => setState(() => _extra = !_extra)), _control('selectable：$_flag', () => setState(() => _flag = !_flag)), _control('unsafe：$_unsafe', () => setState(() => _unsafe = !_unsafe)), _control('missing：$_missing', () => setState(() => _missing = !_missing)), _control('callback：$_enabled', () => setState(() => _enabled = !_enabled)), _colorControl()];
			case 'KlpShortcutHint': return const [];
			case 'KlpPresenceIndicator': return [_control('active：$_flag', () => setState(() => _flag = !_flag))];
			case 'KlpDashedDivider': return [_control('vertical：$_flag', () => setState(() => _flag = !_flag)), _overrideControl(), _colorControl(), _opacityControl()];
			case 'KlpDashedBorder': return [_overrideControl(), _colorControl(), _opacityControl()];
			case 'KlpGeometricSpinner': return [_overrideControl(), _colorControl(), _control('duration（重建 target）：${_duration == 0 ? 'null' : '2400ms'}', () => setState(() => _duration = 1 - _duration))];
			case 'KlpSegmentedProgress': return [_control('value：$_value', () => setState(() => _value = (_value + .25) % 1.25)), _control('segments：$_segments', () => setState(() => _segments = _segments == 4 ? 8 : 4))];
			case 'KlpStrokeFrame': return [_control('role：${KlpStrokeRole.values[_role].name}', () => setState(() => _role = (_role + 1) % KlpStrokeRole.values.length)), _control('state：${KlpStrokeState.values[_state].name}', () => setState(() => _state = (_state + 1) % KlpStrokeState.values.length)), _overrideControl(), _colorControl(), _opacityControl()];
			default: return const [];
		}
	}

	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText(_text.text), KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '框線 child 動作', onPressed: _childAction)]);
	Widget _rich(BuildContext context) => KlpRichText(
		spans: [KlpRichTextSpan(text: '${_text.text} 一般 '), KlpRichTextSpan(text: '加粗文字', strong: true, color: _color ? context.klp.color.accent : null)],
		nodes: _extra ? [KlpRichTextNode(text: '${_text.text} 節點 '), const KlpRichTextNode(kind: KlpRichTextKind.code, text: 'inline code'), const KlpRichTextNode(text: ' '), KlpRichTextNode(kind: KlpRichTextKind.link, text: '展示連結', label: '展示連結', href: 'https://example.com', unsafe: _unsafe), const KlpRichTextNode(text: ' '), KlpRichTextNode(kind: KlpRichTextKind.mention, text: '展示成員', label: '展示成員', href: 'member-demo', missing: _missing)] : const [],
		selectable: _flag,
		onOpenLink: _enabled ? _openLink : null,
		onOpenMention: _enabled ? _openMention : null,
	);
	Widget _target(BuildContext context) {
		final klp = context.klp;
		final color = _color ? klp.color.accent : null;
		final radius = _override ? klp.shape.control * 2 : null;
		final width = _override ? klp.shape.hairline * 2 : null;
		final dash = _override ? klp.shape.dashedLength * 2 : null;
		final gap = _override ? klp.shape.dashedGap * 2 : null;
		final opacity = _opacity ? .4 : null;
		switch (widget.name) {
			case 'KlpIcon': return KlpIcon(_extra ? KlpIcons.folder : KlpIcons.check, size: _override ? klp.space.iconLarge * 2 : null, color: color, semanticLabel: _text.text, weight: _flag ? KlpIconWeight.thin : KlpIconWeight.regular);
			case 'KlpInlineCode': return KlpInlineCode(_text.text, color: color, backgroundColor: _color ? klp.color.surfaceRaised : null, fontSize: _override ? klp.type.sub * 1.5 : null, radius: radius);
			case 'KlpRichText': return _rich(context);
			case 'KlpShortcutHint': return KlpShortcutHint(label: _text.text);
			case 'KlpPresenceIndicator': return KlpPresenceIndicator(label: _text.text, active: _flag);
			case 'KlpSegmentedProgress': return KlpSegmentedProgress(value: _value, segments: _segments);
			case 'KlpDashedBorder': return KlpDashedBorder(color: color, radius: radius, width: width, dashLength: dash, gapLength: gap, opacity: opacity, child: _child());
			case 'KlpDashedDivider': return SizedBox(height: 160, child: KlpDashedDivider(vertical: _flag, width: width, color: color, dashLength: dash, gapLength: gap, opacity: opacity));
			case 'KlpStrokeFrame': return KlpStrokeFrame(role: KlpStrokeRole.values[_role], state: KlpStrokeState.values[_state], color: color, radius: radius, width: width, dashLength: dash, gapLength: gap, opacity: opacity, child: _child());
			case 'KlpGeometricSpinner': return Align(alignment: Alignment.topLeft, child: KlpGeometricSpinner(key: ValueKey(_duration), size: _override ? klp.space.iconLarge * 2 : null, color: color, contrastColor: _color ? klp.color.text : null, duration: _duration == 0 ? null : const Duration(milliseconds: 2400)));
			default: return KlpText('未知細節展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpIcon': return 'KlpIcon(icon, size: size, color: color, semanticLabel: label, weight: weight)';
			case 'KlpInlineCode': return 'KlpInlineCode(text, color: color, backgroundColor: backgroundColor, fontSize: fontSize, radius: radius)';
			case 'KlpRichText': return 'KlpRichText(spans: spans, nodes: nodes, selectable: selectable, onOpenLink: onOpenLink, onOpenMention: onOpenMention)';
			case 'KlpShortcutHint': return 'KlpShortcutHint(label: label)';
			case 'KlpPresenceIndicator': return 'KlpPresenceIndicator(label: label, active: active)';
			case 'KlpSegmentedProgress': return 'KlpSegmentedProgress(value: value, segments: segments)';
			case 'KlpDashedBorder': return 'KlpDashedBorder(child: child, color: color, radius: radius, width: width, dashLength: dash, gapLength: gap, opacity: opacity)';
			case 'KlpDashedDivider': return 'KlpDashedDivider(vertical: vertical, width: width, color: color, dashLength: dash, gapLength: gap, opacity: opacity)';
			case 'KlpStrokeFrame': return 'KlpStrokeFrame(role: role, child: child, state: state, color: color, radius: radius, width: width, dashLength: dash, gapLength: gap, opacity: opacity)';
			case 'KlpGeometricSpinner': return 'KlpGeometricSpinner(size: size, color: color, contrastColor: contrastColor, duration: duration)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		if (!['KlpDashedDivider', 'KlpGeometricSpinner', 'KlpSegmentedProgress'].contains(widget.name)) KlpTextField(controller: _text, placeholder: '公開 text／label／semanticLabel 或 child 內容', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target(context))),
		KlpText('root 回呼：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText('最後回呼結果：$_result'),
		if (widget.name == 'KlpRichText') const KlpText('非空 nodes 優先於 spans；連結與 mention 只記錄公開回呼，不開外部網站。'),
		if (widget.name == 'KlpShortcutHint') const KlpText('提示文字不註冊快捷鍵；命令註冊另見 registered 元件頁。'),
		if (widget.name == 'KlpSegmentedProgress') KlpText('consumer value：$_value；segments：$_segments'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
