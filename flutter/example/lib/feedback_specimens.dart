import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 整個 feedback 公開 renderable module 都有自己的實際 target。 */
const feedbackSpecimenNames = <String>['KlpEmptyState', 'KlpErrorState', 'KlpFocusBoundary', 'KlpInlineNotice', 'KlpLiveRegion', 'KlpLoadingState', 'KlpPermissionState', 'KlpProgressOverlay', 'KlpRegionPlaceholder', 'KlpSkeletonLine', 'KlpStatusIndicator', 'KlpToast', 'KlpToastStack', 'KlpWorkflowProgress', 'KlpWorkflowStateSurface'];

class FeedbackComponentSpecimen extends StatefulWidget {
	const FeedbackComponentSpecimen({super.key, required this.name});
	/* 當次公開名稱只渲染自己的 fixture。 */
	final String name;
	@override
	State<FeedbackComponentSpecimen> createState() => _FeedbackComponentSpecimenState();
}

class _FeedbackComponentSpecimenState extends State<FeedbackComponentSpecimen> {
	/* 內容及動作結果由 consumer 擁有，environment 不清除 controller。 */
	final _title = TextEditingController(text: '展示標題');
	final _message = TextEditingController(text: '這是回饋內容，切換風格仍保留。');
	final _draft = TextEditingController(text: 'child 草稿保持');
	final _dismissed = <int>{};
	bool _actionEnabled = true;
	bool _extra = false;
	bool _flag = false;
	bool _visible = false;
	bool _wide = false;
	int _tone = KlpFeedbackTone.values.indexOf(KlpFeedbackTone.info);
	int _state = 0;
	int _kind = 0;
	int _actions = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _title.dispose(); _message.dispose(); _draft.dispose(); super.dispose(); }
	void _onEdit(String value) => setState(() => _edits++);
	void _onInput(String value) => setState(() => _inputs++);
	void _action() => setState(() { _actions++; _result = '動作 $_actions 已執行'; });
	void _close(int id) => setState(() { _dismissed.add(id); _actions++; _result = '已關閉 toast $id'; });
	void _restore() => setState(() => _dismissed.clear());
	void _toggleAction() => setState(() => _actionEnabled = !_actionEnabled);
	void _toggleExtra() => setState(() => _extra = !_extra);
	void _toggleFlag() => setState(() => _flag = !_flag);
	void _cycleTone() => setState(() => _tone = (_tone + 1) % KlpFeedbackTone.values.length);
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _actionControl() => _control('action／callback：$_actionEnabled', _toggleAction);
	Widget _toneControl() => _control('tone：${KlpFeedbackTone.values[_tone].name}', _cycleTone);

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpEmptyState': return [_actionControl(), _control('icon：${_extra ? 'folder' : 'check'}', _toggleExtra)];
			case 'KlpErrorState':
			case 'KlpPermissionState': return [_actionControl(), _control('icon：$_extra', _toggleExtra)];
			case 'KlpInlineNotice': return [_toneControl(), _actionControl(), _control('message：${!_extra}', _toggleExtra)];
			case 'KlpFocusBoundary': return [_control('autofocus：$_flag', _toggleFlag)];
			case 'KlpLiveRegion': return [_control('constructor：${_extra ? 'fromDescendants' : 'message'}', _toggleExtra), _control('message：${_flag ? 'null' : 'text'}', _toggleFlag)];
			case 'KlpProgressOverlay': return [_control('visible：$_visible', () => setState(() => _visible = !_visible))];
			case 'KlpRegionPlaceholder': return [_actionControl(), _control('hatched：${!_flag}', _toggleFlag), _control('detail：$_extra', _toggleExtra), _control('tone：${_visible ? 'pending' : 'neutral'}', () => setState(() => _visible = !_visible)), _control('constraints：${_wide ? '220／160' : '120／80'}', () => setState(() => _wide = !_wide))];
			case 'KlpSkeletonLine': return [_control('宿主寬度：${_wide ? 240 : 120}', () => setState(() => _wide = !_wide))];
			case 'KlpStatusIndicator': return [_control('data.kind：${KlpStatusKind.values[_kind].name}', () => setState(() => _kind = (_kind + 1) % KlpStatusKind.values.length)), _control('data.active：${!_flag}', _toggleFlag), _control('data.showsIndicator：${!_extra}', _toggleExtra), _control('expanded：$_wide', () => setState(() => _wide = !_wide))];
			case 'KlpToast': return [_toneControl(), _actionControl(), _control('onClose：${!_flag}', _toggleFlag), _control('message：${!_extra}', _toggleExtra), _control('恢復 toast', _restore)];
			case 'KlpToastStack': return [_control('children：${_extra ? 3 : 1}', _toggleExtra), _control('恢復 toast', _restore)];
			case 'KlpWorkflowProgress': return [_control('stages：${_extra ? 1 : 3}', _toggleExtra), _control('active／complete：$_state', () => setState(() => _state = (_state + 1) % 3)), _control('label：${!_flag}', _toggleFlag)];
			case 'KlpWorkflowStateSurface': return [_control('state：${KlpWorkflowState.values[_state].name}', () => setState(() => _state = (_state + 1) % KlpWorkflowState.values.length)), _actionControl(), _control('child：$_extra', _toggleExtra)];
			default: return const [];
		}
	}

	Widget _actionWidget() => KlpButton(label: 'child 動作', onPressed: _action);
	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpTextField(controller: _draft, placeholder: _title.text, onChanged: _onInput), _actionWidget()]);
	Widget _toast(int id) => KlpToast(title: '${_title.text} $id', message: _extra && widget.name == 'KlpToast' ? null : _message.text, tone: KlpFeedbackTone.values[_tone], actionLabel: _actionEnabled ? 'toast 動作 $id' : null, onAction: _actionEnabled ? _action : null, closeLabel: '關閉 toast $id', onClose: _flag ? null : () => _close(id));
	List<KlpWorkflowStageData> _stages() => [for (var i = 0; i < (_extra ? 1 : 3); i++) KlpWorkflowStageData(label: '階段 ${i + 1}', statusLabel: i < _state ? '已完成' : '待處理', complete: i < _state, active: i == _state)];

	Widget _target() {
		final title = _title.text;
		final message = _message.text;
		switch (widget.name) {
			case 'KlpEmptyState': return KlpEmptyState(icon: _extra ? KlpIcons.folder : KlpIcons.check, title: title, message: message, action: _actionEnabled ? _actionWidget() : null);
			case 'KlpErrorState': return KlpErrorState(title: title, message: message, icon: _extra ? KlpIcons.check : null, retryLabel: '重試動作', onRetry: _actionEnabled ? _action : null);
			case 'KlpPermissionState': return KlpPermissionState(title: title, message: message, icon: _extra ? KlpIcons.check : null, action: _actionEnabled ? _actionWidget() : null);
			case 'KlpInlineNotice': return KlpInlineNotice(title: title, message: _extra ? null : message, tone: KlpFeedbackTone.values[_tone], action: _actionEnabled ? _actionWidget() : null);
			case 'KlpLoadingState': return KlpLoadingState(label: title);
			case 'KlpFocusBoundary': return KlpFocusBoundary(key: ValueKey(_flag), autofocus: _flag, child: _child());
			case 'KlpLiveRegion':
				final child = Column(mainAxisSize: MainAxisSize.min, children: [KlpText('$message · $_result'), _actionWidget()]);
				if (_extra) return KlpLiveRegion.fromDescendants(child: child);
				return KlpLiveRegion(message: _flag ? null : '$message · $_result', child: child);
			case 'KlpProgressOverlay': return SizedBox(height: 200, child: KlpProgressOverlay(visible: _visible, label: title, child: _child()));
			case 'KlpRegionPlaceholder': return KlpRegionPlaceholder(label: title, kindLabel: '展示區域', detail: _extra ? message : null, hatched: !_flag, tone: _visible ? KlpRegionPlaceholderTone.pending : KlpRegionPlaceholderTone.neutral, constraints: KlpBoxConstraints(minWidth: _wide ? 220 : 120, minHeight: _wide ? 160 : 80), actionLabel: _actionEnabled ? 'placeholder 動作' : null, onAction: _actionEnabled ? _action : null);
			case 'KlpSkeletonLine': return Align(alignment: Alignment.topLeft, child: SizedBox(width: _wide ? 240 : 120, child: const KlpSkeletonLine()));
			case 'KlpStatusIndicator': return KlpStatusIndicator(data: KlpStatusItemData(label: title, kind: KlpStatusKind.values[_kind], active: !_flag, showsIndicator: !_extra), expanded: _wide);
			case 'KlpToast':
				if (_dismissed.contains(1)) return const KlpText('consumer 已移除 toast，可恢復或重設');
				return _toast(1);
			case 'KlpToastStack': return KlpToastStack(children: [for (var i = 1; i <= (_extra ? 3 : 1); i++) if (!_dismissed.contains(i)) _toast(i)]);
			case 'KlpWorkflowProgress': return KlpWorkflowProgress(stages: _stages(), label: _flag ? null : title);
			case 'KlpWorkflowStateSurface': return KlpWorkflowStateSurface(state: KlpWorkflowState.values[_state], title: title, message: message, statusLabel: '展示狀態 $_state', actionLabel: _actionEnabled ? 'workflow 動作' : null, onAction: _actionEnabled ? _action : null, child: _extra ? _child() : null);
			default: return const KlpText('未知的 feedback target');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpEmptyState': return 'KlpEmptyState(icon: icon, title: title, message: message, action: action)';
			case 'KlpErrorState': return 'KlpErrorState(title: title, message: message, icon: icon, retryLabel: retryLabel, onRetry: onRetry)';
			case 'KlpPermissionState': return 'KlpPermissionState(title: title, message: message, icon: icon, action: action)';
			case 'KlpInlineNotice': return 'KlpInlineNotice(title: title, message: message, tone: KlpFeedbackTone.${KlpFeedbackTone.values[_tone].name}, action: action)';
			case 'KlpLoadingState': return 'KlpLoadingState(label: title)';
			case 'KlpFocusBoundary': return 'KlpFocusBoundary(autofocus: $_flag, child: child)';
			case 'KlpLiveRegion': return _extra ? 'KlpLiveRegion.fromDescendants(child: child)' : 'KlpLiveRegion(message: message, child: child)';
			case 'KlpProgressOverlay': return 'SizedBox(height: 200, child: KlpProgressOverlay(visible: $_visible, label: title, child: child))';
			case 'KlpRegionPlaceholder': return 'KlpRegionPlaceholder(label: title, kindLabel: kindLabel, detail: detail, hatched: ${!_flag}, tone: tone, constraints: constraints, actionLabel: actionLabel, onAction: onAction)';
			case 'KlpSkeletonLine': return 'SizedBox(width: ${_wide ? 240 : 120}, child: KlpSkeletonLine()) // 寬度是宿主，不是 target props';
			case 'KlpStatusIndicator': return 'KlpStatusIndicator(data: KlpStatusItemData(label: label, kind: kind, active: ${!_flag}, showsIndicator: ${!_extra}), expanded: $_wide)';
			case 'KlpToast': return 'KlpToast(title: title, message: message, tone: tone, actionLabel: actionLabel, onAction: onAction, closeLabel: closeLabel, onClose: onClose)';
			case 'KlpToastStack': return 'KlpToastStack(children: toasts) // child Toast 的回呼回寫 consumer 清單';
			case 'KlpWorkflowProgress': return 'KlpWorkflowProgress(stages: stages, label: label)';
			case 'KlpWorkflowStateSurface': return 'KlpWorkflowStateSurface(state: KlpWorkflowState.${KlpWorkflowState.values[_state].name}, title: title, message: message, statusLabel: statusLabel, actionLabel: actionLabel, onAction: onAction, child: child)';
			default: return '未知 target';
		}
	}

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final controls = Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls());
		final target = SizedBox(height: 280, child: SingleChildScrollView(child: _target()));
		final title = KlpTextField(controller: _title, placeholder: widget.name == 'KlpFocusBoundary' ? '修改 child placeholder' : '修改 target 標題／label', onChanged: _onEdit);
		final message = KlpTextField(controller: _message, placeholder: '修改 target message', onChanged: _onEdit);
		final status = KlpText('動作回呼 $_actions 次 · $_result · child 輸入 $_inputs 次 · 控制文字 $_edits 次', role: KlpTextRole.code);
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [controls, SizedBox(height: space.contentStackGap), target, if (!['KlpSkeletonLine', 'KlpLiveRegion'].contains(widget.name)) title, if (!['KlpSkeletonLine', 'KlpLoadingState', 'KlpStatusIndicator', 'KlpFocusBoundary'].contains(widget.name)) message, status, KlpText(_usage(), role: KlpTextRole.code)]);
	}
}
