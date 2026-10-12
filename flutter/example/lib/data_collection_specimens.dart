import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 真實資料集合 target；不把 DTO 或其他展示當成覆蓋。 */
const dataCollectionSpecimenNames = <String>['KlpAccordion', 'KlpDataTable', 'KlpDateGrid', 'KlpJsonTree', 'KlpKeyValueList', 'KlpKeyValueTable', 'KlpTree', 'KlpTreeItem'];

class DataCollectionComponentSpecimen extends StatefulWidget {
	const DataCollectionComponentSpecimen({super.key, required this.name});
	/* 公開名稱僅指定自己的 constructor。 */
	final String name;
	@override
	State<DataCollectionComponentSpecimen> createState() => _DataCollectionComponentSpecimenState();
}

class _DataCollectionComponentSpecimenState extends State<DataCollectionComponentSpecimen> {
	/* 產品資料與草稿保留在 consumer，主題不清除此 owner。 */
	final _title = TextEditingController(text: '資料標題');
	final _detail = TextEditingController(text: '資料內容');
	final _draft = TextEditingController(text: '資料 child 草稿');
	Set<String> _selected = {};
	final _expanded = <String>{'parent'};
	String? _treeSelected;
	int _dateSelected = -1;
	bool _flag = false;
	bool _extra = false;
	bool _optional = false;
	bool _enabled = true;
	bool _empty = false;
	bool _ascending = true;
	int _size = 0;
	int _depth = 1;
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _title.dispose(); _detail.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _record(String value) => setState(() { _rootCalls++; _result = value; });
	void _accordion(Set<String> ids) => _record('accordion expanded：${ids.toList()..sort()}');
	void _row(String id) => _record('row：$id');
	void _selection(Set<String> ids) => setState(() { _selected = Set.of(ids); _rootCalls++; _result = 'selected：${ids.toList()..sort()}'; });
	void _sort(String column) => setState(() { _ascending = !_ascending; _rootCalls++; _result = 'sort：$column／${_ascending ? 'ascending' : 'descending'}'; });
	void _date(int index) => setState(() { _dateSelected = index; _rootCalls++; _result = 'date index：$index'; });
	void _copy(String id) => _record('copy callback：$id（僅記錄公開回呼）');
	void _treeSelect(String id) => setState(() { _treeSelected = id; if (widget.name == 'KlpTreeItem') _flag = true; _rootCalls++; _result = 'tree selected：$id'; });
	void _treeExpand(String id) => setState(() { if (!_expanded.add(id)) _expanded.remove(id); _rootCalls++; _result = 'tree expanded：${_expanded.toList()..sort()}'; });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _flagControl(String label) => _control('$label：$_flag', () => setState(() => _flag = !_flag));
	Widget _extraControl(String label) => _control('$label：$_extra', () => setState(() => _extra = !_extra));
	Widget _optionalControl(String label) => _control('$label：$_optional', () => setState(() => _optional = !_optional));
	Widget _callbackControl() => _control('root callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _emptyControl() => _control('資料 empty：$_empty', () => setState(() => _empty = !_empty));
	Widget _widthControl() => _control('labelWidth：${KlpKeyValueLabelWidth.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpKeyValueLabelWidth.values.length));

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpAccordion': return [_flagControl('multiple（重建 target）'), _extraControl('initialExpandedIds（重建 target）'), _optionalControl('subtitle'), _emptyControl(), _callbackControl()];
			case 'KlpDataTable': return [_flagControl('selectable'), _extraControl('sortable'), _optionalControl('alignment=end／verbatim'), _control('span：${KlpDataColumnSpan.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpDataColumnSpan.values.length)), _emptyControl(), _callbackControl()];
			case 'KlpDateGrid': return [_extraControl('lines'), _emptyControl(), _callbackControl()];
			case 'KlpJsonTree': return [_flagControl('loading'), _extraControl('invalid'), _optionalControl('expandedPaths（重建 target）'), _control('defaultDepth（重建 target）：$_depth', () => setState(() => _depth = _depth == 1 ? 3 : 1)), _emptyControl(), _callbackControl()];
			case 'KlpKeyValueList': return [_widthControl(), _flagControl('copyable'), _extraControl('verbatim'), _optionalControl('emptyState'), _emptyControl(), _callbackControl()];
			case 'KlpKeyValueTable': return [_widthControl(), _optionalControl('title'), _emptyControl()];
			case 'KlpTree': return [_extraControl('icon／badge／tone'), _flagControl('deleted'), _emptyControl(), _callbackControl()];
			case 'KlpTreeItem': return [_extraControl('icon／badge／tone'), _flagControl('selected'), _optionalControl('deleted／hasChildren／expanded'), _callbackControl()];
			default: return const [];
		}
	}

	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '資料 child 動作', onPressed: _childAction)]);
	Widget _wide(Widget child) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: 760, child: child));
	KlpTreeNode _node(String id, String label) => KlpTreeNode(id: id, label: label, icon: _extra ? KlpIcons.folder : null, badge: _extra ? _detail.text : null, tone: _extra ? KlpFeedbackTone.info : null, selected: widget.name == 'KlpTreeItem' ? _flag : _treeSelected == id, deleted: widget.name == 'KlpTree' ? _flag : _optional, hasChildren: _optional, expanded: !_optional);

	Widget _table() {
		final rows = [for (var i = 0; i < 3; i++) KlpDataRow(id: 'row-$i', cells: {'title': '${_title.text} $i', 'detail': _detail.text})];
		final data = _ascending ? rows : rows.reversed.toList();
		return _wide(KlpDataTable(columns: [KlpDataColumn(id: 'title', label: 'title', sortable: _extra, span: KlpDataColumnSpan.values[_size], alignment: _optional ? KlpDataAlignment.end : KlpDataAlignment.start, verbatim: _optional), const KlpDataColumn(id: 'detail', label: 'detail')], rows: _empty ? [] : data, selectable: _flag, selectedIds: _selected, sort: _extra ? KlpDataSort(columnId: 'title', direction: _ascending ? KlpSortDirection.ascending : KlpSortDirection.descending) : null, onRowPressed: _enabled ? _row : null, onSelected: _enabled ? _selection : null, onSort: _enabled ? _sort : null));
	}

	Widget _target() {
		switch (widget.name) {
			case 'KlpAccordion': return KlpAccordion(key: ValueKey('$_flag/$_extra'), items: _empty ? [] : [for (var i = 0; i < 3; i++) KlpAccordionItemData(id: 'item-$i', title: '${_title.text} $i', subtitle: _optional ? _detail.text : null, child: i == 0 ? _child() : KlpText('${_detail.text} $i'))], multiple: _flag, initialExpandedIds: _extra ? {'item-0'} : {}, onExpandedChanged: _enabled ? _accordion : null);
			case 'KlpDataTable': return _table();
			case 'KlpDateGrid': return _wide(KlpDateGrid(items: _empty ? [] : [for (var i = 0; i < 7; i++) KlpDateGridItem(label: '${_title.text} $i', lines: _extra ? [_detail.text] : [], selected: _dateSelected == i)], onSelected: _enabled ? _date : null));
			case 'KlpJsonTree': return KlpJsonTree(key: ValueKey('$_depth/$_optional'), value: _empty ? null : {'title': _title.text, 'detail': _detail.text, 'nested': {'items': [1, true, null]}}, defaultDepth: _depth, expandedPaths: _optional ? {r'$.nested'} : {}, loading: _flag, invalid: _extra, onCopyPath: _enabled ? _copy : null);
			case 'KlpKeyValueList': return KlpKeyValueList(rows: _empty ? [] : [KlpKeyValueItem(id: 'title', label: _title.text, value: _child(), copyable: _flag, verbatim: _extra), KlpKeyValueItem(id: 'detail', label: 'detail', value: KlpText(_detail.text), copyable: _flag, verbatim: _extra)], labelWidth: KlpKeyValueLabelWidth.values[_size], onCopy: _enabled ? _copy : null, emptyState: _optional ? KlpText(_detail.text) : null);
			case 'KlpKeyValueTable': return KlpKeyValueTable(rows: _empty ? [] : [KlpKeyValueRowData(label: _title.text, value: _detail.text), const KlpKeyValueRowData(label: 'consumer', value: '示意資料')], title: _optional ? _title.text : null, labelWidth: KlpKeyValueLabelWidth.values[_size]);
			case 'KlpTree': return KlpTree(nodes: _empty ? [] : [KlpTreeNode(id: 'parent', label: _title.text, children: [_node('child-a', '${_detail.text} A'), _node('child-b', '${_detail.text} B')])], label: _title.text, expandedIds: _expanded, selectedId: _treeSelected, onSelected: _enabled ? _treeSelect : null, onExpanded: _enabled ? _treeExpand : null);
			case 'KlpTreeItem': return KlpTreeItem(node: _node('item', _title.text), onSelected: _enabled ? _treeSelect : null);
			default: return KlpText('未知資料展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpAccordion': return 'KlpAccordion(items: List<KlpAccordionItemData>, multiple: multiple, initialExpandedIds: initialExpandedIds, onExpandedChanged: onExpandedChanged)';
			case 'KlpDataTable': return 'KlpDataTable(columns: columns, rows: rows, selectable: selectable, selectedIds: selectedIds, sort: sort, onRowPressed: onRowPressed, onSelected: onSelected, onSort: onSort)';
			case 'KlpDateGrid': return 'KlpDateGrid(items: List<KlpDateGridItem>, onSelected: onSelected)';
			case 'KlpJsonTree': return 'KlpJsonTree(value: value, defaultDepth: defaultDepth, expandedPaths: expandedPaths, loading: loading, invalid: invalid, onCopyPath: onCopyPath)';
			case 'KlpKeyValueList': return 'KlpKeyValueList(rows: List<KlpKeyValueItem>, labelWidth: labelWidth, onCopy: onCopy, emptyState: emptyState)';
			case 'KlpKeyValueTable': return 'KlpKeyValueTable(rows: List<KlpKeyValueRowData>, title: title, labelWidth: labelWidth)';
			case 'KlpTree': return 'KlpTree(nodes: nodes, label: label, expandedIds: expandedIds, selectedId: selectedId, onSelected: onSelected, onExpanded: onExpanded)';
			case 'KlpTreeItem': return 'KlpTreeItem(node: KlpTreeNode, onSelected: onSelected)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _title, placeholder: '公開 title／label', onChanged: _edit),
		KlpTextField(controller: _detail, placeholder: '公開資料內容', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target())),
		KlpText('root 回呼：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText(_result),
		KlpText('treeSelected：$_treeSelected；dateSelected：$_dateSelected；selected：${_selected.toList()..sort()}'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
