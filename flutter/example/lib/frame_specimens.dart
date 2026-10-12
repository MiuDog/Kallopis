import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 每個公開target都在其合法compound中呈現，不以無關總覽作coverage。 */
const frameSpecimenNames = <String>['KlpAppFrame', 'KlpFrameGroup', 'KlpFrameGroups', 'KlpPaneCollapseControl', 'KlpPanelFooter', 'KlpPanelFrame', 'KlpPanelHeader'];

class FrameComponentSpecimen extends StatefulWidget {
	const FrameComponentSpecimen({super.key, required this.name});
	/* 當次公開元件名稱限定自己的參數控制。 */
	final String name;
	@override
	State<FrameComponentSpecimen> createState() => _FrameComponentSpecimenState();
}

class _FrameComponentSpecimenState extends State<FrameComponentSpecimen> {
	/* Controllers在同fixture保留，環境theme與width不更換此owner。 */
	final _title = TextEditingController(text: 'Frame 標題');
	final _draft = TextEditingController(text: 'Frame 草稿：切換風格仍保留');
	bool _short = false;
	bool _header = true;
	bool _footer = true;
	bool _custom = false;
	bool _leading = false;
	bool _label = false;
	bool _actions = false;
	bool _multiple = false;
	bool _collapsed = false;
	bool _disabled = false;
	bool _icon = false;
	bool _wide = false;
	bool _width = false;
	bool _largeFlex = false;
	int _tone = 0;
	int _elevation = 0;
	int _headerSize = 0;
	int _textRole = KlpTextRole.values.indexOf(KlpTextRole.header);
	int _padding = 0;
	int _divider = 0;
	int _spacing = 0;
	int _role = 0;
	int _surface = 0;
	int _actionsCount = 0;
	int _changes = 0;

	int get _appFlex {
		if (_width) return 0;
		return _largeFlex ? 3 : 1;
	}

	double? get _appPreferred {
		if (_width) return null;
		return _wide ? 200 : 120;
	}

	@override
	void dispose() {
		_title.dispose();
		_draft.dispose();
		super.dispose();
	}

	void _action() => setState(() => _actionsCount++);
	void _collapse() => setState(() { _collapsed = !_collapsed; _actionsCount++; });
	void _change(String value) => setState(() => _changes++);
	Widget _control(String label, VoidCallback onPressed) => KlpButton(label: label, onPressed: onPressed);

	List<Widget> _controls() {
		final result = <Widget>[_control('展示高度：${_short ? 120 : 280}', () => setState(() => _short = !_short))];
		switch (widget.name) {
			case 'KlpPanelFrame':
				result.addAll([
					_control('tone：${KlpPanelTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpPanelTone.values.length)),
					_control('elevation：${KlpPanelElevation.values[_elevation].name}', () => setState(() => _elevation = (_elevation + 1) % KlpPanelElevation.values.length)),
					_control('headerSize：${KlpPanelHeaderSize.values[_headerSize].name}', () => setState(() => _headerSize = (_headerSize + 1) % KlpPanelHeaderSize.values.length)),
					_control('header：$_header', () => setState(() => _header = !_header)),
					_control('footer：$_footer', () => setState(() => _footer = !_footer)),
				]);
			case 'KlpPanelHeader':
				result.addAll([
					_control('titleRole：${KlpTextRole.values[_textRole].name}', () => setState(() => _textRole = (_textRole + 1) % KlpTextRole.values.length)),
					_control('content：$_custom', () => setState(() { _custom = !_custom; if (_custom) _label = false; })),
					_control('label：$_label', () => setState(() { _label = !_label; if (_label) _custom = false; })),
					_control('leading：$_leading', () => setState(() => _leading = !_leading)),
					_control('actions：$_actions', () => setState(() => _actions = !_actions)),
				]);
			case 'KlpPanelFooter':
				result.add(_control('padding：$_padding', () => setState(() => _padding = (_padding + 1) % 3)));
			case 'KlpFrameGroup':
				result.addAll([
					_control('style.padding：${KlpFrameGroupPadding.values[_padding].name}', () => setState(() => _padding = (_padding + 1) % KlpFrameGroupPadding.values.length)),
					_control('style.divider：${KlpFrameGroupDivider.values[_divider].name}', () => setState(() => _divider = (_divider + 1) % KlpFrameGroupDivider.values.length)),
					_control('style.contentSpacing：${KlpFrameGroupContentSpacing.values[_spacing].name}', () => setState(() => _spacing = (_spacing + 1) % KlpFrameGroupContentSpacing.values.length)),
					_control('content數量：${_multiple ? 3 : 1}', () => setState(() => _multiple = !_multiple)),
				]);
			case 'KlpFrameGroups':
				result.add(_control('groups數量：${_multiple ? 3 : 1}', () => setState(() => _multiple = !_multiple)));
				result.add(_control('footer：$_footer', () => setState(() => _footer = !_footer)));
			case 'KlpAppFrame':
				result.addAll([
					_control('role：${KlpAppFrameRole.values[_role].name}', () => setState(() => _role = (_role + 1) % KlpAppFrameRole.values.length)),
					_control('surface：${KlpAppFrameSurface.values[_surface].name}', () => setState(() => _surface = (_surface + 1) % KlpAppFrameSurface.values.length)),
					_control('bounds.preferred：${_appPreferred?.toInt() ?? 'null'}', () => setState(() { _wide = !_wide; _width = false; })),
					_control('flex：$_appFlex', () => setState(() { _largeFlex = !_largeFlex; _width = false; })),
					_control('width：${_width ? 180 : 'null'}', () => setState(() => _width = !_width)),
				]);
			case 'KlpPaneCollapseControl':
				result.addAll([
					_control('collapsed：$_collapsed', () => setState(() => _collapsed = !_collapsed)),
					_control('onToggle enabled：${!_disabled}', () => setState(() => _disabled = !_disabled)),
					_control('icon：$_icon', () => setState(() => _icon = !_icon)),
				]);
		}
		return result;
	}

	Widget _draftField() => KlpTextField(label: 'Frame 內草稿', controller: _draft, onChanged: _change);
	Widget _body() => SingleChildScrollView(child: _draftField());

	KlpPanelHeader _panelHeader() => KlpPanelHeader(
		title: _custom ? null : _title.text,
		content: _custom ? KlpText(_title.text) : null,
		label: _label ? '輔助標籤' : null,
		leading: _leading ? const KlpBadge(label: 'P') : null,
		titleRole: KlpTextRole.values[_textRole],
		actions: _actions ? [KlpIconButton(icon: KlpIcons.check, label: '標頭動作', onPressed: _action)] : const [],
	);

	KlpPanelFooter _panelFooter(BuildContext context) {
		EdgeInsetsGeometry? padding;
		if (_padding == 1) padding = EdgeInsets.all(context.klp.space.contentInset);
		if (_padding == 2) padding = EdgeInsetsDirectional.only(start: context.klp.space.section, end: context.klp.space.tight);
		return KlpPanelFooter(padding: padding, child: KlpButton(label: _title.text, onPressed: _action));
	}

	KlpFrameGroup _group(bool target) {
		final style = KlpFrameGroupStyle(padding: KlpFrameGroupPadding.values[_padding], divider: KlpFrameGroupDivider.values[_divider], contentSpacing: KlpFrameGroupContentSpacing.values[_spacing]);
		return KlpFrameGroup(style: target ? style : KlpFrameGroupStyle.defaultHorizontal, content: [
			_draftField(),
			if (_multiple) KlpText(_title.text),
			if (_multiple) KlpButton(label: '群組動作', onPressed: _action),
		]);
	}

	Widget _target(BuildContext context) {
		switch (widget.name) {
			case 'KlpAppFrame':
				final frame = KlpAppFrame(role: KlpAppFrameRole.values[_role], surface: KlpAppFrameSurface.values[_surface], flex: _appFlex, width: _width ? 180 : null, bounds: KlpLayoutBounds(minimum: 40, preferred: _appPreferred, maximum: 300), child: _body());
				return KlpAppLayout(inset: KlpAppLayoutInset.none, child: LayoutRow(children: [frame, KlpLayoutPane(flex: 1, child: const KlpText('同層內容'))]));
			case 'KlpFrameGroup':
				return KlpFrameGroups(groups: [_group(true)]);
			case 'KlpFrameGroups':
				return KlpFrameGroups(groups: [_group(false), if (_multiple) KlpFrameGroup(content: const [KlpText('第二群組')]), if (_multiple) KlpFrameGroup(content: const [KlpText('第三群組')])], footer: _footer ? KlpFrameGroup(content: [KlpButton(label: '群組Footer動作', onPressed: _action)]) : null);
			case 'KlpPaneCollapseControl':
				final control = KlpPaneCollapseControl(label: _title.text, icon: _icon ? KlpIcons.check : null, collapsed: _collapsed, onToggle: _disabled ? null : _collapse);
				return KlpPanelFrame(header: KlpPanelHeader(title: 'Collapse control', actions: [control]), content: _body());
			case 'KlpPanelFooter':
				return KlpPanelFrame(content: _body(), footer: _panelFooter(context));
			case 'KlpPanelHeader':
				return KlpPanelFrame(header: _panelHeader(), content: _body());
			case 'KlpPanelFrame':
				return KlpPanelFrame(header: _header ? KlpPanelHeader(title: _title.text) : null, footer: _footer ? _panelFooter(context) : null, tone: KlpPanelTone.values[_tone], elevation: KlpPanelElevation.values[_elevation], headerSize: KlpPanelHeaderSize.values[_headerSize], content: _body());
			default:
				throw StateError('未註冊的Frame target：${widget.name}');
		}
	}

	String _usage() => switch (widget.name) {
		'KlpAppFrame' => 'KlpAppLayout(child: LayoutRow(children: [KlpAppFrame(role: role, surface: surface, bounds: bounds, flex: flex, width: width, child: content), sibling]))',
		'KlpFrameGroup' => 'KlpFrameGroups(groups: [KlpFrameGroup(style: style, content: content)])',
		'KlpFrameGroups' => 'KlpFrameGroups(groups: groups, footer: footer)',
		'KlpPaneCollapseControl' => 'KlpPaneCollapseControl(label: label, icon: icon, collapsed: collapsed, onToggle: enabled ? onToggle : null)',
		'KlpPanelFooter' => 'KlpPanelFrame(content: content, footer: KlpPanelFooter(padding: padding, child: action))',
		'KlpPanelHeader' => 'KlpPanelFrame(header: KlpPanelHeader(title: title, content: customContent, label: label, leading: leading, actions: actions, titleRole: role), content: content)',
		'KlpPanelFrame' => 'KlpPanelFrame(header: header, content: content, footer: footer, tone: tone, elevation: elevation, headerSize: size)',
		_ => '',
	};

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls()),
			SizedBox(height: space.contentStackGap),
			KlpTextField(label: '標題／child標籤', controller: _title, onChanged: (value) => setState(() {})),
			SizedBox(height: space.contentStackGap),
			SizedBox(height: _short ? 120 : 280, child: _target(context)),
			KlpText('原生動作：$_actionsCount；正文輸入變更：$_changes', role: KlpTextRole.code),
			KlpText(_usage(), role: KlpTextRole.code),
		]);
	}
}
