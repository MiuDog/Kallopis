import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis/kallopis_experimental.dart';

/* 五個動作工具元件都有自己的公開 target。 */
const actionUtilitySpecimenNames = <String>['KlpBulkActionBar', 'KlpCommandMenu', 'KlpEditorToolbar', 'KlpSearchNavigator', 'KlpSelectionToolbar'];

/* experimental 分類沿用公開庫，展示不改變穩定性。 */
const actionUtilityExperimentalSpecimenNames = <String>['KlpBulkActionBar', 'KlpCommandMenu', 'KlpEditorToolbar', 'KlpSearchNavigator'];

class ActionUtilityComponentSpecimen extends StatefulWidget {
	const ActionUtilityComponentSpecimen({super.key, required this.name});
	/* 名稱只決定自己展示的 constructor。 */
	final String name;
	@override
	State<ActionUtilityComponentSpecimen> createState() => _ActionUtilityComponentSpecimenState();
}

class _ActionUtilityComponentSpecimenState extends State<ActionUtilityComponentSpecimen> {
	/* 動作、搜尋與選取示意資料由 consumer 擁有。 */
	final _label = TextEditingController(text: '動作標籤');
	final _detail = TextEditingController(text: '動作說明');
	bool _enabled = true;
	bool _extra = false;
	bool _optional = false;
	bool _framed = true;
	bool _autofocus = true;
	bool _disabledMiddle = true;
	bool _dashed = true;
	bool _closed = false;
	int _selected = 0;
	int _count = 3;
	int _total = 3;
	int _current = 1;
	int _queryEpoch = 0;
	String _initialQuery = 'demo';
	String _query = 'demo';
	int _rootCalls = 0;
	int _entryCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _label.dispose(); _detail.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _entry(int index) => setState(() { _selected = index; _entryCalls++; _result = 'entry $index 動作 $_entryCalls'; });
	void _escape() => setState(() { _rootCalls++; _result = 'onEscape 公開回呼'; });
	void _clear() => setState(() { _count = 0; _rootCalls++; _result = 'consumer 已清除選取'; });
	void _queryChanged(String query) => setState(() { _query = query; _inputs++; _rootCalls++; _result = 'onQueryChanged：$query'; });
	void _position(bool forward) => setState(() { _current = _total == 0 ? 0 : (_current + (forward ? 1 : -1)).clamp(1, _total); _rootCalls++; _result = 'consumer 示意位置：$_current/$_total'; });
	void _previous() => _position(false);
	void _next() => _position(true);
	void _close() => setState(() { _closed = true; _rootCalls++; _result = 'consumer 已關閉搜尋導覽'; });
	void _applyInitial() => setState(() { _initialQuery = _label.text; _query = _initialQuery; _queryEpoch++; _closed = false; });
	void _totalChange() => setState(() { _total = _total == 3 ? 0 : 3; _current = _total == 0 ? 0 : _current.clamp(1, _total); });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _callbackControl() => _control('可選用 callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _dangerControl() => _control('danger：$_extra', () => setState(() => _extra = !_extra));
	Widget _selectedControl() => _control('selected index：$_selected', () => setState(() => _selected = (_selected + 1) % 3));

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpBulkActionBar':
			case 'KlpEditorToolbar': return [_dangerControl(), _selectedControl(), _callbackControl()];
			case 'KlpCommandMenu': return [_control('framed：$_framed', () => setState(() => _framed = !_framed)), _control('autofocus（重建 target）：$_autofocus', () => setState(() => _autofocus = !_autofocus)), _control('item2 disabled：$_disabledMiddle', () => setState(() => _disabledMiddle = !_disabledMiddle)), _control('caption／shortcut：$_optional', () => setState(() => _optional = !_optional)), _dangerControl(), _selectedControl(), _callbackControl()];
			case 'KlpSearchNavigator': return [_control('套用 initialQuery（重建 target）', _applyInitial), _control('total：$_total', _totalChange), _callbackControl(), _control('還原搜尋導覽', () => setState(() => _closed = false))];
			case 'KlpSelectionToolbar': return [_control('count：$_count', () => setState(() => _count = _count == 3 ? 0 : 3)), _control('dashed：$_dashed', () => setState(() => _dashed = !_dashed)), _control('clearLabel=null：$_optional', () => setState(() => _optional = !_optional)), _dangerControl(), _callbackControl()];
			default: return const [];
		}
	}

	List<KlpEditorActionData> _editorActions() => [for (var i = 0; i < 3; i++) KlpEditorActionData(label: '${_label.text} $i', selected: _selected == i, danger: _extra && i == 2, onPressed: _enabled ? () => _entry(i) : null)];
	KlpCommandItemData _command(int index) => KlpCommandItemData(label: '${_label.text} $index', caption: _optional ? _detail.text : null, shortcut: _optional ? 'Ctrl+$index' : null, selected: _selected == index, danger: _extra && index == 3, onPressed: _enabled && !(_disabledMiddle && index == 2) ? () => _entry(index) : null);

	Widget _target() {
		switch (widget.name) {
			case 'KlpBulkActionBar': return KlpBulkActionBar(label: _label.text, actions: _editorActions());
			case 'KlpEditorToolbar': return KlpEditorToolbar(actions: _editorActions());
			case 'KlpCommandMenu': return KlpCommandMenu(key: ValueKey(_autofocus), sections: [KlpCommandSectionData(label: '第一組', items: [_command(0), _command(1)]), KlpCommandSectionData(label: '第二組', items: [_command(2), _command(3)])], framed: _framed, autofocus: _autofocus, onEscape: _enabled ? _escape : null);
			case 'KlpSearchNavigator': return _closed ? const KlpText('consumer 已移除搜尋導覽') : KlpSearchNavigator(key: ValueKey(_queryEpoch), initialQuery: _initialQuery, current: _current, total: _total, onPrevious: _enabled ? _previous : null, onNext: _enabled ? _next : null, onClose: _enabled ? _close : null, onQueryChanged: _enabled ? _queryChanged : null);
			case 'KlpSelectionToolbar': return KlpSelectionToolbar(count: _count, countLabel: _label.text, actions: [for (var i = 0; i < 3; i++) KlpSelectionAction(id: 'selection-$i', label: '${_label.text} $i', danger: _extra && i == 2, onPressed: _enabled ? () => _entry(i) : null)], onClear: _enabled ? _clear : null, clearLabel: _optional ? null : _detail.text, dashed: _dashed);
			default: return KlpText('未知動作展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpBulkActionBar': return 'KlpBulkActionBar(label: label, actions: List<KlpEditorActionData>)';
			case 'KlpEditorToolbar': return 'KlpEditorToolbar(actions: List<KlpEditorActionData>)';
			case 'KlpCommandMenu': return 'KlpCommandMenu(sections: List<KlpCommandSectionData>, framed: framed, autofocus: autofocus, onEscape: onEscape)';
			case 'KlpSearchNavigator': return 'KlpSearchNavigator(initialQuery: initialQuery, current: current, total: total, onPrevious: onPrevious, onNext: onNext, onClose: onClose, onQueryChanged: onQueryChanged)';
			case 'KlpSelectionToolbar': return 'KlpSelectionToolbar(count: count, countLabel: countLabel, actions: List<KlpSelectionAction>, onClear: onClear, clearLabel: clearLabel, dashed: dashed)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _label, placeholder: widget.name == 'KlpSearchNavigator' ? '待套用 initialQuery（按套用後才重建）' : '公開 label／countLabel／action label', onChanged: _edit),
		if (['KlpCommandMenu', 'KlpSelectionToolbar'].contains(widget.name)) KlpTextField(controller: _detail, placeholder: '公開 caption／clearLabel', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target())),
		KlpText('root 回呼：$_rootCalls；entry 動作：$_entryCalls；query 輸入：$_inputs；控制文字：$_edits'),
		KlpText('最後回呼結果：$_result'),
		KlpText('selectedIndex：$_selected；count：$_count；query：$_query；position：$_current/$_total；closed：$_closed'),
		if (widget.name == 'KlpCommandMenu') const KlpText('shortcut 是展示文字；命令註冊與快捷鍵使用 registered 元件頁。'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
