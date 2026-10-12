import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 只列出有自身公開 target 的內容集合展示。 */
const contentCollectionSpecimenNames = <String>['KlpAvatar', 'KlpAvatarGroup', 'KlpCard', 'KlpListTile', 'KlpMessageBubble', 'KlpMessageThread', 'KlpMetricCard', 'KlpPreviewCard', 'KlpSortControl', 'KlpTag'];

class ContentCollectionComponentSpecimen extends StatefulWidget {
	const ContentCollectionComponentSpecimen({super.key, required this.name});
	/* 名稱由公開展示 registry 分流，不建立第二元件模型。 */
	final String name;
	@override
	State<ContentCollectionComponentSpecimen> createState() => _ContentCollectionComponentSpecimenState();
}

class _ContentCollectionComponentSpecimenState extends State<ContentCollectionComponentSpecimen> {
	/* 草稿及資料屬於 consumer；環境切換不更換 controller。 */
	final _label = TextEditingController(text: '內容標題');
	final _content = TextEditingController(text: '內容說明');
	final _draft = TextEditingController(text: '內容 child 草稿');
	bool _flag = false;
	bool _extra = false;
	bool _optional = false;
	bool _enabled = true;
	bool _removed = false;
	int _tone = 0;
	int _size = 0;
	int _count = 3;
	int _maximum = 2;
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _label.dispose(); _content.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction() => setState(() { _childCalls++; _result = 'child 動作 $_childCalls'; });
	void _rootAction() => setState(() { _rootCalls++; _result = 'root 動作 $_rootCalls'; });
	void _sort() => setState(() { _flag = !_flag; _rootCalls++; _result = 'ascending：${!_flag}'; });
	void _loadOlder() => setState(() { _count++; _rootCalls++; _result = 'messages：$_count'; });
	void _remove() => setState(() { _removed = true; _rootCalls++; _result = '已移除 tag'; });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _flagControl(String label) => _control('$label：$_flag', () => setState(() => _flag = !_flag));
	Widget _extraControl(String label) => _control('$label：$_extra', () => setState(() => _extra = !_extra));
	Widget _optionalControl(String label) => _control('$label：$_optional', () => setState(() => _optional = !_optional));
	Widget _callbackControl() => _control('root callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _child() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: 'child 動作', onPressed: _childAction)]);

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpAvatar': return [_control('size：${KlpAvatarSize.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpAvatarSize.values.length)), _control('tone：${KlpAvatarTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpAvatarTone.values.length)), _extraControl('semanticLabel')];
			case 'KlpAvatarGroup': return [_control('avatars：$_count', () => setState(() => _count = _count == 3 ? 5 : 3)), _control('maximumVisible：$_maximum', () => setState(() => _maximum = _maximum == 2 ? 4 : 2))];
			case 'KlpCard': return [_flagControl('selected'), _control('tone：${KlpCardTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpCardTone.values.length)), _extraControl('label／leading／trailing'), _optionalControl('footer')];
			case 'KlpListTile': return [_flagControl('selected'), _extraControl('compact'), _optionalControl('subtitle／icon／trailing'), _control('tone：${KlpFeedbackTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpFeedbackTone.values.length)), _callbackControl()];
			case 'KlpMessageBubble': return [_flagControl('emphasized'), _extraControl('dense'), _optionalControl('background'), _control('alignment：${KlpMessageAlignment.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpMessageAlignment.values.length))];
			case 'KlpMessageThread': return [_extraControl('dense'), _optionalControl('loadOlderLabel'), _callbackControl()];
			case 'KlpMetricCard': return [_flagControl('value=null'), _extraControl('unit／trend／subtitle'), _optionalControl('child'), _control('tone：${KlpFeedbackTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpFeedbackTone.values.length))];
			case 'KlpPreviewCard': return [_extraControl('metadata'), _control('previewSize：${KlpPreviewCardSize.values[_size].name}', () => setState(() => _size = (_size + 1) % KlpPreviewCardSize.values.length))];
			case 'KlpSortControl': return [_control('ascending：${!_flag}', () => setState(() => _flag = !_flag)), _extraControl('icon'), _callbackControl()];
			case 'KlpTag': return [_extraControl('prefix'), _callbackControl(), _control('恢復 tag', () => setState(() => _removed = false))];
			default: return const [];
		}
	}

	Widget _target() {
		switch (widget.name) {
			case 'KlpAvatar': return KlpAvatar(label: _label.text, size: KlpAvatarSize.values[_size], tone: KlpAvatarTone.values[_tone], semanticLabel: _extra ? _content.text : null);
			case 'KlpAvatarGroup': return KlpAvatarGroup(avatars: [for (var i = 0; i < _count; i++) KlpAvatarData(id: 'person-$i', label: '${_label.text} $i')], maximumVisible: _maximum);
			case 'KlpCard': return KlpCard(title: _label.text, selected: _flag, tone: KlpCardTone.values[_tone], label: _extra ? _content.text : null, leading: _extra ? const KlpText('前') : null, trailing: _extra ? const KlpText('後') : null, footer: _optional ? KlpText(_content.text) : null, child: _child());
			case 'KlpListTile': return KlpListTile(title: _label.text, selected: _flag, compact: _extra, tone: KlpFeedbackTone.values[_tone], subtitle: _optional ? _content.text : null, icon: _optional ? KlpIcons.folder : null, trailing: _optional ? const KlpText('後') : null, onPressed: _enabled ? _rootAction : null);
			case 'KlpMessageBubble': return KlpMessageBubble(author: _label.text, timestamp: _content.text, emphasized: _flag, dense: _extra, background: _optional ? false : null, alignment: KlpMessageAlignment.values[_size], child: _child());
			case 'KlpMessageThread': return KlpMessageThread(messages: [for (var i = 0; i < _count; i++) KlpMessageBubble(author: '${_label.text} $i', timestamp: _content.text, child: KlpButton(label: '訊息 $i child 動作', onPressed: _childAction))], dense: _extra, loadOlderLabel: _optional ? '載入更早訊息' : null, onLoadOlder: _enabled ? _loadOlder : null);
			case 'KlpMetricCard': return KlpMetricCard(label: _label.text, value: _flag ? null : _content.text, unit: _extra ? '件' : null, trend: _extra ? '+3' : null, subtitle: _extra ? 'consumer 示意資料' : null, tone: KlpFeedbackTone.values[_tone], child: _optional ? _child() : null);
			case 'KlpPreviewCard': return KlpPreviewCard(title: _label.text, preview: _child(), metadata: _extra ? [_content.text, 'consumer 示意預覽'] : [], previewSize: KlpPreviewCardSize.values[_size]);
			case 'KlpSortControl': return KlpSortControl(label: _label.text, ascending: !_flag, icon: _extra ? KlpIcons.folder : null, onPressed: _enabled ? _sort : null);
			case 'KlpTag': return _removed ? const KlpText('consumer 已移除 tag') : KlpTag(label: _label.text, prefix: _extra ? _content.text : null, onRemove: _enabled ? _remove : null);
			default: return KlpText('未知內容展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpAvatar': return 'KlpAvatar(label: label, size: size, tone: tone, semanticLabel: semanticLabel)';
			case 'KlpAvatarGroup': return 'KlpAvatarGroup(avatars: List<KlpAvatarData>, maximumVisible: maximumVisible)';
			case 'KlpCard': return 'KlpCard(title: title, child: child, selected: selected, tone: tone, label: label, leading: leading, trailing: trailing, footer: footer)';
			case 'KlpListTile': return 'KlpListTile(title: title, selected: selected, compact: compact, tone: tone, subtitle: subtitle, icon: icon, trailing: trailing, onPressed: onPressed)';
			case 'KlpMessageBubble': return 'KlpMessageBubble(author: author, timestamp: timestamp, child: child, emphasized: emphasized, dense: dense, background: background, alignment: alignment)';
			case 'KlpMessageThread': return 'KlpMessageThread(messages: messages, dense: dense, loadOlderLabel: loadOlderLabel, onLoadOlder: onLoadOlder)';
			case 'KlpMetricCard': return 'KlpMetricCard(label: label, value: value, unit: unit, trend: trend, subtitle: subtitle, tone: tone, child: child)';
			case 'KlpPreviewCard': return 'KlpPreviewCard(title: title, preview: preview, metadata: metadata, previewSize: previewSize)';
			case 'KlpSortControl': return 'KlpSortControl(label: label, ascending: ascending, icon: icon, onPressed: onPressed)';
			case 'KlpTag': return 'KlpTag(label: label, prefix: prefix, onRemove: onRemove)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _label, placeholder: '公開 label／title／author', onChanged: _edit),
		if (widget.name != 'KlpAvatarGroup' && widget.name != 'KlpSortControl') KlpTextField(controller: _content, placeholder: '公開內容或選用參數文字', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target())),
		KlpText('root 回呼：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText(_result),
		KlpText('messages／avatars：$_count；tagRemoved：$_removed'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
