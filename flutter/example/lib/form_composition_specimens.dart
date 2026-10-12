import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 清單只接受當次自己的真實公開 target。 */
const formCompositionSpecimenNames = <String>['KlpForm', 'KlpFormActions', 'KlpFormErrorSummary', 'KlpFormSection', 'KlpFieldGroup', 'KlpCompoundField', 'KlpConditionalFieldRegion', 'KlpRepeaterField', 'KlpKeyValueEditor'];
class FormCompositionComponentSpecimen extends StatefulWidget {
	/* name：精確路由，環境變更不重建 consumer State。 */
	final String name;
	const FormCompositionComponentSpecimen({super.key, required this.name});
	@override
	State<FormCompositionComponentSpecimen> createState() => _FormCompositionComponentSpecimenState();
}
class _FormCompositionComponentSpecimenState extends State<FormCompositionComponentSpecimen> {
	/* label/draft：控制內容及唯一草稿權威，dispose 清理。 */
	final _label = TextEditingController(text: '表單資料');
	final _draft = TextEditingController(text: '組合欄位草稿');
	/* 公開參數由 consumer 控制，不複製庫互動算法。 */
	bool _enabled = true;
	bool _extra = true;
	bool _error = false;
	bool _collapsed = false;
	bool _visible = true;
	bool _submitting = false;
	bool _readOnly = false;
	/* 選项與集合由 consumer 投影，新增 ID 穩定。 */
	String _choice = 'a';
	List<String> _items = ['row-a', 'row-b'];
	List<KlpKeyValueEntry> _entries = const [KlpKeyValueEntry(id: 'entry-a', keyText: 'name', value: 'Kallopis'), KlpKeyValueEntry(id: 'entry-b', keyText: 'mode', value: 'semantic')];
	int _next = 1;
	/* 回呼、子內容及控制計數分離，最後結果只記原回呼。 */
	int _roots = 0;
	int _children = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發原回呼';
	@override
	void dispose() { _label.dispose(); _draft.dispose(); super.dispose(); }
	void _root(String result) => setState(() { _roots++; _result = result; });
	void _input(String value) => setState(() => _inputs++);
	void _edit(String value) => setState(() => _edits++);
	void _childAction() => setState(() => _children++);
	void _toggleSection() { _collapsed = !_collapsed; _root('onToggle：$_collapsed'); }
	void _option(String id) { _choice = id; _root('onOptionSelected：$id'); }
	void _compound(String value) => _root('onChanged：$value');
	void _add() { _items = [..._items, 'row-new-${_next++}']; _root('onAdd'); }
	void _remove(String id) { _items = _items.where((item) => item != id).toList(); _root('onRemove：$id'); }
	void _entriesChanged(List<KlpKeyValueEntry> entries) { _entries = List.of(entries); _root('onChanged：${entries.length} entries'); }
	Widget _control(String label, VoidCallback callback) => KlpButton(label: label, onPressed: callback);
	Widget _enableControl() => _control('callback enabled：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _extraControl() => _control('optional content：$_extra', () => setState(() => _extra = !_extra));
	Widget _errorControl() => _control('error：$_error', () => setState(() => _error = !_error));
	String? get _errorText => _error ? '展示錯誤：請檢查內容' : null;
	Map<String, String> get _errors => _error ? {'draft': '草稿需要確認', 'choice': '選項需要確認'} : {};
	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpForm': return [_extraControl(), _errorControl(), _enableControl()];
			case 'KlpFormActions': return [_enableControl(), _extraControl(), _control('submitting：$_submitting', () => setState(() => _submitting = !_submitting))];
			case 'KlpFormErrorSummary': return [_errorControl(), _enableControl()];
			case 'KlpFormSection': return [_control('collapsed：$_collapsed', () => setState(() => _collapsed = !_collapsed)), _extraControl(), _enableControl()];
			case 'KlpFieldGroup': return [_extraControl(), _errorControl()];
			case 'KlpCompoundField': return [_enableControl(), _errorControl(), _extraControl(), _control('readOnly：$_readOnly', () => setState(() => _readOnly = !_readOnly))];
			case 'KlpConditionalFieldRegion': return [_control('visible：$_visible', () => setState(() => _visible = !_visible))];
			case 'KlpRepeaterField': return [_enableControl(), _control('consumer empty／restore', () => setState(() => _items = _items.isEmpty ? ['row-a', 'row-b'] : []))];
			case 'KlpKeyValueEditor': return [_enableControl(), _control('consumer empty／restore', () => setState(() => _entries = _entries.isEmpty ? const [KlpKeyValueEntry(id: 'entry-a', keyText: 'name', value: 'Kallopis')] : []))];
			default: return const [];
		}
	}
	Widget _child() => KlpSurface(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText('child：${_label.text}'), KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: 'child 動作', onPressed: _childAction)]));
	Widget _actions() => KlpFormActions(submitLabel: '提交${_label.text}', onSubmit: _enabled ? () => _root('onSubmit') : null, cancelLabel: _extra ? '取消資料' : null, onCancel: _enabled ? () => _root('onCancel') : null, resetLabel: _extra ? '重置資料' : null, onReset: _enabled ? () { _draft.text = '組合欄位草稿'; _root('onReset'); } : null, submitting: _submitting);
	Widget _summary() => KlpFormErrorSummary(title: _label.text, errors: _errors, onSelected: _enabled ? (id) => _root('onSelected：$id') : null);
	Widget _target() {
		switch (widget.name) {
			case 'KlpForm': return KlpForm(sections: [KlpFormSection(title: _label.text, children: [_child()]), if (_extra) KlpFormSection(title: '補充區段', children: [const KlpText('產品組裝的另一區段')])], errorSummary: _extra ? _summary() : null, actions: _extra ? _actions() : null);
			case 'KlpFormActions': return _actions();
			case 'KlpFormErrorSummary': return _summary();
			case 'KlpFormSection': return KlpFormSection(title: _label.text, description: _extra ? '自己的公開區段說明' : null, collapsed: _collapsed, onToggle: _enabled ? _toggleSection : null, children: [_child()]);
			case 'KlpFieldGroup': return KlpFieldGroup(legend: _label.text, error: _errorText, children: [_child(), if (_extra) const KlpText('同組附加內容')]);
			case 'KlpCompoundField': return KlpCompoundField(label: _label.text, selectedOptionLabel: _choice == 'a' ? '主要選項' : '次要選項', options: const [KlpChoiceOption(id: 'a', label: '主要選項'), KlpChoiceOption(id: 'blocked', label: '停用選項', disabled: true), KlpChoiceOption(id: 'b', label: '次要選項')], controller: _draft, placeholder: _extra ? '自己的placeholder' : null, onChanged: _enabled ? _compound : null, onOptionSelected: _enabled ? _option : null, enabled: _enabled, readOnly: _readOnly, error: _errorText, optionsLabel: _extra ? '選擇欄位類型' : null);
			case 'KlpConditionalFieldRegion': return KlpConditionalFieldRegion(visible: _visible, child: _child());
			case 'KlpRepeaterField': return KlpRepeaterField(label: _label.text, addLabel: '新增項目', removeLabel: '移除項目', items: [for (final id in _items) KlpRepeaterItem(id: id, child: KlpText('$id：${_label.text}'))], onAdd: _enabled ? _add : null, onRemove: _enabled ? _remove : null);
			case 'KlpKeyValueEditor': return KlpKeyValueEditor(label: _label.text, entries: _entries, onChanged: _enabled ? _entriesChanged : null);
			default: return const SizedBox.shrink();
		}
	}
	String _usage() => switch (widget.name) {
		'KlpForm' => 'KlpForm(sections: sections, errorSummary: summary, actions: actions)',
		'KlpFormActions' => 'KlpFormActions(submitLabel: label, onSubmit: onSubmit, submitting: submitting)',
		'KlpFormErrorSummary' => 'KlpFormErrorSummary(title: title, errors: errors, onSelected: onSelected)',
		'KlpFormSection' => 'KlpFormSection(title: title, collapsed: collapsed, onToggle: onToggle, children: children)',
		'KlpFieldGroup' => 'KlpFieldGroup(legend: legend, error: error, children: children)',
		'KlpCompoundField' => 'KlpCompoundField(label: label, selectedOptionLabel: optionLabel, options: options, controller: controller, onChanged: onChanged, onOptionSelected: onOptionSelected)',
		'KlpConditionalFieldRegion' => 'KlpConditionalFieldRegion(visible: visible, child: child)',
		'KlpRepeaterField' => 'KlpRepeaterField(label: label, addLabel: addLabel, removeLabel: removeLabel, items: items, onAdd: onAdd, onRemove: onRemove)',
		'KlpKeyValueEditor' => 'KlpKeyValueEditor(label: label, entries: entries, onChanged: onChanged)',
		_ => '',
	};
	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls()), KlpTextField(controller: _label, onChanged: _edit), SizedBox(height: space.itemGap), _target(), SizedBox(height: space.itemGap), KlpText('root 回呼：$_roots；child 動作：$_children；child 輸入：$_inputs；控制文字：$_edits'), KlpText('choice：$_choice；items：${_items.join(', ')}；entries：${_entries.map((entry) => '${entry.id}=${entry.keyText}:${entry.value}').join(', ')}'), KlpText('草稿：${_draft.text}；最後回呼：$_result'), KlpText(_usage(), role: KlpTextRole.code)]);
	}
}
