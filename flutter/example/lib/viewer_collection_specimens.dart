import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 每個公開 viewer 直接渲染自己的 target。 */
const viewerCollectionSpecimenNames = <String>['KlpCodeViewer', 'KlpDiffViewer', 'KlpFilePreview', 'KlpTerminal'];

class ViewerCollectionComponentSpecimen extends StatefulWidget {
	const ViewerCollectionComponentSpecimen({super.key, required this.name});
	/* 展示名稱來自共同 registry，不重建產品 runtime。 */
	final String name;
	@override
	State<ViewerCollectionComponentSpecimen> createState() => _ViewerCollectionComponentSpecimenState();
}

class _ViewerCollectionComponentSpecimenState extends State<ViewerCollectionComponentSpecimen> {
	/* 示例內容由 consumer 擁有，主題切換保留資料與草稿。 */
	final _title = TextEditingController(text: '示意檔案.txt');
	final _content = TextEditingController(text: '示意內容');
	final _draft = TextEditingController(text: '預覽 child 草稿');
	final _reviewed = <int>{};
	bool _extra = false;
	bool _flag = false;
	bool _optional = false;
	bool _enabled = true;
	bool _cleared = false;
	bool _wrapped = false;
	bool _numbers = false;
	bool _view = false;
	bool _expanded = false;
	int _state = KlpFilePreviewState.values.indexOf(KlpFilePreviewState.ready);
	int _limitMode = 0;
	int _startLine = 1;
	String _language = 'markdown';
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';
	static const _languages = [KlpCodeLanguageOption(id: 'text', label: '示意文字'), KlpCodeLanguageOption(id: 'markdown', label: '示意預覽', supportsView: true)];
	static const _labels = KlpCodeViewerLabels(copy: '複製回呼', menu: '程式選單', toggleView: '預覽內容', languageMenu: '語言選單', wrap: '自動換行', lineNumbers: '行號');

	@override
	void dispose() { _title.dispose(); _content.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _record(String result) => setState(() { _rootCalls++; _result = result; });
	void _copy() => _record('copy 公開回呼（僅示意紀錄）');
	void _languageChange(String value) => setState(() { _language = value; _rootCalls++; _result = 'language：$value'; });
	void _wrap() => setState(() { _wrapped = !_wrapped; _rootCalls++; _result = 'wrapped：$_wrapped'; });
	void _lineNumbers() => setState(() { _numbers = !_numbers; _rootCalls++; _result = 'showLineNumbers：$_numbers'; });
	void _toggleView() => setState(() { _view = !_view; _rootCalls++; _result = 'viewSelected：$_view'; });
	void _expand() => setState(() { _expanded = !_expanded; _rootCalls++; _result = 'expanded：$_expanded'; });
	void _review(int id, bool approve) => setState(() { _reviewed.add(id); _rootCalls++; _result = 'line $id ${approve ? 'approve' : 'reject'}'; });
	void _clear() => setState(() { _cleared = true; _rootCalls++; _result = 'consumer 已清除示意 lines'; });
	void _open() => _record('onPressed 公開回呼（示意）');
	void _external() => _record('onOpenExternal 公開回呼（示意）');
	void _download() => _record('onDownload 公開回呼（示意）');
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _extraControl(String label) => _control('$label：$_extra', () => setState(() => _extra = !_extra));
	Widget _flagControl(String label) => _control('$label：$_flag', () => setState(() => _flag = !_flag));
	Widget _optionalControl(String label) => _control('$label：$_optional', () => setState(() => _optional = !_optional));
	Widget _callbackControl() => _control('root callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _limitControl() => _control('viewportLimit：${['null', 'fixed120', 'unbounded'][_limitMode]}', () => setState(() => _limitMode = (_limitMode + 1) % 3));

	KlpCodeViewportLimit? _limit() {
		switch (_limitMode) {
			case 1: return const KlpCodeViewportLimit.fixed(120);
			case 2: return const KlpCodeViewportLimit.unbounded();
			default: return null;
		}
	}

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpCodeViewer': return [_flagControl('loading'), _extraControl('content'), _optionalControl('expandable'), _control('startLine：$_startLine', () => setState(() => _startLine = _startLine == 1 ? 20 : 1)), _control('wrapped：$_wrapped', () => setState(() => _wrapped = !_wrapped)), _control('showLineNumbers：$_numbers', () => setState(() => _numbers = !_numbers)), _control('viewSelected：$_view', () => setState(() => _view = !_view)), _control('expanded：$_expanded', () => setState(() => _expanded = !_expanded)), _limitControl(), _callbackControl()];
			case 'KlpDiffViewer': return [_flagControl('line numbers'), _extraControl('approve／reject callback'), _limitControl(), _callbackControl(), _control('恢復示意 lines', () => setState(() => _reviewed.clear()))];
			case 'KlpFilePreview': return [_control('state：${KlpFilePreviewState.values[_state].name}', () => setState(() => _state = (_state + 1) % KlpFilePreviewState.values.length)), _extraControl('preview'), _optionalControl('textContent'), _flagControl('icon=folder'), _callbackControl()];
			case 'KlpTerminal': return [_extraControl('長 lines'), _limitControl(), _callbackControl(), _control('恢復示意 lines', () => setState(() => _cleared = false))];
			default: return const [];
		}
	}

	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const KlpText('consumer 提供的預覽内容'), KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '預覽 child 動作', onPressed: _childAction)]);
	String _code() => '${_content.text}\n第二行示意內容\n這是一段展示換行的較長文字，不執行程式或建立正文核心。';

	Widget _target() {
		switch (widget.name) {
			case 'KlpCodeViewer': return KlpCodeViewer(code: _code(), language: _language, languageOptions: _languages, labels: _labels, showLineNumbers: _numbers, startLine: _startLine, wrapped: _wrapped, loading: _flag, expandable: _optional, expanded: _expanded, viewportLimit: _limit(), content: _extra ? _child() : null, viewSelected: _view, onLanguageChanged: _enabled ? _languageChange : null, onToggleWrap: _enabled ? _wrap : null, onToggleLineNumbers: _enabled ? _lineNumbers : null, onToggleView: _enabled ? _toggleView : null, onToggleExpand: _enabled ? _expand : null, onCopy: _enabled ? _copy : null);
			case 'KlpDiffViewer': return KlpDiffViewer(filename: _title.text, lines: [for (var i = 0; i < 3; i++) if (!_reviewed.contains(i)) KlpDiffLine(content: '${_content.text} $i', oldNumber: _flag ? i + 1 : null, newNumber: _flag ? i + 2 : null, type: KlpDiffLineType.values[i], onApprove: _extra && _enabled ? () => _review(i, true) : null, onReject: _extra && _enabled ? () => _review(i, false) : null)], viewportLimit: _limit(), onCopy: _enabled ? _copy : null);
			case 'KlpFilePreview': return KlpFilePreview(name: _title.text, metadata: _content.text, state: KlpFilePreviewState.values[_state], size: KlpFilePreviewSize.standard, icon: _flag ? KlpIcons.folder : KlpIcons.box, preview: _extra ? _child() : null, textContent: _optional ? _code() : null, onPressed: _enabled ? _open : null, onOpenExternal: _enabled ? _external : null, onDownload: _enabled ? _download : null);
			case 'KlpTerminal': return KlpTerminal(title: _title.text, lines: _cleared ? [] : [for (var i = 0; i < (_extra ? 20 : 3); i++) '${_content.text} $i（示意日誌）'], viewportLimit: _limit(), onCopy: _enabled ? _copy : null, onClear: _enabled ? _clear : null);
			default: return KlpText('未知 viewer 展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpCodeViewer': return 'KlpCodeViewer(code: code, language: language, languageOptions: languageOptions, labels: labels, showLineNumbers: showLineNumbers, startLine: startLine, wrapped: wrapped, loading: loading, expandable: expandable, expanded: expanded, viewportLimit: viewportLimit, content: content, viewSelected: viewSelected, onLanguageChanged: onLanguageChanged, onToggleWrap: onToggleWrap, onToggleLineNumbers: onToggleLineNumbers, onToggleView: onToggleView, onToggleExpand: onToggleExpand, onCopy: onCopy)';
			case 'KlpDiffViewer': return 'KlpDiffViewer(filename: filename, lines: List<KlpDiffLine>, viewportLimit: viewportLimit, onCopy: onCopy)';
			case 'KlpFilePreview': return 'KlpFilePreview(name: name, metadata: metadata, state: state, size: KlpFilePreviewSize.standard, icon: icon, preview: preview, textContent: textContent, onPressed: onPressed, onOpenExternal: onOpenExternal, onDownload: onDownload)';
			case 'KlpTerminal': return 'KlpTerminal(title: title, lines: lines, viewportLimit: viewportLimit, onCopy: onCopy, onClear: onClear)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		if (widget.name != 'KlpCodeViewer') KlpTextField(controller: _title, placeholder: '公開 filename／name／title', onChanged: _edit),
		KlpTextField(controller: _content, placeholder: '公開 code／metadata／lines', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target())),
		KlpText('root 回呼：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText(_result),
		KlpText('reviewed：${_reviewed.toList()..sort()}；terminalCleared：$_cleared'),
		KlpText('所有 viewer 内容與檔案動作均為 consumer 示意資料。'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
