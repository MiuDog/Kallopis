import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 每個名稱都有自己的公開 target 與資料 controls。 */
const progressCollectionSpecimenNames = <String>['KlpProgress', 'KlpStepper', 'KlpTaskList', 'KlpScheduleList', 'KlpTimeline'];

class ProgressCollectionComponentSpecimen extends StatefulWidget {
	const ProgressCollectionComponentSpecimen({super.key, required this.name});
	/* 名稱只決定展示自己的 constructor。 */
	final String name;
	@override
	State<ProgressCollectionComponentSpecimen> createState() => _ProgressCollectionComponentSpecimenState();
}

class _ProgressCollectionComponentSpecimenState extends State<ProgressCollectionComponentSpecimen> {
	/* 草稿及清單由 consumer 擁有，不跟隨主題重建。 */
	final _title = TextEditingController(text: '進度標題');
	final _detail = TextEditingController(text: '進度說明');
	final _draft = TextEditingController(text: '時間線 child 草稿');
	final _checked = <int>{};
	bool _extra = false;
	bool _flag = false;
	bool _enabled = true;
	int _state = 0;
	int _count = 3;
	int _current = 0;
	int _tone = 0;
	double _value = 0.25;
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _title.dispose(); _detail.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _cancel() => setState(() { _rootCalls++; _result = 'consumer 收到取消 $_rootCalls'; });
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _task(int index, bool checked) => setState(() { if (checked) { _checked.add(index); } else { _checked.remove(index); } _flag = _checked.length == _count; _rootCalls++; _result = 'task $index checked：$checked'; });
	void _checkAll() => setState(() { _flag = !_flag; _checked.clear(); if (_flag) _checked.addAll(List.generate(_count, (index) => index)); });
	void _countChange() => setState(() { _count = _count == 3 ? 1 : 3; _current = _current.clamp(0, _count - 1); _checked.removeWhere((id) => id >= _count); if (widget.name == 'KlpTaskList') _flag = _checked.length == _count; });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _extraControl(String label) => _control('$label：$_extra', () => setState(() => _extra = !_extra));
	Widget _flagControl(String label) => _control('$label：$_flag', () => setState(() => _flag = !_flag));
	Widget _callbackControl() => _control('root callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _countControl() => _control('items：$_count', _countChange);

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpProgress': return [_control('value：$_value', () => setState(() => _value = _value == 1 ? 0 : _value + 0.25)), _flagControl('value=null'), _extraControl('trailing／detail'), _control('state：${KlpProgressState.values[_state].name}', () => setState(() => _state = (_state + 1) % KlpProgressState.values.length)), _callbackControl()];
			case 'KlpStepper': return [_countControl(), _control('currentIndex：$_current', () => setState(() => _current = (_current + 1) % _count)), _extraControl('description'), _control('direction：${_flag ? 'vertical' : 'horizontal'}', () => setState(() => _flag = !_flag))];
			case 'KlpTaskList': return [_countControl(), _control('全部 checked：$_flag', _checkAll), _callbackControl()];
			case 'KlpScheduleList': return [_countControl(), _extraControl('tag'), _control('tone：${KlpFeedbackTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpFeedbackTone.values.length))];
			case 'KlpTimeline': return [_countControl(), _extraControl('time／marker／content'), _flagControl('highlighted')];
			default: return const [];
		}
	}

	Widget _timelineContent(int index) {
		if (index != 0) return KlpText('${_detail.text} $index');
		return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '時間線 child 動作', onPressed: _childAction)]);
	}

	Widget _stepper() {
		final target = KlpStepper(steps: [for (var i = 0; i < _count; i++) KlpStepData(label: '${_title.text} $i', description: _extra ? _detail.text : null)], currentIndex: _current, direction: _flag ? KlpStepperDirection.vertical : KlpStepperDirection.horizontal);
		if (_flag) return target;
		/* 水平步驟的 consumer 捲動宿主維持可閱讀寬度，沒有改寫核心布局。 */
		return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: 720, child: target));
	}

	Widget _target() {
		switch (widget.name) {
			case 'KlpProgress': return KlpProgress(value: _flag ? null : _value, label: _title.text, trailing: _extra ? 'consumer 狀態' : null, detail: _extra ? _detail.text : null, state: KlpProgressState.values[_state], onCancel: _enabled ? _cancel : null, cancelLabel: _detail.text);
			case 'KlpStepper': return _stepper();
			case 'KlpTaskList': return KlpTaskList(items: [for (var i = 0; i < _count; i++) KlpTaskItemData(id: 'task-$i', title: '${_title.text} $i', detail: _detail.text, checked: _checked.contains(i))], onChanged: _enabled ? _task : null);
			case 'KlpScheduleList': return KlpScheduleList(items: [for (var i = 0; i < _count; i++) KlpScheduleItemData(id: 'schedule-$i', time: '${9 + i}:00', title: '${_title.text} $i', tag: _extra ? _detail.text : null, tone: KlpFeedbackTone.values[_tone])]);
			case 'KlpTimeline': return KlpTimeline(items: [for (var i = 0; i < _count; i++) KlpTimelineItemData(title: '${_title.text} $i', time: _extra ? '10:0$i' : null, content: _extra ? _timelineContent(i) : null, marker: _extra ? const KlpText('•') : null, highlighted: _flag)]);
			default: return KlpText('未知進度展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpProgress': return 'KlpProgress(value: value, label: label, trailing: trailing, detail: detail, state: state, onCancel: onCancel, cancelLabel: cancelLabel)';
			case 'KlpStepper': return 'KlpStepper(steps: List<KlpStepData>, currentIndex: currentIndex, direction: direction)';
			case 'KlpTaskList': return 'KlpTaskList(items: List<KlpTaskItemData>, onChanged: onChanged)';
			case 'KlpScheduleList': return 'KlpScheduleList(items: List<KlpScheduleItemData>)';
			case 'KlpTimeline': return 'KlpTimeline(items: List<KlpTimelineItemData>)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _title, placeholder: '公開 label／title', onChanged: _edit),
		KlpTextField(controller: _detail, placeholder: '公開 detail／description／cancelLabel', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target())),
		KlpText('root 回呼：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText(_result),
		KlpText('checked：${_checked.toList()..sort()}；items：$_count'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
