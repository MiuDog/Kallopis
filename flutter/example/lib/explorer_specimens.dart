import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* Views在公開root的正常compound中呈現，沒有自建node或renderer。 */
const explorerSpecimenNames = <String>['KlpFileExplorer', 'KlpFileExplorerSection', 'KlpFileExplorerSectionView', 'KlpFileExplorerFolderView', 'KlpFileExplorerItemView'];

class ExplorerComponentSpecimen extends StatefulWidget {
	const ExplorerComponentSpecimen({super.key, required this.name});
	/* 當次target決定資料投影與自己的controls。 */
	final String name;
	@override
	State<ExplorerComponentSpecimen> createState() => _ExplorerComponentSpecimenState();
}

class _ExplorerComponentSpecimenState extends State<ExplorerComponentSpecimen> {
	/* Consumer持有controller與原生callback紀錄；Theme切換不換owner。 */
	late final _label = TextEditingController(text: _initialLabel());
	final _expandedItems = <String>{'folder', 'outer'};
	bool _sectionExpanded = true;
	bool _collapsible = true;
	bool _deep = false;
	bool _badge = false;
	bool _extraItem = false;
	bool _empty = false;
	bool _fallback = true;
	bool _fallbackExpanded = true;
	int _spacing = 0;
	int _tone = 0;
	int _sectionCount = 0;
	int _toggleCount = 0;
	int _selectCount = 0;
	String? _selected;
	String _lastEvent = '尚無原生回呼';

	bool get _folderTarget => widget.name == 'KlpFileExplorerFolderView';
	bool get _itemTarget => widget.name == 'KlpFileExplorerItemView';
	String get _targetId => _folderTarget ? 'folder' : 'focus';

	String _initialLabel() {
		if (_folderTarget) return '文件目錄';
		if (_itemTarget) return 'README.md';
		return '專案分區';
	}

	@override
	void dispose() {
		_label.dispose();
		super.dispose();
	}

	void _onSectionToggle(String id) => setState(() {
		if (id == 'fallback') {
			_fallbackExpanded = !_fallbackExpanded;
		} else {
			_sectionExpanded = !_sectionExpanded;
		}
		_sectionCount++;
		_lastEvent = 'onSectionToggle($id)';
	});

	void _onItemToggle(String id) => setState(() {
		if (!_expandedItems.remove(id)) _expandedItems.add(id);
		_toggleCount++;
		_lastEvent = 'onItemToggle($id)';
	});

	void _onItemSelected(String id) => setState(() {
		_selected = id;
		_selectCount++;
		_lastEvent = 'onItemSelected($id)';
	});

	Widget _control(String label, VoidCallback onPressed) => KlpButton(label: label, onPressed: onPressed);

	List<Widget> _controls() {
		final controls = <Widget>[];
		if (widget.name != 'KlpFileExplorerSection') {
			controls.add(_control('spacing：${KlpFileExplorerSpacing.values[_spacing].name}', () => setState(() => _spacing = (_spacing + 1) % KlpFileExplorerSpacing.values.length)));
		}
		if (_folderTarget || _itemTarget) {
			controls.add(_control('level：${_deep ? 1 : 0}', () => setState(() { _deep = !_deep; _expandedItems.add('outer'); })));
			controls.add(_control('isSelected：${_selected == _targetId}', () => setState(() => _selected = _selected == _targetId ? null : _targetId)));
			controls.add(_control('item.badge：$_badge', () => setState(() => _badge = !_badge)));
			controls.add(_control('item.tone：${KlpFeedbackTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpFeedbackTone.values.length)));
			if (_folderTarget) controls.add(_control('isExpanded：${_expandedItems.contains('folder')}', () => setState(() { if (!_expandedItems.remove('folder')) _expandedItems.add('folder'); })));
			return controls;
		}
		controls.add(_control('section.expanded：$_sectionExpanded', () => setState(() => _sectionExpanded = !_sectionExpanded)));
		controls.add(_control('section.collapsible：$_collapsible', () => setState(() => _collapsible = !_collapsible)));
		controls.add(_control('增加項目：$_extraItem', () => setState(() => _extraItem = !_extraItem)));
		if (widget.name == 'KlpFileExplorer') {
			controls.add(_control('sections空集合：$_empty', () => setState(() => _empty = !_empty)));
			controls.add(_control('emptyStateSections：$_fallback', () => setState(() => _fallback = !_fallback)));
			controls.add(_control('selectedId：${_selected ?? 'null'}', () => setState(() => _selected = _selected == 'focus' ? null : 'focus')));
		}
		return controls;
	}

	List<KlpFileExplorerItem> _items() {
		final focus = KlpFileExplorerItem(id: 'focus', label: _itemTarget ? _label.text : 'README.md', badge: _badge ? 'edited' : null, tone: KlpFeedbackTone.values[_tone]);
		final folder = KlpFileExplorerItem(id: 'folder', label: _folderTarget ? _label.text : '文件目錄', folder: true, badge: _badge ? 'edited' : null, tone: KlpFeedbackTone.values[_tone], children: const [KlpFileExplorerItem(id: 'guide', label: '指南.md')]);
		List<KlpFileExplorerItem> items;
		if (_folderTarget) {
			items = [folder];
		} else if (_itemTarget) {
			items = [focus];
		} else {
			items = [folder, focus, if (_extraItem) const KlpFileExplorerItem(id: 'extra', label: 'CHANGELOG.md')];
		}
		if (_deep) return [KlpFileExplorerItem(id: 'outer', label: '上層資料夾', folder: true, children: items)];
		return items;
	}

	KlpFileExplorer _explorer() {
		final section = KlpFileExplorerSection(id: 'project', title: _folderTarget || _itemTarget ? '專案分區' : _label.text, expanded: _sectionExpanded, collapsible: _collapsible, items: _items());
		return KlpFileExplorer(
			sections: _empty ? const [] : [section],
			emptyStateSections: _fallback ? const [KlpFileExplorerSection(id: 'fallback', title: '空集合替代分區', items: [KlpFileExplorerItem(id: 'fallback-file', label: '建立第一份文件.md')])] : const [],
			expandedSectionIds: {if (_fallbackExpanded) 'fallback', if (_sectionExpanded) 'project'},
			expandedItemIds: _expandedItems,
			selectedId: _selected,
			spacing: KlpFileExplorerSpacing.values[_spacing],
			onSectionToggle: _onSectionToggle,
			onItemToggle: _onItemToggle,
			onItemSelected: _onItemSelected,
		);
	}

	String _usage() {
		final subject = switch (widget.name) {
			'KlpFileExplorer' => 'sections／emptyStateSections及controlled IDs由consumer提供。',
			'KlpFileExplorerSection' => 'sections: [KlpFileExplorerSection(id: id, title: title, items: items, expanded: expanded, collapsible: collapsible)]',
			'KlpFileExplorerSectionView' => 'section.title／expandedSectionIds／spacing投影到當前SectionView。',
			'KlpFileExplorerFolderView' => 'folder item／expandedItemIds／selectedId／spacing；level由合法父資料夾造成。',
			'KlpFileExplorerItemView' => 'leaf item／selectedId／spacing；level由合法父資料夾造成。',
			_ => '',
		};
		return 'KlpFileExplorer(sections: sections, expandedSectionIds: sectionsExpanded, expandedItemIds: itemsExpanded, selectedId: selectedId, onSectionToggle: onSectionToggle, onItemToggle: onItemToggle, onItemSelected: onItemSelected)\n$subject\nView經公開root正常渲染；不使用private node／adapter。';
	}

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final label = _folderTarget || _itemTarget ? 'item.label' : 'section.title';
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls()),
			SizedBox(height: space.contentStackGap),
			KlpTextField(label: label, controller: _label, onChanged: (value) => setState(() {})),
			SizedBox(height: space.contentStackGap),
			SizedBox(height: 280, child: _explorer()),
			KlpText('sectionToggle：$_sectionCount；itemToggle：$_toggleCount；itemSelected：$_selectCount', role: KlpTextRole.code),
			KlpText('selectedId：${_selected ?? 'null'}；$_lastEvent', role: KlpTextRole.code),
			KlpText(_usage(), role: KlpTextRole.code),
		]);
	}
}
