import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 只有十三個真實公開導覽 target，不把資料型別當成展示。 */
const navigationSelectionSpecimenNames = <String>['KlpActionGroup', 'KlpBreadcrumb', 'KlpDocumentTabs', 'KlpPagination', 'KlpPreviewTree', 'KlpRailItem', 'KlpSidebarButtonGroup', 'KlpSidebarIdentityHeader', 'KlpSidebarNavigationButton', 'KlpSidebarNavigationGroup', 'KlpSidebarSectionLabel', 'KlpTabs', 'KlpViewSwitcher'];

class NavigationSelectionComponentSpecimen extends StatefulWidget {
	const NavigationSelectionComponentSpecimen({super.key, required this.name});
	/* 公開名稱直接指定自己的 fixture。 */
	final String name;
	@override
	State<NavigationSelectionComponentSpecimen> createState() => _NavigationSelectionComponentSpecimenState();
}

class _NavigationSelectionComponentSpecimenState extends State<NavigationSelectionComponentSpecimen> {
	/* 選取與文件資料由 consumer 擁有，環境不重建 controller。 */
	final _label = TextEditingController(text: '導覽標題');
	final _detail = TextEditingController(text: '導覽說明');
	final _draft = TextEditingController(text: '側欄 child 草稿');
	final _closed = <String>{};
	final _pinned = <String>{};
	String? _docSelected = 'doc-0';
	bool _flag = false;
	bool _extra = false;
	bool _optional = false;
	bool _icon = false;
	bool _enabled = true;
	int _count = 3;
	int _index = 0;
	int _page = 1;
	int _pageCount = 5;
	int _rootCalls = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發動作';

	@override
	void dispose() { _label.dispose(); _detail.dispose(); _draft.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	List<String> _available() => [for (var i = 0; i < _count; i++) if (!_closed.contains('doc-$i')) 'doc-$i'];
	void _reconcileDocument() { final ids = _available(); if (!ids.contains(_docSelected)) _docSelected = ids.firstOrNull; }
	void _toggleCount() => setState(() { _count = _count == 3 ? 1 : 3; _index = _index.clamp(0, _count - 1); _reconcileDocument(); });
	void _record(String result) => setState(() { _rootCalls++; _result = result; });
	void _selectIndex(int index) => setState(() { _index = index; _rootCalls++; _result = 'selected index：$index'; });
	void _selectId(String id) => setState(() { _index = int.parse(id.split('-').last); _rootCalls++; _result = 'selected id：$id'; });
	void _rootAction() => setState(() { _flag = true; _rootCalls++; _result = 'root 動作 $_rootCalls'; });
	void _childAction(int index) => setState(() { _index = index; _childCalls++; _result = 'child $index 動作 $_childCalls'; });
	void _documentSelect(String id) => setState(() { _docSelected = id; _rootCalls++; _result = 'document selected：$id'; });
	void _documentClose(String id) => setState(() { _closed.add(id); _reconcileDocument(); _rootCalls++; _result = 'document closed：$id'; });
	void _documentPin(String id, bool pinned) => setState(() { if (pinned) { _pinned.add(id); } else { _pinned.remove(id); } _rootCalls++; _result = 'document pinned：$id／$pinned'; });
	void _pinAll() => setState(() { final ids = _available(); if (ids.every(_pinned.contains)) { _pinned.clear(); } else { _pinned.addAll(ids); } });
	void _restoreDocuments() => setState(() { _closed.clear(); _reconcileDocument(); });
	void _pageChanged(int page) => setState(() { _page = page; _rootCalls++; _result = 'page：$page'; });
	void _togglePageCount() => setState(() { _pageCount = _pageCount == 5 ? 1 : 5; _page = _page.clamp(1, _pageCount); });
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	Widget _flagControl(String label) => _control('$label：$_flag', () => setState(() => _flag = !_flag));
	Widget _extraControl(String label) => _control('$label：$_extra', () => setState(() => _extra = !_extra));
	Widget _optionalControl(String label) => _control('$label：$_optional', () => setState(() => _optional = !_optional));
	Widget _callbackControl() => _control('可選用 callback：$_enabled', () => setState(() => _enabled = !_enabled));
	Widget _countControl() => _control('items：$_count', _toggleCount);
	Widget _iconControl() => _control('icon=folder：$_icon', () => setState(() => _icon = !_icon));

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpActionGroup': return [_countControl(), _callbackControl()];
			case 'KlpBreadcrumb': return [_countControl()];
			case 'KlpDocumentTabs': return [_countControl(), _flagControl('dirty'), _control('closable：${!_extra}', () => setState(() => _extra = !_extra)), _control('pinned ids：${_pinned.toList()..sort()}', _pinAll), _callbackControl(), _control('還原文件分頁', _restoreDocuments)];
			case 'KlpPagination': return [_control('pageCount：$_pageCount', _togglePageCount), _extraControl('自訂前後標籤'), _callbackControl()];
			case 'KlpPreviewTree': return [_countControl(), _extraControl('children／statusLabel'), _control('enabled：$_enabled', () => setState(() => _enabled = !_enabled)), _optionalControl('onSelected=null')];
			case 'KlpRailItem': return [_flagControl('selected'), _extraControl('badge'), _iconControl()];
			case 'KlpSidebarButtonGroup': return [_countControl(), _extraControl('padding'), _iconControl(), _callbackControl()];
			case 'KlpSidebarIdentityHeader': return [_flagControl('avatarLabel'), _extraControl('avatarSemanticLabel'), _optionalControl('trailing'), _iconControl()];
			case 'KlpSidebarNavigationButton': return [_flagControl('selected'), _iconControl(), _callbackControl()];
			case 'KlpSidebarNavigationGroup': return [_countControl(), _iconControl(), _callbackControl()];
			case 'KlpSidebarSectionLabel': return const [];
			case 'KlpTabs': return [_countControl()];
			case 'KlpViewSwitcher': return [_countControl(), _iconControl(), _callbackControl()];
			default: return const [];
		}
	}

	KlpIconData _iconData() => _icon ? KlpIcons.folder : KlpIcons.box;
	Widget _wide(Widget child) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: 760, child: child));
	Widget _identityChild() => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '側欄 child 動作', onPressed: () => _childAction(0))]);
	List<String> _labels() => [for (var i = 0; i < _count; i++) '${_label.text} $i'];

	Widget _target(BuildContext context) {
		switch (widget.name) {
			case 'KlpActionGroup': return KlpActionGroup(children: [for (var i = 0; i < _count; i++) KlpButton(label: '${_label.text} $i', selected: _index == i, onPressed: _enabled ? () => _childAction(i) : null)]);
			case 'KlpBreadcrumb': return _wide(KlpBreadcrumb(segments: _labels(), onSelected: _selectIndex));
			case 'KlpDocumentTabs': return _wide(KlpDocumentTabs(tabs: [for (var i = 0; i < _count; i++) if (!_closed.contains('doc-$i')) KlpDocumentTab(id: 'doc-$i', label: '${_label.text} $i', dirty: _flag, closable: !_extra, pinned: _pinned.contains('doc-$i'))], selectedId: _docSelected, onSelected: _enabled ? _documentSelect : null, onClose: _enabled ? _documentClose : null, onPinnedChanged: _enabled ? _documentPin : null));
			case 'KlpPagination': return KlpPagination(page: _page, pageCount: _pageCount, previousLabel: _extra ? _label.text : '上一頁', nextLabel: _extra ? _detail.text : '下一頁', onPageChanged: _enabled ? _pageChanged : null);
			case 'KlpPreviewTree': return KlpPreviewTree(label: _label.text, nodes: [for (var i = 0; i < _count; i++) KlpPreviewTreeNode(id: 'preview-$i', label: '${_label.text} $i', accessibilityLabel: '${_detail.text} $i', statusLabel: _extra ? _detail.text : null, children: _extra ? [KlpPreviewTreeNode(id: 'preview-child-$i', label: 'child $i', accessibilityLabel: '預覽 child $i')] : [])], enabled: _enabled, onSelected: _optional ? null : (id) => _record('preview selected：$id'));
			case 'KlpRailItem': return KlpRailItem(icon: _iconData(), label: _label.text, selected: _flag, badge: _extra ? _detail.text : null, onPressed: _rootAction);
			case 'KlpSidebarButtonGroup': return KlpSidebarButtonGroup(items: [for (var i = 0; i < _count; i++) KlpSidebarButtonData(label: '${_label.text} $i', icon: _iconData(), selected: _index == i, onPressed: _enabled ? () => _childAction(i) : null)], padding: _extra ? EdgeInsets.all(context.klp.space.contentInset) : null);
			case 'KlpSidebarIdentityHeader': return KlpSidebarIdentityHeader(icon: _iconData(), title: _label.text, avatarLabel: _flag ? _detail.text : null, avatarSemanticLabel: _extra ? _detail.text : null, trailing: _optional ? SizedBox(width: 160, child: _identityChild()) : null);
			case 'KlpSidebarNavigationButton': return KlpSidebarNavigationButton(icon: _iconData(), label: _label.text, selected: _flag, onPressed: _enabled ? _rootAction : null);
			case 'KlpSidebarNavigationGroup': return KlpSidebarNavigationGroup(children: [for (var i = 0; i < _count; i++) KlpSidebarNavigationButton(icon: _iconData(), label: '${_label.text} $i', selected: _index == i, onPressed: _enabled ? () => _childAction(i) : null)]);
			case 'KlpSidebarSectionLabel': return KlpSidebarSectionLabel(label: _label.text);
			case 'KlpTabs': return _wide(KlpTabs(tabs: _labels(), selected: _index, onSelected: _selectIndex));
			case 'KlpViewSwitcher': return KlpViewSwitcher(options: [for (var i = 0; i < _count; i++) KlpViewOption(id: 'view-$i', label: '${_label.text} $i', icon: _icon ? KlpIcons.folder : null)], selectedId: 'view-$_index', onSelected: _enabled ? _selectId : null);
			default: return KlpText('未知導覽展示：${widget.name}');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpActionGroup': return 'KlpActionGroup(children: children)';
			case 'KlpBreadcrumb': return 'KlpBreadcrumb(segments: segments, onSelected: onSelected)';
			case 'KlpDocumentTabs': return 'KlpDocumentTabs(tabs: List<KlpDocumentTab>, selectedId: selectedId, onSelected: onSelected, onClose: onClose, onPinnedChanged: onPinnedChanged)';
			case 'KlpPagination': return 'KlpPagination(page: page, pageCount: pageCount, previousLabel: previousLabel, nextLabel: nextLabel, onPageChanged: onPageChanged)';
			case 'KlpPreviewTree': return 'KlpPreviewTree(label: label, nodes: List<KlpPreviewTreeNode>, enabled: enabled, onSelected: onSelected)';
			case 'KlpRailItem': return 'KlpRailItem(icon: icon, label: label, selected: selected, badge: badge, onPressed: onPressed)';
			case 'KlpSidebarButtonGroup': return 'KlpSidebarButtonGroup(items: List<KlpSidebarButtonData>, padding: padding)';
			case 'KlpSidebarIdentityHeader': return 'KlpSidebarIdentityHeader(icon: icon, title: title, avatarLabel: avatarLabel, avatarSemanticLabel: avatarSemanticLabel, trailing: trailing)';
			case 'KlpSidebarNavigationButton': return 'KlpSidebarNavigationButton(icon: icon, label: label, selected: selected, onPressed: onPressed)';
			case 'KlpSidebarNavigationGroup': return 'KlpSidebarNavigationGroup(children: children)';
			case 'KlpSidebarSectionLabel': return 'KlpSidebarSectionLabel(label: label)';
			case 'KlpTabs': return 'KlpTabs(tabs: tabs, selected: selected, onSelected: onSelected)';
			case 'KlpViewSwitcher': return 'KlpViewSwitcher(options: List<KlpViewOption>, selectedId: selectedId, onSelected: onSelected)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _label, placeholder: '公開 label／title／segments', onChanged: _edit),
		if (['KlpPagination', 'KlpPreviewTree', 'KlpRailItem', 'KlpSidebarIdentityHeader'].contains(widget.name)) KlpTextField(controller: _detail, placeholder: '公開標籤／badge／avatar', onChanged: _edit),
		SizedBox(height: 280, child: SingleChildScrollView(child: _target(context))),
		KlpText('root 回呼：$_rootCalls；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText(_result),
		KlpText('selectedIndex：$_index；page：$_page；docSelected：$_docSelected；closed：${_closed.toList()..sort()}；pinned：${_pinned.toList()..sort()}'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
