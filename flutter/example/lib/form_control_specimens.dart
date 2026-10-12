import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 清單中的每個名稱都有自己的公開 target、參數與回呼觀察。 */
const formControlSpecimenNames = <String>['KlpAffixedTextField', 'KlpCheckbox', 'KlpCompactSwitch', 'KlpField', 'KlpFieldDescription', 'KlpFieldError', 'KlpFieldLabel', 'KlpMultiSelectField', 'KlpNumberField', 'KlpPasswordField', 'KlpPhaseToggle', 'KlpQuantityField', 'KlpRadioGroup', 'KlpSegmentedControl', 'KlpSelect', 'KlpSelectField', 'KlpSlider', 'KlpSlidingSelection', 'KlpTagChip', 'KlpTagInputField', 'KlpTextArea', 'KlpToggle', 'KlpToggleIndicator', 'KlpTriStateToggle'];

class FormControlComponentSpecimen extends StatefulWidget {
	const FormControlComponentSpecimen({super.key, required this.name});
	/* 當次元件名稱精確選取自己的展示。 */
	final String name;
	@override
	State<FormControlComponentSpecimen> createState() => _FormControlComponentSpecimenState();
}

class _FormControlComponentSpecimenState extends State<FormControlComponentSpecimen> {
	/* Controller 與 callback 結果由 consumer 持有；環境切換不清除資料。 */
	final _label = TextEditingController(text: '範例欄位');
	final _draft = TextEditingController(text: '展示草稿');
	bool _value = false;
	bool _disabled = false;
	bool _readOnly = false;
	bool _error = false;
	bool _extra = false;
	bool _layout = false;
	bool _dense = false;
	bool _removed = false;
	int _index = 0;
	int _callbacks = 0;
	int _controlChanges = 0;
	int _nextTag = 1;
	double _number = 3;
	String _message = '尚未觸發 target 回呼';
	Set<String> _selected = {'a'};
	List<String> _tags = ['設計', '布局'];
	KlpTriState _triState = KlpTriState.off;

	@override
	void dispose() { _label.dispose(); _draft.dispose(); super.dispose(); }
	void _record(String message) => setState(() { _callbacks++; _message = message; });
	void _onLabel(String value) => setState(() => _controlChanges++);
	void _onText(String value) { if (_draft.text != value) _draft.text = value; _record('文字：$value'); }
	void _onBool(bool value) { _value = value; _record('value：$value'); }
	void _onIndex(int value) { _index = value; _record('selected：$value'); }
	void _onChoice(String value) { _index = ['a', 'b', 'c'].indexOf(value); _record('selected：$value'); }
	void _onNumber(double value) { _number = value; _record('value：$value'); }
	void _onQuantity(num value) => _onNumber(value.toDouble());
	void _onMulti(Set<String> value) { _selected = Set.of(value); _record('selectedIds：${_selected.join(', ')}'); }
	void _onTriState(KlpTriState value) { _triState = value; _record('value：${value.name}'); }
	void _selectNext() => _onIndex((_index + 1) % 3);
	void _addTag() { _tags = [..._tags, '新增${_nextTag++}']; _record('新增標籤'); }
	void _removeTag(String value) { _tags = _tags.where((tag) => tag != value).toList(); _record('移除：$value'); }
	void _clearTags() { _tags = []; _record('清除全部標籤'); }
	void _removeChip() { _removed = true; _record('已移除標籤'); }
	void _toggleDisabled() => setState(() => _disabled = !_disabled);
	void _toggleExtra() => setState(() => _extra = !_extra);
	void _toggleLayout() => setState(() => _layout = !_layout);
	void _toggleRange() => setState(() { _layout = !_layout; _number = _number.clamp(0, _maximum); });
	void _toggleTagLimit() => setState(() { _layout = !_layout; if (_layout) _tags = _tags.take(3).toList(); });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _disabledControl() => _control('enabled／callback：${!_disabled}', _toggleDisabled);
	Widget _errorControl() => _control('error：$_error', () => setState(() => _error = !_error));
	Widget _readOnlyControl() => _control('readOnly：$_readOnly', () => setState(() => _readOnly = !_readOnly));
	Widget _valueControl() => _control('value：$_value', () => setState(() => _value = !_value));
	Widget _selectedControl() => _control('selected：$_index', () => setState(() => _index = (_index + 1) % 3));
	String? get _errorText => _error ? '展示錯誤：請檢查值' : null;
	double get _maximum => _layout ? 100 : 10;

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpCheckbox':
			case 'KlpToggle': return [_valueControl(), _disabledControl(), _control('showLabel：${!_extra}', _toggleExtra)];
			case 'KlpCompactSwitch': return [_valueControl(), _disabledControl()];
			case 'KlpToggleIndicator': return [_valueControl(), _disabledControl()];
			case 'KlpTriStateToggle': return [_control('value：${_triState.name}', () => setState(() => _triState = KlpTriState.values[(_triState.index + 1) % KlpTriState.values.length])), _disabledControl()];
			case 'KlpRadioGroup': return [_selectedControl(), _control('vertical：$_layout', _toggleLayout), _control('descriptions：$_extra', _toggleExtra)];
			case 'KlpSegmentedControl': return [_selectedControl(), _control('expanded：$_layout', _toggleLayout), _control('dense：$_dense', () => setState(() => _dense = !_dense)), _control('icons：$_extra', _toggleExtra)];
			case 'KlpPhaseToggle': return [_selectedControl(), _disabledControl(), _control('options.icon：$_extra', _toggleExtra)];
			case 'KlpSlidingSelection': return [_selectedControl(), _disabledControl(), _control('options.tone：${_extra ? 'status' : 'neutral'}', _toggleExtra)];
			case 'KlpSelect': return [_selectedControl(), _disabledControl()];
			case 'KlpSelectField':
			case 'KlpMultiSelectField': return [_disabledControl(), _readOnlyControl(), _errorControl(), _control('options.c.disabled：$_extra', _toggleExtra)];
			case 'KlpNumberField': return [_disabledControl(), _errorControl(), _control('maximum：$_maximum', _toggleRange), _control('unit：${_extra ? '個' : 'null'}', _toggleExtra)];
			case 'KlpQuantityField': return [_disabledControl(), _readOnlyControl(), _errorControl(), _control('maximum：$_maximum', _toggleRange), _control('step：${_extra ? 5 : 1}', _toggleExtra)];
			case 'KlpSlider': return [_disabledControl(), _control('maximum：$_maximum', _toggleRange), _control('divisions／marks：$_extra', _toggleExtra), _control('displayValue：$_dense', () => setState(() => _dense = !_dense))];
			case 'KlpAffixedTextField': return [_disabledControl(), _readOnlyControl(), _errorControl(), _control('prefixText：$_extra', _toggleExtra), _control('action：$_layout', _toggleLayout)];
			case 'KlpPasswordField': return [_disabledControl(), _readOnlyControl(), _errorControl(), _control('required：$_layout', _toggleLayout), _control('requirements：$_extra', _toggleExtra)];
			case 'KlpTextArea': return [_disabledControl(), _errorControl(), _control('unboundedLines：$_extra', _toggleExtra), _control('outlined：$_layout', _toggleLayout), _control('minLines：${_dense ? 3 : 2}', () => setState(() => _dense = !_dense))];
			case 'KlpTagChip': return [_disabledControl(), _control('恢復標籤', () => setState(() => _removed = false))];
			case 'KlpTagInputField': return [_disabledControl(), _control('onClearAll：$_extra', _toggleExtra), _control('maxCount：${_layout ? 3 : 'null'}', _toggleTagLimit)];
			case 'KlpField': return [_errorControl(), _control('description／requirement／status／counter：$_extra', _toggleExtra), _control('required：$_layout', _toggleLayout)];
			default: return const [];
		}
	}

	List<KlpChoiceOption> _options() => [const KlpChoiceOption(id: 'a', label: '選項 A'), const KlpChoiceOption(id: 'b', label: '選項 B'), KlpChoiceOption(id: 'c', label: '選項 C', disabled: _extra)];
	List<KlpPhaseOption<int>> _phases() => [for (var i = 0; i < 3; i++) KlpPhaseOption(value: i, label: '階段 ${i + 1}', icon: _extra ? KlpIcons.check : null)];
	List<KlpSelectionOption> _selectionOptions() => [for (final tone in [KlpSelectionTone.info, KlpSelectionTone.warning, KlpSelectionTone.success]) KlpSelectionOption(icon: KlpIcons.check, tone: _extra ? tone : KlpSelectionTone.neutral)];

	Widget _target() {
		final label = _label.text;
		switch (widget.name) {
			case 'KlpCheckbox': return KlpCheckbox(value: _value, label: label, showLabel: !_extra, onChanged: _disabled ? null : _onBool);
			case 'KlpToggle': return KlpToggle(value: _value, label: label, showLabel: !_extra, onChanged: _disabled ? null : _onBool);
			case 'KlpCompactSwitch': return KlpCompactSwitch(value: _value, label: label, onChanged: _disabled ? null : _onBool);
			case 'KlpToggleIndicator': return KlpToggleIndicator(value: _value, enabled: !_disabled);
			case 'KlpTriStateToggle': return KlpTriStateToggle(value: _triState, label: label, onChanged: _disabled ? null : _onTriState);
			case 'KlpRadioGroup': return KlpRadioGroup<int>(items: const {0: '選項 A', 1: '選項 B', 2: '選項 C'}, value: _index, vertical: _layout, descriptions: _extra ? const {0: '說明 A', 1: '說明 B', 2: '說明 C'} : null, onChanged: _onIndex);
			case 'KlpSegmentedControl': return KlpSegmentedControl(items: const ['選項 A', '選項 B', '選項 C'], selected: _index, expanded: _layout, dense: _dense, icons: _extra ? const [KlpIcons.check, KlpIcons.check, KlpIcons.check] : null, onSelected: _onIndex);
			case 'KlpPhaseToggle': return KlpPhaseToggle<int>(options: _phases(), selected: _index, enabled: !_disabled, onSelected: _onIndex);
			case 'KlpSlidingSelection': return KlpSlidingSelection(label: label, selectedIndex: _index, options: _selectionOptions(), onSelected: _disabled ? null : _onIndex);
			case 'KlpSelect': return KlpSelect(label: label, value: '選項 ${['A', 'B', 'C'][_index]}', enabled: !_disabled, onPressed: _selectNext);
			case 'KlpSelectField': return KlpSelectField(label: label, valueLabel: '選項 ${['A', 'B', 'C'][_index]}', options: _options(), enabled: !_disabled, readOnly: _readOnly, error: _errorText, onSelected: _onChoice);
			case 'KlpMultiSelectField': return KlpMultiSelectField(label: label, options: _options(), selectedIds: _selected, enabled: !_disabled, readOnly: _readOnly, error: _errorText, onChanged: _onMulti);
			case 'KlpNumberField': return KlpNumberField(label: label, value: _number, minimum: 0, maximum: _maximum, unit: _extra ? '個' : null, error: _errorText, onChanged: _disabled ? null : _onNumber);
			case 'KlpQuantityField': return KlpQuantityField(label: label, value: _number, step: _extra ? 5 : 1, minimum: 0, maximum: _maximum, enabled: !_disabled, readOnly: _readOnly, error: _errorText, decreaseLabel: '減少數量', increaseLabel: '增加數量', onChanged: _onQuantity);
			case 'KlpSlider': return KlpSlider(label: label, value: _number, max: _maximum, divisions: _extra ? 10 : null, marks: _extra ? ['0', '${_maximum / 2}', '$_maximum'] : null, displayValue: _dense ? '$_number 個' : null, onChanged: _disabled ? null : _onNumber);
			case 'KlpAffixedTextField': return KlpAffixedTextField(label: label, controller: _draft, placeholder: '實際元件輸入', prefixText: _extra ? '前綴' : null, actionIcon: _layout ? KlpIcons.check : null, actionLabel: _layout ? '附加動作' : null, onAction: _layout ? () => _record('附加動作') : null, enabled: !_disabled, readOnly: _readOnly, error: _errorText, onChanged: _onText);
			case 'KlpPasswordField': return KlpPasswordField(label: label, value: _draft.text, placeholder: '純展示字串', enabled: !_disabled, readOnly: _readOnly, required: _layout, error: _errorText, requirements: _extra ? [KlpPasswordRequirement(label: '至少六個字元', satisfied: _draft.text.length >= 6)] : null, onChanged: _onText);
			case 'KlpTextArea': return KlpTextArea(label: label, value: _draft.text, placeholder: '實際元件輸入', error: _errorText, enabled: !_disabled, minLines: _dense ? 3 : 2, maxLines: _extra ? null : 4, unboundedLines: _extra, outlined: _layout, onChanged: _onText);
			case 'KlpTagChip':
				if (_removed) return const KlpText('consumer 已移除標籤，可恢復或重設');
				return KlpTagChip(label: label, onRemove: _disabled ? null : _removeChip);
			case 'KlpTagInputField': return KlpTagInputField(label: label, tags: _tags, maxCount: _layout ? 3 : null, onAdd: _disabled ? null : _addTag, onRemove: _disabled ? null : _removeTag, onClearAll: _extra && !_disabled ? _clearTags : null);
			case 'KlpField': return KlpField(label: label, description: _extra ? '欄位說明' : null, requirement: _extra ? '至少一個字元' : null, required: _layout, status: _extra ? '展示狀態' : null, counter: _extra ? '${_draft.text.length} 字' : null, error: _errorText, errorCode: _error ? 'DEMO' : null, child: KlpTextField(controller: _draft, onChanged: _onText));
			case 'KlpFieldLabel': return KlpFieldLabel(label: label);
			case 'KlpFieldDescription': return KlpFieldDescription(description: label);
			case 'KlpFieldError': return KlpFieldError(error: label);
			default: return const KlpText('未知的表單 target');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpCheckbox':
			case 'KlpToggle': return '${widget.name}(value: value, label: label, showLabel: ${!_extra}, onChanged: ${_disabled ? 'null' : 'onBool'})';
			case 'KlpCompactSwitch': return 'KlpCompactSwitch(value: value, label: label, onChanged: ${_disabled ? 'null' : 'onBool'})';
			case 'KlpToggleIndicator': return 'KlpToggleIndicator(value: value, enabled: ${!_disabled})';
			case 'KlpTriStateToggle': return 'KlpTriStateToggle(value: KlpTriState.${_triState.name}, label: label, onChanged: ${_disabled ? 'null' : 'onTriState'})';
			case 'KlpRadioGroup': return 'KlpRadioGroup<int>(items: items, value: selected, vertical: $_layout, descriptions: ${_extra ? 'descriptions' : 'null'}, onChanged: onIndex)';
			case 'KlpSegmentedControl': return 'KlpSegmentedControl(items: items, selected: selected, expanded: $_layout, dense: $_dense, icons: ${_extra ? 'icons' : 'null'}, onSelected: onIndex)';
			case 'KlpPhaseToggle': return 'KlpPhaseToggle<int>(options: options, selected: selected, enabled: ${!_disabled}, onSelected: onIndex)';
			case 'KlpSlidingSelection': return 'KlpSlidingSelection(label: label, selectedIndex: selected, options: options, onSelected: ${_disabled ? 'null' : 'onIndex'})';
			case 'KlpSelect': return 'KlpSelect(label: label, value: valueLabel, enabled: ${!_disabled}, onPressed: selectNext)';
			case 'KlpSelectField': return 'KlpSelectField(label: label, valueLabel: valueLabel, options: options, enabled: ${!_disabled}, readOnly: $_readOnly, error: error, onSelected: onChoice)';
			case 'KlpMultiSelectField': return 'KlpMultiSelectField(label: label, options: options, selectedIds: selectedIds, enabled: ${!_disabled}, readOnly: $_readOnly, error: error, onChanged: onMulti)';
			case 'KlpNumberField': return 'KlpNumberField(label: label, value: value, minimum: 0, maximum: $_maximum, unit: ${_extra ? 'unit' : 'null'}, error: error, onChanged: ${_disabled ? 'null' : 'onNumber'})';
			case 'KlpQuantityField': return 'KlpQuantityField(label: label, value: value, step: ${_extra ? 5 : 1}, minimum: 0, maximum: $_maximum, enabled: ${!_disabled}, readOnly: $_readOnly, error: error, decreaseLabel: decreaseLabel, increaseLabel: increaseLabel, onChanged: onQuantity)';
			case 'KlpSlider': return 'KlpSlider(label: label, value: value, max: $_maximum, divisions: ${_extra ? 10 : 'null'}, marks: ${_extra ? 'marks' : 'null'}, displayValue: ${_dense ? 'displayValue' : 'null'}, onChanged: ${_disabled ? 'null' : 'onNumber'})';
			case 'KlpAffixedTextField': return 'KlpAffixedTextField(label: label, controller: controller, placeholder: placeholder, prefixText: ${_extra ? 'prefix' : 'null'}, actionIcon: ${_layout ? 'KlpIcons.check' : 'null'}, actionLabel: ${_layout ? 'actionLabel' : 'null'}, onAction: ${_layout ? 'onAction' : 'null'}, enabled: ${!_disabled}, readOnly: $_readOnly, error: error, onChanged: onText)';
			case 'KlpPasswordField': return 'KlpPasswordField(label: label, value: value, placeholder: placeholder, enabled: ${!_disabled}, readOnly: $_readOnly, required: $_layout, error: error, requirements: ${_extra ? 'requirements' : 'null'}, onChanged: onText)';
			case 'KlpTextArea': return 'KlpTextArea(label: label, value: value, placeholder: placeholder, error: error, enabled: ${!_disabled}, minLines: ${_dense ? 3 : 2}, maxLines: ${_extra ? 'null' : 4}, unboundedLines: $_extra, outlined: $_layout, onChanged: onText)';
			case 'KlpTagChip': return 'KlpTagChip(label: label, onRemove: ${_disabled ? 'null' : 'removeChip'})';
			case 'KlpTagInputField': return 'KlpTagInputField(label: label, tags: tags, maxCount: ${_layout ? 3 : 'null'}, onAdd: ${_disabled ? 'null' : 'addTag'}, onRemove: ${_disabled ? 'null' : 'removeTag'}, onClearAll: ${_extra && !_disabled ? 'clearTags' : 'null'})';
			case 'KlpField': return 'KlpField(label: label, description: description, requirement: requirement, required: $_layout, status: status, counter: counter, error: error, errorCode: errorCode, child: field)';
			case 'KlpFieldLabel': return 'KlpFieldLabel(label: text)';
			case 'KlpFieldDescription': return 'KlpFieldDescription(description: text)';
			case 'KlpFieldError': return 'KlpFieldError(error: text)';
			default: return '未知 target';
		}
	}

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final controls = Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls());
		final target = SizedBox(height: 280, child: SingleChildScrollView(child: _target()));
		final editor = KlpTextField(controller: _label, placeholder: '修改 target 文字', onChanged: _onLabel);
		final status = KlpText('target 回呼 $_callbacks 次 · $_message · 控制文字回呼 $_controlChanges 次', role: KlpTextRole.code);
		final value = KlpText('value $_value · selected $_index · number $_number · triState ${_triState.name} · selectedIds ${_selected.join(', ')} · tags ${_tags.join(', ')}', role: KlpTextRole.code);
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [controls, SizedBox(height: space.contentStackGap), target, if (widget.name != 'KlpToggleIndicator') editor, status, value, KlpText(_usage(), role: KlpTextRole.code)]);
	}
}
