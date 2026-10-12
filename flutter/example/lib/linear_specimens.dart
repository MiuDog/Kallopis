import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 名稱對應真正公開class，不以其他框架命名推導。 */
const linearSpecimenNames = <String>['KlpAppLayout', 'KlpLayoutDivider', 'KlpLayoutPane', 'LayoutColumn', 'LayoutRow', 'LayoutSpacer'];

class LinearComponentSpecimen extends StatefulWidget {
	const LinearComponentSpecimen({super.key, required this.name});
	/* 當次target決定自身controls及合法compound。 */
	final String name;
	@override
	State<LinearComponentSpecimen> createState() => _LinearComponentSpecimenState();
}

class _LinearComponentSpecimenState extends State<LinearComponentSpecimen> {
	/* Consumer保存draft與展示參數，庫仍是唯一尺寸分配owner。 */
	final _draft = TextEditingController(text: '布局草稿：風格切換保留');
	bool _short = false;
	bool _largeMinimum = false;
	bool _largePreferred = false;
	bool _largeMaximum = false;
	bool _largeFlex = false;
	bool _automaticFlex = false;
	bool _vertical = false;
	bool _floating = false;
	int _alignment = 0;
	int _spacing = 0;
	int _paneSize = 0;
	int _inset = 0;
	int _count = 0;

	KlpLayoutBounds get _bounds => KlpLayoutBounds(minimum: _largeMinimum ? 100 : 40, preferred: _largePreferred ? 180 : 100, maximum: _largeMaximum ? 300 : 220);
	int get _flex => _largeFlex ? 3 : 1;

	@override
	void dispose() {
		_draft.dispose();
		super.dispose();
	}

	void _record() => setState(() => _count++);
	Widget _cycle(String label, VoidCallback onPressed) => KlpButton(label: label, onPressed: onPressed);

	List<Widget> _controls() {
		final controls = <Widget>[_cycle('展示高度：${_short ? 120 : 280}', () => setState(() => _short = !_short))];
		if (widget.name == 'KlpAppLayout') {
			controls.add(_cycle('inset：${KlpAppLayoutInset.values[_inset].name}', () => setState(() => _inset = (_inset + 1) % KlpAppLayoutInset.values.length)));
			controls.add(_cycle('floatingAction：$_floating', () => setState(() => _floating = !_floating)));
			return controls;
		}
		if (widget.name == 'KlpLayoutDivider') {
			controls.add(_cycle('宿主方向：${_vertical ? 'column' : 'row'}', () => setState(() => _vertical = !_vertical)));
			return controls;
		}
		controls.addAll([
			_cycle('minimum：${_bounds.minimum.toInt()}', () => setState(() => _largeMinimum = !_largeMinimum)),
			_cycle('preferred：${_bounds.preferred!.toInt()}', () => setState(() => _largePreferred = !_largePreferred)),
			_cycle('maximum：${_bounds.maximum!.toInt()}', () => setState(() => _largeMaximum = !_largeMaximum)),
			_cycle('flex：$_flex', () => setState(() => _largeFlex = !_largeFlex)),
		]);
		if (widget.name == 'KlpLayoutPane') {
			controls.add(_cycle('flex自動：$_automaticFlex', () => setState(() => _automaticFlex = !_automaticFlex)));
			controls.add(_cycle('size：${KlpLayoutPaneSize.values[_paneSize].name}', () => setState(() => _paneSize = (_paneSize + 1) % KlpLayoutPaneSize.values.length)));
		}
		if (widget.name == 'LayoutRow' || widget.name == 'LayoutColumn') {
			controls.add(_cycle('alignment：${KlpLayoutMainAlignment.values[_alignment].name}', () => setState(() => _alignment = (_alignment + 1) % KlpLayoutMainAlignment.values.length)));
			controls.add(_cycle('spacing：${KlpLayoutSpacing.values[_spacing].name}', () => setState(() => _spacing = (_spacing + 1) % KlpLayoutSpacing.values.length)));
		}
		return controls;
	}

	Widget _paneContent(String label, bool editable) {
		return LayoutBuilder(builder: (context, constraints) => KlpSurface(
			tone: KlpSurfaceTone.raised,
			padding: EdgeInsets.all(context.klp.space.tight),
			child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
				KlpText('$label：${constraints.maxWidth.toStringAsFixed(1)} × ${constraints.maxHeight.toStringAsFixed(1)}', role: KlpTextRole.caption),
				if (editable) KlpTextField(label: '布局內草稿', controller: _draft, onChanged: (value) => _record()),
			])),
		));
	}

	KlpLayoutPane _pane(String label, bool editable) => KlpLayoutPane(flex: 1, child: _paneContent(label, editable));
	KlpLayoutPane _fixedPane(String label, bool editable) => KlpLayoutPane(flex: 0, bounds: const KlpLayoutBounds(minimum: 20, preferred: 50, maximum: 60), child: _paneContent(label, editable));

	KlpLayoutNode _node() {
		final first = _pane('A 實際槽', true);
		final last = _pane('B 實際槽', false);
		switch (widget.name) {
			case 'KlpLayoutPane':
				return LayoutRow(children: [KlpLayoutPane(bounds: _bounds, flex: _automaticFlex ? null : _flex, size: KlpLayoutPaneSize.values[_paneSize], child: _paneContent('target實際槽', true)), last]);
			case 'LayoutSpacer':
				return LayoutRow(children: [first, LayoutSpacer(bounds: _bounds, flex: _flex), last]);
			case 'KlpLayoutDivider':
				final children = <KlpLayoutNode>[first, const KlpLayoutDivider(), last];
				return _vertical ? LayoutColumn(children: children) : LayoutRow(children: children);
			case 'LayoutRow':
				final target = LayoutRow(bounds: _bounds, flex: _flex, alignment: KlpLayoutMainAlignment.values[_alignment], spacing: KlpLayoutSpacing.values[_spacing], children: [_fixedPane('A 實際槽', true), _fixedPane('B 實際槽', false)]);
				return LayoutRow(children: [target, _pane('同層槽', false)]);
			case 'LayoutColumn':
				final target = LayoutColumn(bounds: _bounds, flex: _flex, alignment: KlpLayoutMainAlignment.values[_alignment], spacing: KlpLayoutSpacing.values[_spacing], children: [_fixedPane('A 實際槽', true), _fixedPane('B 實際槽', false)]);
				return LayoutColumn(children: [target, _pane('同層槽', false)]);
			case 'KlpAppLayout':
				return LayoutRow(children: [first, const KlpLayoutDivider(), last]);
			default:
				throw StateError('未註冊的linear target：${widget.name}');
		}
	}

	String _usage() => switch (widget.name) {
		'KlpAppLayout' => 'KlpAppLayout(inset: inset, child: layout, floatingAction: action)',
		'KlpLayoutPane' => 'KlpLayoutPane(bounds: bounds, flex: flex, size: size, child: content)',
		'KlpLayoutDivider' => 'LayoutRow(children: [paneA, const KlpLayoutDivider(), paneB])\nDivider無手勢；改宿主方向觀察合法分隔。',
		'LayoutSpacer' => 'LayoutRow(children: [paneA, LayoutSpacer(bounds: bounds, flex: flex), paneB])',
		'LayoutRow' => 'LayoutRow(bounds: bounds, flex: flex, alignment: alignment, spacing: spacing, children: children)',
		'LayoutColumn' => 'LayoutColumn(bounds: bounds, flex: flex, alignment: alignment, spacing: spacing, children: children)',
		_ => '',
	};

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final inset = widget.name == 'KlpAppLayout' ? KlpAppLayoutInset.values[_inset] : KlpAppLayoutInset.none;
		Widget? action;
		if (widget.name == 'KlpAppLayout' && _floating) action = KlpIconButton(icon: KlpIcons.check, label: '浮動動作', onPressed: _record);
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls()),
			SizedBox(height: space.contentStackGap),
			SizedBox(height: _short ? 120 : 280, child: KlpAppLayout(inset: inset, floatingAction: action, child: _node())),
			SizedBox(height: space.contentStackGap),
			KlpText('原生callback次數：$_count；槽尺寸來自實際LayoutBuilder', role: KlpTextRole.caption),
			KlpText(_usage(), role: KlpTextRole.code),
		]);
	}
}
