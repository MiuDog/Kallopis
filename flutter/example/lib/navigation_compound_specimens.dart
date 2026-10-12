import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 三個複合導覽元件各自有原生 target。 */
const navigationCompoundSpecimenNames = <String>['KlpNavigationRail', 'KlpNavigator', 'KlpPublicationProgressOverlay'];

class NavigationCompoundComponentSpecimen extends StatefulWidget {
	const NavigationCompoundComponentSpecimen({super.key, required this.name});
	/* 名稱只指定自己的公開 constructor。 */
	final String name;
	@override
	State<NavigationCompoundComponentSpecimen> createState() => _NavigationCompoundComponentSpecimenState();
}

class _NavigationCompoundComponentSpecimenState extends State<NavigationCompoundComponentSpecimen> {
	/* 群組、導覽及草稿由 consumer 擁有，環境不更換此 owner。 */
	final _title = TextEditingController(text: '複合標題');
	final _detail = TextEditingController(text: '複合說明');
	final _draft = TextEditingController(text: '複合 child 草稿');
	final _topIds = ['top-a', 'top-b', 'top-c'];
	final _centerIds = ['center-a', 'center-b'];
	final _categories = <String>{'category'};
	final _elements = <String>{'parent'};
	String _selected = 'child-a';
	String _railSelected = 'top-a';
	bool _enabled = true;
	bool _flag = false;
	bool _extra = false;
	bool _optional = false;
	bool _visible = false;
	int _tone = KlpSurfaceTone.values.indexOf(KlpSurfaceTone.inset);
	int _stage = 0;
	int _rootCalls = 0;
	int _entryCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _title.dispose(); _detail.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _railSelect(String id) => setState(() { _railSelected = id; _entryCalls++; _result = 'rail entry：$id'; });
	void _railMenu() => setState(() { _entryCalls++; _result = 'rail menu entry：$_entryCalls'; });
	void _reorder(List<String> ids, int oldIndex, int newIndex) => setState(() { final id = ids.removeAt(oldIndex); ids.insert(newIndex, id); _rootCalls++; _result = 'group reorder：$oldIndex→$newIndex／${ids.join(',')}'; });
	void _topReorder(int oldIndex, int newIndex) => _reorder(_topIds, oldIndex, newIndex);
	void _centerReorder(int oldIndex, int newIndex) => _reorder(_centerIds, oldIndex, newIndex);
	void _divider() => setState(() { _extra = !_extra; if (_extra) { _topIds.insert(1, 'divider'); } else { _topIds.remove('divider'); } });
	void _category(String id) => setState(() { if (!_categories.add(id)) _categories.remove(id); _rootCalls++; _result = 'categories：${_categories.toList()..sort()}'; });
	void _element(String id) => setState(() { if (!_elements.add(id)) _elements.remove(id); _rootCalls++; _result = 'elements：${_elements.toList()..sort()}'; });
	void _select(String id) => setState(() { _selected = id; _rootCalls++; _result = 'selectedElementId：$id'; });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _extraControl(String label) => _control('$label：$_extra', () => setState(() => _extra = !_extra));
	Widget _optionalControl(String label) => _control('$label：$_optional', () => setState(() => _optional = !_optional));
	Widget _callbackControl() => _control('可選用 root callback：$_enabled', () => setState(() => _enabled = !_enabled));

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpNavigationRail': return [_control('isReorderable：${!_flag}', () => setState(() => _flag = !_flag)), _control('divider：$_extra', _divider), _optionalControl('badge'), _callbackControl()];
			case 'KlpNavigator': return [_control('surfaceTone：${KlpSurfaceTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpSurfaceTone.values.length)), _control('collapsible：${!_flag}', () => setState(() => _flag = !_flag)), _extraControl('icon／badge／trailing'), _optionalControl('component child'), _callbackControl()];
			case 'KlpPublicationProgressOverlay': return [_control('visible：$_visible', () => setState(() => _visible = !_visible)), _extraControl('stages=1'), _optionalControl('label'), _control('active／complete：$_stage', () => setState(() => _stage = (_stage + 1) % 3))];
			default: return const [];
		}
	}

	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '複合 child 動作', onPressed: _childAction)]);
	KlpRailEntry _entry(String id) {
		if (id == 'divider') return const KlpRailDivider(id: 'divider');
		return KlpRailButtonEntry(id: id, label: '${_title.text} $id', icon: KlpIcons.folder, selected: _railSelected == id, badge: _optional ? _detail.text : null, onPressed: () => _railSelect(id));
	}
	Widget _rail(BuildContext context) => SizedBox(width: context.klp.space.chromeRail, height: 420, child: KlpNavigationRail(
		top: KlpRailItemGroup(id: 'top', items: [for (final id in _topIds) _entry(id)], isReorderable: !_flag, onReorder: _enabled ? _topReorder : null),
		center: KlpRailItemGroup(id: 'center', items: [for (final id in _centerIds) _entry(id)], isReorderable: !_flag, onReorder: _enabled ? _centerReorder : null),
		bottom: KlpRailItemGroup(id: 'bottom', isReorderable: false, items: [KlpRailMenuEntry(id: 'menu', label: '${_title.text} rail menu', icon: KlpIcons.box, items: [KlpMenuItemData(label: _detail.text, onPressed: _railMenu)])]),
	));

	KlpNavigatorElement _leaf(String id) => KlpNavigatorElement(id: id, label: '${_detail.text} $id', icon: _extra ? KlpIcons.folder : null, badge: _extra ? 'demo' : null, trailing: _extra ? const KlpText('後') : null);
	Widget _navigator() => SizedBox(height: 300, child: KlpNavigator(
		items: [KlpNavigatorCategory(id: 'category', label: _title.text, collapsible: !_flag, trailing: _extra ? KlpText(_detail.text) : null, items: [KlpNavigatorElement(id: 'parent', label: '${_title.text} parent', expandable: true, children: [_leaf('child-a'), _leaf('child-b')]), if (_optional) KlpNavigatorComponent(id: 'component', child: _child())])],
		expandedCategoryIds: _categories, expandedElementIds: _elements, selectedElementId: _selected,
		onCategoryToggle: _enabled ? _category : null, onElementToggle: _enabled ? _element : null, onElementSelected: _enabled ? _select : null,
		surfaceTone: KlpSurfaceTone.values[_tone], scrollKey: const ValueKey('navigator-fixture'),
	));

	Widget _target(BuildContext context) {
		switch (widget.name) {
			case 'KlpNavigationRail': return _rail(context);
			case 'KlpNavigator': return _navigator();
			case 'KlpPublicationProgressOverlay': return SizedBox(height: 300, child: KlpPublicationProgressOverlay(visible: _visible, progress: KlpWorkflowProgress(stages: [for (var i = 0; i < (_extra ? 1 : 3); i++) KlpWorkflowStageData(label: '${_title.text} $i', statusLabel: _detail.text, complete: i < _stage, active: i == _stage)], label: _optional ? _title.text : null), child: _child()));
			default: return KlpText('未知複合展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpNavigationRail': return 'KlpNavigationRail(top: KlpRailItemGroup, center: KlpRailItemGroup, bottom: KlpRailItemGroup)';
			case 'KlpNavigator': return 'KlpNavigator(items: items, expandedCategoryIds: expandedCategoryIds, expandedElementIds: expandedElementIds, selectedElementId: selectedElementId, onCategoryToggle: onCategoryToggle, onElementToggle: onElementToggle, onElementSelected: onElementSelected, surfaceTone: surfaceTone, scrollKey: scrollKey)';
			case 'KlpPublicationProgressOverlay': return 'KlpPublicationProgressOverlay(visible: visible, progress: KlpWorkflowProgress, child: child)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _title, placeholder: '公開 label／title', onChanged: _edit),
		KlpTextField(controller: _detail, placeholder: '公開資料內容／statusLabel', onChanged: _edit),
		SingleChildScrollView(child: _target(context)),
		KlpText('root 回呼：$_rootCalls；entry 動作：$_entryCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText(_result),
		KlpText('topOrder：${_topIds.join(',')}；centerOrder：${_centerIds.join(',')}；railSelected：$_railSelected；selectedElementId：$_selected'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
