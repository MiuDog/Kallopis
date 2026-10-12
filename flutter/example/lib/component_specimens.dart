import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'linear_specimens.dart';
import 'explorer_specimens.dart';
import 'frame_specimens.dart';
import 'spatial_specimens.dart';
import 'form_control_specimens.dart';
import 'feedback_specimens.dart';
import 'content_collection_specimens.dart';
import 'progress_collection_specimens.dart';
import 'data_collection_specimens.dart';
import 'viewer_collection_specimens.dart';
import 'navigation_selection_specimens.dart';
import 'navigation_compound_specimens.dart';
import 'action_utility_specimens.dart';
import 'foundation_detail_specimens.dart';
import 'interaction_primitive_specimens.dart';
import 'layout_utility_specimens.dart';
import 'catalog/registered_commands_page.dart';

/* 只有真實target fixture可以進此清單；不是全量覆蓋宣告。 */
const flutterSpecimenNames = <String>['KlpBadge', 'KlpButton', 'KlpIconButton', 'KlpSurface', 'KlpText', 'KlpTextField', ...linearSpecimenNames, ...explorerSpecimenNames, ...frameSpecimenNames, ...commandSpecimenNames, ...spatialSpecimenNames, ...formControlSpecimenNames, ...feedbackSpecimenNames, ...contentCollectionSpecimenNames, ...progressCollectionSpecimenNames, ...dataCollectionSpecimenNames, ...viewerCollectionSpecimenNames, ...navigationSelectionSpecimenNames, ...navigationCompoundSpecimenNames, ...actionUtilitySpecimenNames, ...foundationDetailSpecimenNames, ...interactionPrimitiveSpecimenNames, ...layoutUtilitySpecimenNames];

class ComponentSpecimenApp extends StatefulWidget {
	const ComponentSpecimenApp({super.key, required this.name});
	/* 公開名稱直接來自query，不以舊Catalog coverage補未知route。 */
	final String name;
	@override
	State<ComponentSpecimenApp> createState() => _ComponentSpecimenAppState();
}

class _ComponentSpecimenAppState extends State<ComponentSpecimenApp> {
	/* 展示環境與fixture資料分離，只有epoch明確重建產品狀態。 */
	KlpThemeVariant _mode = KlpThemeVariant.light;
	bool _alternate = false;
	bool _narrow = false;
	int _epoch = 0;
	final _base = KlpStylePack.defaults();
	late final _spacious = _base.applyOverrides({
		'semantics': {
			'theme.spacing.contentStackGap': {for (final mode in KlpThemeVariant.values) mode.name: 'p(space600)'},
			'theme.spacing.actionGap': {for (final mode in KlpThemeVariant.values) mode.name: 'p(space300)'},
		},
	});

	@override
	Widget build(BuildContext context) {
		final pack = _alternate ? _spacious : _base;
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: '${widget.name} — Kallopis',
			theme: buildKlpThemeVariant(_mode, stylePack: pack),
			home: Material(child: Builder(builder: _content)),
		);
	}

	Widget _content(BuildContext context) {
		final space = context.klp.space;
		if (!flutterSpecimenNames.contains(widget.name)) {
			return Center(child: KlpText('未完成或未知的元件展示：${widget.name}'));
		}
		return SafeArea(child: SingleChildScrollView(child: Padding(
			padding: EdgeInsets.all(space.contentInset),
			child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
				KlpText(widget.name, role: KlpTextRole.section),
				KlpText(actionUtilityExperimentalSpecimenNames.contains(widget.name) ? '公開入口：package:kallopis/kallopis_experimental.dart' : '公開入口：package:kallopis/kallopis_foundation.dart', role: KlpTextRole.code),
				SizedBox(height: space.contentStackGap),
				Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: [
					for (final mode in KlpThemeVariant.values) KlpButton(label: mode.name, selected: _mode == mode, onPressed: () => setState(() => _mode = mode)),
					KlpButton(label: _alternate ? '風格：寬鬆' : '風格：預設', selected: _alternate, onPressed: () => setState(() => _alternate = !_alternate)),
					KlpButton(label: _narrow ? '測量寬度：320' : '測量寬度：760', selected: _narrow, onPressed: () => setState(() => _narrow = !_narrow)),
					KlpButton(label: '重設元件', onPressed: () => setState(() => _epoch++)),
				]),
				SizedBox(height: space.contentStackGap),
				LayoutBuilder(builder: (context, constraints) => SizedBox(
					width: (_narrow ? 320.0 : 760.0).clamp(0.0, constraints.maxWidth),
					child: _fixture(),
				)),
			]),
		)));
	}

	Widget _fixture() {
		final key = ValueKey(_epoch);
		if (layoutUtilitySpecimenNames.contains(widget.name)) return LayoutUtilityComponentSpecimen(key: key, name: widget.name);
		if (interactionPrimitiveSpecimenNames.contains(widget.name)) return InteractionPrimitiveComponentSpecimen(key: key, name: widget.name);
		if (foundationDetailSpecimenNames.contains(widget.name)) return FoundationDetailComponentSpecimen(key: key, name: widget.name);
		if (actionUtilitySpecimenNames.contains(widget.name)) return ActionUtilityComponentSpecimen(key: key, name: widget.name);
		if (navigationCompoundSpecimenNames.contains(widget.name)) return NavigationCompoundComponentSpecimen(key: key, name: widget.name);
		if (navigationSelectionSpecimenNames.contains(widget.name)) return NavigationSelectionComponentSpecimen(key: key, name: widget.name);
		if (viewerCollectionSpecimenNames.contains(widget.name)) return ViewerCollectionComponentSpecimen(key: key, name: widget.name);
		if (dataCollectionSpecimenNames.contains(widget.name)) return DataCollectionComponentSpecimen(key: key, name: widget.name);
		if (progressCollectionSpecimenNames.contains(widget.name)) return ProgressCollectionComponentSpecimen(key: key, name: widget.name);
		if (contentCollectionSpecimenNames.contains(widget.name)) return ContentCollectionComponentSpecimen(key: key, name: widget.name);
		if (feedbackSpecimenNames.contains(widget.name)) return FeedbackComponentSpecimen(key: key, name: widget.name);
		if (formControlSpecimenNames.contains(widget.name)) return FormControlComponentSpecimen(key: key, name: widget.name);
		if (spatialSpecimenNames.contains(widget.name)) return SpatialComponentSpecimen(key: key, name: widget.name);
		if (commandSpecimenNames.contains(widget.name)) return RegisteredCommandsDemo(key: key, specimen: widget.name);
		if (frameSpecimenNames.contains(widget.name)) return FrameComponentSpecimen(key: key, name: widget.name);
		if (explorerSpecimenNames.contains(widget.name)) return ExplorerComponentSpecimen(key: key, name: widget.name);
		if (linearSpecimenNames.contains(widget.name)) return LinearComponentSpecimen(key: key, name: widget.name);
		return _ComponentFixture(key: key, name: widget.name);
	}
}

class _ComponentFixture extends StatefulWidget {
	const _ComponentFixture({super.key, required this.name});
	/* 同fixture只依當次公開target渲染，不退到其他元件頁。 */
	final String name;
	@override
	State<_ComponentFixture> createState() => _ComponentFixtureState();
}

class _ComponentFixtureState extends State<_ComponentFixture> {
	/* Controller保留原生draft；theme／width改變不更換此owner。 */
	final _draft = TextEditingController(text: '展示內容：切換風格仍保留');
	int _role = 0;
	int _tone = 0;
	int _size = 0;
	int _count = 0;
	bool _selected = false;
	bool _disabled = false;
	bool _secondary = false;

	@override
	void dispose() {
		_draft.dispose();
		super.dispose();
	}

	void _record() => setState(() => _count++);
	void _edit(String value) => setState(() {});

	Widget _cycle(String label, VoidCallback onPressed) => KlpButton(label: label, onPressed: onPressed);

	List<Widget> _controls() {
		final items = <Widget>[];
		switch (widget.name) {
			case 'KlpText':
				items.add(_cycle('role：${KlpTextRole.values[_role].name}', () => setState(() => _role = (_role + 1) % KlpTextRole.values.length)));
				items.add(_cycle('tone：${KlpTextTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpTextTone.values.length)));
				items.add(_cycle('maxLines：${_secondary ? 1 : '不限'}', () => setState(() => _secondary = !_secondary)));
			case 'KlpSurface':
				items.add(_cycle('tone：${KlpSurfaceTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpSurfaceTone.values.length)));
				items.add(_cycle('frosted：$_selected', () => setState(() => _selected = !_selected)));
				items.add(_cycle('padding：${_secondary ? 'section' : 'contentInset'}', () => setState(() => _secondary = !_secondary)));
			case 'KlpBadge':
				items.add(_cycle('tone：${KlpFeedbackTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpFeedbackTone.values.length)));
				items.add(_cycle('variant：${KlpBadgeVariant.values[_role].name}', () => setState(() => _role = (_role + 1) % KlpBadgeVariant.values.length)));
				items.add(_cycle('dot：$_selected', () => setState(() => _selected = !_selected)));
			case 'KlpButton':
				items.add(_cycle('tone：${KlpButtonTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpButtonTone.values.length)));
				items.add(_cycle('size：${KlpControlSize.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpControlSize.values.length)));
				items.add(_cycle('selected：$_selected', () => setState(() => _selected = !_selected)));
				items.add(_cycle('enabled：${!_disabled}', () => setState(() => _disabled = !_disabled)));
			case 'KlpIconButton':
				items.add(_cycle('tone：${KlpIconButtonTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpIconButtonTone.values.length)));
				items.add(_cycle('size：${KlpIconButtonSize.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpIconButtonSize.values.length)));
				items.add(_cycle('quarterTurns：$_role', () => setState(() => _role = (_role + 1) % 4)));
				items.add(_cycle('selected：$_selected', () => setState(() => _selected = !_selected)));
				items.add(_cycle('enabled：${!_disabled}', () => setState(() => _disabled = !_disabled)));
			case 'KlpTextField':
				items.add(_cycle('size：${KlpControlSize.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpControlSize.values.length)));
				items.add(_cycle('outlined：$_selected', () => setState(() => _selected = !_selected)));
				items.add(_cycle('enabled：${!_disabled}', () => setState(() => _disabled = !_disabled)));
				items.add(_cycle('multiline：$_secondary', () => setState(() => _secondary = !_secondary)));
		}
		return items;
	}

	Widget _target(BuildContext context) {
		switch (widget.name) {
			case 'KlpText':
				return KlpText(_draft.text, role: KlpTextRole.values[_role], tone: KlpTextTone.values[_tone], maxLines: _secondary ? 1 : null, overflow: TextOverflow.ellipsis);
			case 'KlpSurface':
				final inset = _secondary ? context.klp.space.section : context.klp.space.contentInset;
				return KlpSurface(tone: KlpSurfaceTone.values[_tone], frosted: _selected, padding: EdgeInsets.all(inset), child: KlpText(_draft.text));
			case 'KlpBadge':
				return KlpBadge(label: _draft.text, tone: KlpFeedbackTone.values[_tone], variant: KlpBadgeVariant.values[_role], dot: _selected);
			case 'KlpButton':
				return KlpButton(label: _draft.text, tone: KlpButtonTone.values[_tone], size: KlpControlSize.values[_size], selected: _selected, onPressed: _disabled ? null : _record);
			case 'KlpIconButton':
				return KlpIconButton(icon: KlpIcons.check, label: _draft.text, tone: KlpIconButtonTone.values[_tone], size: KlpIconButtonSize.values[_size], selected: _selected, quarterTurns: _role, onPressed: _disabled ? null : _record);
			case 'KlpTextField':
				return KlpTextField(label: '當前元件輸入', controller: _draft, size: KlpControlSize.values[_size], enabled: !_disabled, outlined: _selected, multiline: _secondary, onChanged: (value) => _record(), onSubmitted: (value) => _record());
			default:
				throw StateError('未註冊的target：${widget.name}');
		}
	}

	String _usage() {
		return switch (widget.name) {
			'KlpText' => 'KlpText(text, role: role, tone: tone)',
			'KlpSurface' => 'KlpSurface(tone: tone, frosted: frosted, padding: padding, child: content)',
			'KlpBadge' => 'KlpBadge(label: text, tone: tone, variant: variant, dot: dot)',
			'KlpButton' => 'KlpButton(label: text, tone: tone, size: size, selected: selected, onPressed: enabled ? onPressed : null)',
			'KlpIconButton' => 'KlpIconButton(icon: KlpIcons.check, label: text, tone: tone, size: size, selected: selected, quarterTurns: turns, onPressed: enabled ? onPressed : null)',
			'KlpTextField' => 'KlpTextField(label: label, controller: controller, size: size, enabled: enabled, outlined: outlined, multiline: multiline, onChanged: onChanged)',
			_ => '',
		};
	}

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls()),
			SizedBox(height: space.contentStackGap),
			if (widget.name != 'KlpTextField') KlpTextField(label: '元件內容／標籤', controller: _draft, onChanged: _edit),
			SizedBox(height: space.contentStackGap),
			_target(context),
			SizedBox(height: space.contentStackGap),
			KlpText('原生callback次數：$_count', role: KlpTextRole.code),
			KlpText(_usage(), role: KlpTextRole.code),
		]);
	}
}
