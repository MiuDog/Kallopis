import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 每個名稱對應自己的公開 target，不以其他元件總覽補清冊。 */
const advancedFormSpecimenNames = <String>['KlpApprovalStepsField', 'KlpCalendar', 'KlpCodeEditorField', 'KlpCodeField', 'KlpColorRoleField', 'KlpCombobox', 'KlpDateField', 'KlpDateRangeField', 'KlpFileDropzoneField', 'KlpFileField', 'KlpOklchColorEditor', 'KlpOklchColorPicker', 'KlpReferencePicker', 'KlpStatusRoleSwatches'];

class AdvancedFormComponentSpecimen extends StatefulWidget {
	/* name：公開路由；環境變更保留 consumer State。 */
	final String name;
	const AdvancedFormComponentSpecimen({super.key, required this.name});
	@override
	State<AdvancedFormComponentSpecimen> createState() => _AdvancedFormComponentSpecimenState();
}

class _AdvancedFormComponentSpecimenState extends State<AdvancedFormComponentSpecimen> {
	/* 控制文字、呈現code及range草稿各有自己的權威並於dispose清理。 */
	final _label = TextEditingController(text: '進階表單資料');
	final _source = TextEditingController(text: 'const title = "Kallopis";');
	final _start = TextEditingController(text: '2026-10-13');
	final _end = TextEditingController(text: '2026-10-20');
	/* 公開參數由 consumer 投影，不另建共用樣式或互動算法。 */
	bool _enabled = true;
	bool _extra = true;
	bool _error = false;
	bool _warning = false;
	bool _readOnly = false;
	bool _loading = false;
	bool _freeText = false;
	bool _limit = false;
	bool _disabledDates = false;
	bool _sunday = false;
	int _mode = 0;
	int _progress = 0;
	/* 日期、查詢、色彩與集合皆為產品資料，原回呼只回存結果。 */
	DateTime _month = DateTime(2026, 10);
	DateTime _selectedDate = DateTime(2026, 10, 13);
	KlpCalendarRange? _range;
	String _date = '2026-10-13';
	String _query = '';
	String _choice = 'text';
	String _code = 'const title = "Kallopis";';
	KlpStatusRole? _status;
	KlpOklchColor _color = const KlpOklchColor(lightness: .6, chroma: .1, hue: 220);
	List<KlpApprovalStepData> _steps = const [KlpApprovalStepData(id: 'step-a', roleLabel: '檢閱者'), KlpApprovalStepData(id: 'step-b', roleLabel: '確認者')];
	List<String> _files = ['fixture-a', 'fixture-b'];
	int _next = 1;
	/* 原回呼、footer child與控制文字分計數，不將props控制冒充元件事件。 */
	int _roots = 0;
	int _children = 0;
	int _edits = 0;
	String _result = '尚未觸發原回呼';
	@override
	void dispose() { _label.dispose(); _source.dispose(); _start.dispose(); _end.dispose(); super.dispose(); }
	void _root(String value) => setState(() { _roots++; _result = value; });
	void _edit(String value) => setState(() => _edits++);
	void _childAction() => setState(() => _children++);
	String _formatDate(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
	String get _monthLabel => '${_month.year}年${_month.month}月';
	void _selectDate(DateTime date) {
		_selectedDate = date;
		_date = _formatDate(date);
		if (_range == null || _range!.end != null) { _range = KlpCalendarRange(start: date); }
		else { final first = _range!.start; _range = KlpCalendarRange(start: date.isBefore(first) ? date : first, end: date.isBefore(first) ? first : date); }
		_root('onDateSelected：$_date');
	}
	void _changeMonth(int delta) { _month = DateTime(_month.year, _month.month + delta); _root('month：$_monthLabel'); }
	bool _isDateDisabled(DateTime date) => _disabledDates && date.weekday == DateTime.sunday;
	void _dateChanged(String value) { _date = value; _root('onChanged：$value'); }
	void _codeChanged(String value) { _code = value; _root('onChanged：$value'); }
	void _queryChanged(String value) { _query = value; _root('onQueryChanged：$value'); }
	void _choiceSelected(String id) { _choice = id; _root('onSelected：$id'); }
	void _comboSelected(KlpComboboxOption option) { _choice = option.id; _query = option.label; _root('onSelected：${option.id}'); }
	void _freeSubmitted(String value) { _query = value; _root('onFreeTextSubmitted：$value'); }
	void _statusSelected(KlpStatusRole role) { _status = role; _root('onSelectRole：${role.name}'); }
	void _colorChanged(KlpOklchColor color) { _color = color; _root('onChanged：OKLCH'); }
	void _addStep() { _steps = [..._steps, KlpApprovalStepData(id: 'step-new-${_next++}', roleLabel: '新增檢閱者')]; _root('onAddStep'); }
	void _moveStep(int index, int delta) {
		final target = index + delta;
		if (index >= 0 && index < _steps.length && target >= 0 && target < _steps.length) { final next = List<KlpApprovalStepData>.of(_steps); next.insert(target, next.removeAt(index)); _steps = next; }
		_root('${delta < 0 ? 'onMoveUp' : 'onMoveDown'}：$index');
	}
	void _removeStep(int index) { if (index >= 0 && index < _steps.length) { _steps = List.of(_steps)..removeAt(index); } _root('onRemove：$index'); }
	void _chooseFile() { _files = [..._files, 'fixture-new-${_next++}']; _root('onChoose：宿主新增範例資料'); }
	void _removeFile(String id) { _files = _files.where((file) => file != id).toList(); _root('onRemove：$id'); }
	void _removeAttachment(int index) { final id = index >= 0 && index < _files.length ? _files[index] : 'invalid-$index'; _removeFile(id); }
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _enabledControl() => _control('enabled／callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _extraControl() => _control('optional content：$_extra', () => setState(() => _extra = !_extra));
	Widget _errorControl() => _control('error：$_error', () => setState(() => _error = !_error));
	Widget _readOnlyControl() => _control('readOnly：$_readOnly', () => setState(() => _readOnly = !_readOnly));
	String? get _errorText => _error ? '展示錯誤：請確認資料' : null;
	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpApprovalStepsField': return [_enabledControl(), _extraControl(), _control('maxSteps：${_limit ? 3 : 'null'}', () => setState(() => _limit = !_limit)), _control('consumer empty／restore', () => setState(() => _steps = _steps.isEmpty ? const [KlpApprovalStepData(id: 'step-a', roleLabel: '檢閱者'), KlpApprovalStepData(id: 'step-b', roleLabel: '確認者')] : []))];
			case 'KlpCalendar': return [_enabledControl(), _extraControl(), _control('mode：${KlpCalendarSelectionMode.values[_mode].name}', () => setState(() => _mode = (_mode + 1) % KlpCalendarSelectionMode.values.length)), _control('disabled Sundays：$_disabledDates', () => setState(() => _disabledDates = !_disabledDates)), _control('firstWeekday：${_sunday ? 'Sunday' : 'Monday'}', () => setState(() => _sunday = !_sunday))];
			case 'KlpCodeEditorField': return [_extraControl(), _errorControl(), _control('warning：$_warning', () => setState(() => _warning = !_warning))];
			case 'KlpCodeField': return [_enabledControl(), _extraControl(), _errorControl(), _readOnlyControl()];
			case 'KlpColorRoleField': return [_enabledControl()];
			case 'KlpCombobox': return [_enabledControl(), _extraControl(), _errorControl(), _control('allowFreeText：$_freeText', () => setState(() => _freeText = !_freeText))];
			case 'KlpDateField': return [_enabledControl(), _extraControl(), _control('disabled Sundays：$_disabledDates', () => setState(() => _disabledDates = !_disabledDates))];
			case 'KlpDateRangeField': return [_enabledControl(), _extraControl(), _errorControl(), _readOnlyControl()];
			case 'KlpFileDropzoneField': return [_enabledControl(), _extraControl(), _control('progress：${_progress == 0 ? 'null' : _progress / 2}', () => setState(() => _progress = (_progress + 1) % 3)), _control('consumer empty／restore', () => setState(() => _files = _files.isEmpty ? ['fixture-a', 'fixture-b'] : []))];
			case 'KlpFileField': return [_enabledControl(), _control('consumer empty／restore', () => setState(() => _files = _files.isEmpty ? ['fixture-a', 'fixture-b'] : []))];
			case 'KlpOklchColorEditor':
			case 'KlpOklchColorPicker': return [_enabledControl(), _control('chromaRange：${_extra ? 'standard' : 'custom(0.6)'}', () => setState(() => _extra = !_extra))];
			case 'KlpReferencePicker': return [_enabledControl(), _control('loading：$_loading', () => setState(() => _loading = !_loading))];
			case 'KlpStatusRoleSwatches': return [_enabledControl(), _extraControl(), _control('selectedRole：${_status?.name ?? 'null'}', () => setState(() => _status = _status == null ? KlpStatusRole.values.first : null))];
			default: return const [];
		}
	}
	List<KlpComboboxOption> get _comboOptions => const [KlpComboboxOption(id: 'text', label: '語意文字'), KlpComboboxOption(id: 'surface', label: '語意表面'), KlpComboboxOption(id: 'space', label: '語意間距')].where((option) => option.label.contains(_query)).toList();
	List<KlpReferenceOption> get _references => const [KlpReferenceOption(id: 'component', label: '元件規範', kind: '規範', metadata: '公開元件'), KlpReferenceOption(id: 'style', label: '風格規範', kind: '規範', metadata: '可替換風格'), KlpReferenceOption(id: 'blocked', label: '停用參照', disabled: true)].where((option) => option.label.contains(_query)).toList();
	KlpDateFieldCalendar _calendarData() => KlpDateFieldCalendar(month: _month, monthLabel: _monthLabel, weekdayLabels: const ['一', '二', '三', '四', '五', '六', '日'], previousMonthLabel: '上個月', nextMonthLabel: '下個月', onDateSelected: _selectDate, selectedDate: _selectedDate, isDateDisabled: _isDateDisabled, onPreviousMonth: () => _changeMonth(-1), onNextMonth: () => _changeMonth(1), today: DateTime(2026, 10, 13));
	Widget _target() {
		switch (widget.name) {
			case 'KlpApprovalStepsField': return KlpApprovalStepsField(label: _label.text, subtitle: _extra ? 'consumer 投影的審核角色' : null, steps: _steps, onAddStep: _enabled ? _addStep : null, onMoveUp: _enabled ? (index) => _moveStep(index, -1) : null, onMoveDown: _enabled ? (index) => _moveStep(index, 1) : null, onRemove: _enabled ? _removeStep : null, maxSteps: _limit ? 3 : null);
			case 'KlpCalendar': return KlpCalendar(month: _month, monthLabel: '${_label.text}：$_monthLabel', weekdayLabels: _sunday ? const ['日', '一', '二', '三', '四', '五', '六'] : const ['一', '二', '三', '四', '五', '六', '日'], previousMonthLabel: '上個月', nextMonthLabel: '下個月', mode: KlpCalendarSelectionMode.values[_mode], selectedDate: _selectedDate, selectedRange: _range, today: _extra ? DateTime(2026, 10, 13) : null, isDateDisabled: _isDateDisabled, onDateSelected: _enabled ? _selectDate : null, onPreviousMonth: _enabled ? () => _changeMonth(-1) : null, onNextMonth: _enabled ? () => _changeMonth(1) : null, firstWeekday: _sunday ? DateTime.sunday : DateTime.monday, dayContentBuilder: _extra ? (date) => date.day == 13 ? const KlpBadge(label: '事件') : null : null);
			case 'KlpCodeEditorField': return KlpCodeEditorField(label: _label.text, subtitle: _extra ? 'code 與 actions 為呈現資料' : null, actions: _extra ? ['檢查（文字示意）', '格式（文字示意）'] : null, code: _source.text, error: _errorText, warning: _warning ? '展示警告：待確認' : null, footerLeft: _extra ? KlpButton(label: 'footer child 動作', onPressed: _childAction) : null, footerRight: _extra ? const KlpText('consumer footer') : null);
			case 'KlpCodeField': return KlpCodeField(label: _label.text, value: _code, language: _extra ? 'dart' : null, onChanged: _enabled ? _codeChanged : null, readOnly: _readOnly, error: _errorText);
			case 'KlpColorRoleField': return KlpColorRoleField(label: _label.text, roles: const [KlpChoiceOption(id: 'text', label: '語意文字'), KlpChoiceOption(id: 'surface', label: '語意表面'), KlpChoiceOption(id: 'space', label: '語意間距', disabled: true)], selectedId: _choice, onSelected: _enabled ? _choiceSelected : null);
			case 'KlpCombobox': return KlpCombobox(label: _label.text, query: _query, options: _comboOptions, menuLabel: '候選選項', onQueryChanged: _queryChanged, onSelected: _comboSelected, placeholder: _extra ? '搜尋語意' : null, helper: _extra ? 'consumer 依查詢投影候選' : null, error: _errorText, enabled: _enabled, allowFreeText: _freeText, onFreeTextSubmitted: _freeSubmitted);
			case 'KlpDateField': return KlpDateField(label: _label.text, value: _date, onChanged: _enabled ? _dateChanged : null, placeholder: _extra ? 'YYYY-MM-DD' : null, calendar: _extra ? _calendarData() : null);
			case 'KlpDateRangeField': return KlpDateRangeField(label: _label.text, startController: _start, endController: _end, startPlaceholder: _extra ? '開始日期' : null, endPlaceholder: _extra ? '結束日期' : null, onStartChanged: _enabled ? (value) => _root('onStartChanged：$value') : null, onEndChanged: _enabled ? (value) => _root('onEndChanged：$value') : null, onCalendarPressed: _enabled ? () => _root('onCalendarPressed：宿主入口') : null, enabled: _enabled, readOnly: _readOnly, error: _errorText, calendarLabel: _extra ? '日期範圍宿主入口' : null);
			case 'KlpFileDropzoneField': return KlpFileDropzoneField(label: _label.text, hint: _extra ? '此展示使用範例清單，未執行上傳或磁碟存取' : null, chooseButtonLabel: '宿主加入範例檔案', files: [for (final id in _files) KlpFileAttachment(name: '$id.txt', size: '2 KB', progress: _progress == 0 ? null : _progress / 2)], onChoose: _enabled ? _chooseFile : null, onRemove: _enabled ? _removeAttachment : null);
			case 'KlpFileField': return KlpFileField(label: _label.text, files: [for (final id in _files) KlpFileValue(id: id, name: '$id.txt', metadata: 'fixture：2 KB')], chooseLabel: '宿主加入範例檔案', onChoose: _enabled ? _chooseFile : null, onRemove: _enabled ? _removeFile : null);
			case 'KlpOklchColorEditor': return KlpOklchColorEditor(value: _color, onChanged: _enabled ? _colorChanged : null, chromaRange: _extra ? KlpOklchChromaRange.standard : const KlpOklchChromaRange.custom(.6));
			case 'KlpOklchColorPicker': return KlpOklchColorPicker(value: _color, onChanged: _enabled ? _colorChanged : null, chromaRange: _extra ? KlpOklchChromaRange.standard : const KlpOklchChromaRange.custom(.6));
			case 'KlpReferencePicker': return KlpReferencePicker(title: _label.text, query: _query, queryPlaceholder: '搜尋參照', results: _references, onQueryChanged: _queryChanged, onSelected: _enabled ? _choiceSelected : null, loading: _loading);
			case 'KlpStatusRoleSwatches': return KlpStatusRoleSwatches(label: _label.text, helper: _extra ? '自己的公開 status role' : null, selectedRole: _status, onSelectRole: _enabled ? _statusSelected : null);
			default: return const SizedBox.shrink();
		}
	}
	String _usage() => switch (widget.name) {
		'KlpApprovalStepsField' => 'KlpApprovalStepsField(label: label, steps: steps, onAddStep: onAdd, onMoveUp: onMoveUp, onMoveDown: onMoveDown, onRemove: onRemove)',
		'KlpCalendar' => 'KlpCalendar(month: month, monthLabel: monthLabel, weekdayLabels: weekdayLabels, previousMonthLabel: previousLabel, nextMonthLabel: nextLabel, onDateSelected: onDateSelected)',
		'KlpCodeEditorField' => 'KlpCodeEditorField(label: label, code: code, actions: actionLabels, footerLeft: footer)',
		'KlpCodeField' => 'KlpCodeField(label: label, value: code, onChanged: onChanged, readOnly: readOnly)',
		'KlpColorRoleField' => 'KlpColorRoleField(label: label, roles: roles, selectedId: selectedId, onSelected: onSelected)',
		'KlpCombobox' => 'KlpCombobox(label: label, query: query, options: options, menuLabel: menuLabel, onQueryChanged: onQueryChanged, onSelected: onSelected)',
		'KlpDateField' => 'KlpDateField(label: label, value: value, onChanged: onChanged, calendar: calendar)',
		'KlpDateRangeField' => 'KlpDateRangeField(label: label, startController: start, endController: end, onStartChanged: onStartChanged, onEndChanged: onEndChanged)',
		'KlpFileDropzoneField' => 'KlpFileDropzoneField(label: label, files: attachments, onChoose: onChoose, onRemove: onRemove)',
		'KlpFileField' => 'KlpFileField(label: label, files: files, chooseLabel: chooseLabel, onChoose: onChoose, onRemove: onRemove)',
		'KlpOklchColorEditor' => 'KlpOklchColorEditor(value: color, onChanged: onChanged, chromaRange: chromaRange)',
		'KlpOklchColorPicker' => 'KlpOklchColorPicker(value: color, onChanged: onChanged, chromaRange: chromaRange)',
		'KlpReferencePicker' => 'KlpReferencePicker(title: title, query: query, queryPlaceholder: placeholder, results: results, onQueryChanged: onQueryChanged, onSelected: onSelected)',
		'KlpStatusRoleSwatches' => 'KlpStatusRoleSwatches(label: label, selectedRole: role, onSelectRole: onSelectRole)',
		_ => '',
	};
	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls()), if (!widget.name.startsWith('KlpOklch')) KlpTextField(controller: _label, onChanged: _edit), if (widget.name == 'KlpCodeEditorField') KlpTextField(controller: _source, onChanged: _edit), SizedBox(height: space.itemGap), _target(), SizedBox(height: space.itemGap), KlpText('root 回呼：$_roots；footer child：$_children；控制文字：$_edits'), KlpText('date：$_date；month：$_monthLabel；range：${_range == null ? 'null' : '${_formatDate(_range!.start)}..${_range!.end == null ? 'null' : _formatDate(_range!.end!)}'}；choice：$_choice；query：$_query'), KlpText('range草稿：${_start.text}..${_end.text}；code：$_code'), KlpText('steps：${_steps.map((step) => step.id).join(', ')}；files：${_files.join(', ')}'), KlpText('OKLCH：${_color.lightness.toStringAsFixed(3)}／${_color.chroma.toStringAsFixed(3)}／${_color.hue.toStringAsFixed(1)}／${_color.alpha.toStringAsFixed(3)}；status：${_status?.name ?? 'null'}；最後回呼：$_result'), KlpText(_usage(), role: KlpTextRole.code)]);
	}
}
