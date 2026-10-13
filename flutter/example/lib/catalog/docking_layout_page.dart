import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

import '../catalog_model.dart';

final dockingLayoutPage = CatalogPageData(
	label: 'Docking',
	title: '可停駐工作區',
	description: '固定 Stage 與左、下、右區域；布局由產品持有，庫提供停靠、分割、縮放與分頁。',
	icon: KlpIcons.panelSplit,
	specimens: [
		Specimen(name: 'KlpDockLayout', note: '拖放只在成功時提交；保存保留偏好尺寸。產品批准關閉，正文仍由產品保留。', build: (context) => const _DockLayoutDemo()),
		Specimen(name: 'KlpDockHeader', note: '標頭高度讀 semantic chromeTab，受有限槽限制；actions 空間不足時收入更多選單。', build: (context) => const _DockHeaderDemo()),
	],
);

class _DockHeaderDemo extends StatefulWidget {
	const _DockHeaderDemo();
	@override
	State<_DockHeaderDemo> createState() => _DockHeaderDemoState();
}

class _DockHeaderDemoState extends State<_DockHeaderDemo> {
	/// 產品回饋使 overflow 選單動作也可以實際驗證。
	String _action = '尚未執行標頭動作';
	/// 外層 Align 提供 loose 寬度，避免 Catalog stretch 抵消示範限制。
	double _width = 220;
	@override
	Widget build(BuildContext context) {
		final actions = [
			for (final entry in [('搜尋', KlpIcons.search), ('重新整理', KlpIcons.refresh), ('設定', KlpIcons.settings), ('刪除', KlpIcons.trash)])
				KlpDockHeaderAction(icon: entry.$2, label: entry.$1, onPressed: () => setState(() => _action = '已執行 ${entry.$1}')),
		];
		final header = KlpDockHeader(leading: const KlpText('COMPACT DOCK HEADER', role: KlpTextRole.code), actions: actions);
		final panel = KlpPanelFrame(headerSize: KlpPanelHeaderSize.dock, header: header, content: Center(child: KlpText(_action)));
		final controls = [for (final width in [120.0, 220.0]) KlpButton(label: '標頭寬 ${width.toInt()}', onPressed: () => setState(() => _width = width))];
		final children = [Wrap(spacing: context.klp.space.actionGap, children: controls), SizedBox(height: context.klp.space.contentStackGap), Align(alignment: AlignmentDirectional.centerStart, child: SizedBox(width: _width, height: 120, child: panel))];
		return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
	}
}

class _DockLayoutDemo extends StatefulWidget {
	const _DockLayoutDemo();
	@override
	State<_DockLayoutDemo> createState() => _DockLayoutDemoState();
}

class _DockLayoutDemoState extends State<_DockLayoutDemo> {
	/// 原清冊保留跨區能力；這些尺寸是展示產品選擇，不是庫預設值。
	static const _leftGroups = [
		KlpDockGroupData(id: 'left-project', panelIds: ['project'], activePanelId: 'project', mainAxisExtent: 220),
		KlpDockGroupData(id: 'left-outline', panelIds: ['outline'], activePanelId: 'outline', mainAxisExtent: 220),
	];
	static const _left = KlpDockAreaData(axis: Axis.vertical, extent: 220, groups: _leftGroups);
	static const _rightGroups = [
		KlpDockGroupData(id: 'right-inspector', panelIds: ['inspector', 'history'], activePanelId: 'inspector', mainAxisExtent: 220),
		KlpDockGroupData(id: 'right-tokens', panelIds: ['tokens'], activePanelId: 'tokens', mainAxisExtent: 220),
	];
	static const _right = KlpDockAreaData(axis: Axis.vertical, extent: 220, groups: _rightGroups);
	static const _bottomGroups = [
		KlpDockGroupData(id: 'bottom-terminal', panelIds: ['terminal'], activePanelId: 'terminal', mainAxisExtent: 320),
		KlpDockGroupData(id: 'bottom-problems', panelIds: ['problems'], activePanelId: 'problems', mainAxisExtent: 320),
	];
	static const _bottom = KlpDockAreaData(axis: Axis.horizontal, extent: 200, groups: _bottomGroups);
	static const _initialLayout = KlpDockLayoutData(left: _left, right: _right, bottom: _bottom);
	/// layout 是唯一保存權威；count 只記錄產品實際採用的變更。
	KlpDockLayoutData _layout = _initialLayout;
	int _count = 0;
	/// controller 由產品持有，收合或主題更新不丟正文。
	final _jsonController = TextEditingController();
	final _stageController = TextEditingController(text: '未命名場景');
	/// callback 身分穩定，模式只是產品批准規則。
	String _closeMode = 'approve';
	late final FutureOr<bool> Function() _closeCallback = _approveClose;
	String _message = '拖動分頁到標頭可合併，拖到正文可分割。';
	bool _showJson = false;
	/// 外部容器的尺寸限制不寫回 panel 保存偏好。
	double _width = 1040;
	double _height = 480;
	late final List<KlpDockPanel> _panels = [
		_panel('project', 'PROJECT', 'Project explorer · side only', allowBottom: false, isPinned: true),
		_panel('outline', 'OUTLINE', 'Document outline'),
		_panel('terminal', 'TERMINAL', 'Terminal output · bottom only', allowSide: false),
		_panel('problems', 'PROBLEMS', 'Problems and diagnostics'),
		_panel('inspector', 'INSPECTOR', 'Selected element properties', isDirty: true),
		_panel('tokens', 'TOKENS', 'Resolved design tokens'),
		_panel('history', 'HISTORY', 'Change history'),
	];
	/// metadata 與 callback 不進資料契約，只投影公開 policy。
	late final _policies = _panels.map((panel) => KlpDockPanelPolicy(id: panel.id, allowSide: panel.allowSide, allowBottom: panel.allowBottom)).toList();

	@override
	void dispose() {
		_jsonController.dispose();
		_stageController.dispose();
		super.dispose();
	}

	FutureOr<bool> _approveClose() {
		if (_closeMode == 'delay') return Future<bool>.delayed(const Duration(milliseconds: 1200), () => true);
		return _closeMode == 'approve';
	}

	KlpDockPanel _panel(
		String id,
		String title,
		String content, {
		bool allowBottom = true,
		bool allowSide = true,
		bool isPinned = false,
		bool isDirty = false,
	}) {
		return KlpDockPanel(
			id: id,
			header: KlpText(title, role: KlpTextRole.code),
			content: Center(child: KlpText(content, tone: KlpTextTone.muted)),
			allowBottom: allowBottom,
			allowSide: allowSide,
			isPinned: isPinned,
			isDirty: isDirty,
			onCloseRequested: _closeCallback,
			closeLabel: '關閉 $title',
		);
	}

	void _commit(KlpDockLayoutData layout) {
		if (KlpDockLayoutCodec.encode(layout) == KlpDockLayoutCodec.encode(_layout)) return;
		setState(() { _layout = layout; _count++; });
	}

	void _action(KlpDockAction action) {
		final result = applyKlpDockAction(layout: _layout, panels: _policies, action: action);
		if (result.changed) _commit(result.layout);
	}

	KlpDockAreaData _area(KlpDockArea slot) => switch (slot) { KlpDockArea.left => _layout.left, KlpDockArea.right => _layout.right, KlpDockArea.bottom => _layout.bottom };

	void _toggleArea(KlpDockArea slot) => _action(KlpDockAction.visibility(area: slot, isVisible: !_area(slot).isVisible));

	void _clearBottom() {
		var layout = _layout;
		for (final id in _layout.bottom.groups.expand((group) => group.panelIds)) {
			layout = applyKlpDockAction(layout: layout, panels: _policies, action: KlpDockAction.close(panelId: id, approved: true)).layout;
		}
		_commit(layout);
	}

	void _resetLayout() => _commit(_initialLayout);

	void _saveLayout() {
		_jsonController.text = KlpDockLayoutCodec.encode(_layout);
		setState(() { _showJson = true; _message = '布局已保存到 JSON。'; });
	}

	void _restoreLayout() {
		try {
			final result = KlpDockLayoutCodec.restore(_jsonController.text, panels: _policies);
			_commit(result.layout);
			setState(() => _message = '還原成功 · 缺少：${result.missingPanelIds.join(', ')} · 可重開：${result.availablePanelIds.join(', ')}');
		} catch (error) {
			setState(() => _message = '還原失敗，保留布局：$error');
		}
	}

	void _openPanel(String id) {
		final policy = _policies.firstWhere((panel) => panel.id == id);
		final slot = policy.allowSide ? KlpDockArea.left : KlpDockArea.bottom;
		final groups = _area(slot).groups;
		final KlpDockDestination destination;
		if (groups.isEmpty) {
			destination = KlpDockDestination.group(area: slot, groupId: 'reopened-${slot.name}', index: 0, extent: 240);
		} else {
			destination = KlpDockDestination.tab(area: slot, groupId: groups.first.id, index: groups.first.panelIds.length);
		}
		_action(KlpDockAction.open(panelId: id, destination: destination));
	}

	void _mergeGroups() {
		for (final slot in KlpDockArea.values) {
			final groups = _area(slot).groups;
			if (groups.length < 2) continue;
			_action(KlpDockAction.merge(sourceGroupId: groups[1].id, targetGroupId: groups[0].id, index: groups[0].panelIds.length));
			return;
		}
	}

	Widget _controls(BuildContext context) {
		final available = KlpDockLayoutCodec.restore(KlpDockLayoutCodec.encode(_layout), panels: _policies).availablePanelIds;
		final buttons = <Widget>[
			KlpButton(label: 'Toggle left', onPressed: () => _toggleArea(KlpDockArea.left)),
			KlpButton(label: 'Toggle bottom', onPressed: () => _toggleArea(KlpDockArea.bottom)),
			KlpButton(label: 'Toggle right', onPressed: () => _toggleArea(KlpDockArea.right)),
			KlpButton(label: 'Clear bottom', onPressed: _clearBottom),
			KlpButton(label: 'Reset layout', onPressed: _resetLayout),
			KlpButton(label: '保存布局', onPressed: _saveLayout),
			KlpButton(label: '還原布局', onPressed: _restoreLayout),
			KlpButton(label: '合併同區前兩群組', onPressed: _mergeGroups),
			for (final mode in [('approve', '批准關閉'), ('deny', '拒絕關閉'), ('delay', '延遲批准關閉')])
				KlpButton(label: mode.$2, onPressed: () => setState(() => _closeMode = mode.$1)),
			for (final id in available) KlpButton(label: '重開 $id', onPressed: () => _openPanel(id)),
			for (final width in [320.0, 760.0, 1040.0]) KlpButton(label: '停靠寬 ${width.toInt()}', onPressed: () => setState(() => _width = width)),
			for (final height in [180.0, 480.0]) KlpButton(label: '停靠高 ${height.toInt()}', onPressed: () => setState(() => _height = height)),
		];
		return Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: buttons);
	}

	Widget _dock(BuildContext context) {
		final content = Padding(padding: EdgeInsets.all(context.klp.space.contentInset), child: KlpTextField(label: '場景名稱', controller: _stageController));
		final stage = KlpPanelFrame(header: const KlpPanelHeader(title: 'STAGE'), content: content);
		final dock = KlpDockLayout(
			stage: stage,
			panels: _panels,
			layout: _layout,
			onLayoutChanged: _commit,
			leftConstraints: const KlpDockAreaConstraints(minExtent: 160, maxExtent: 360),
			rightConstraints: const KlpDockAreaConstraints(minExtent: 160, maxExtent: 360),
			bottomConstraints: const KlpDockAreaConstraints(minExtent: 140, maxExtent: 320),
		);
		return LayoutBuilder(builder: (context, constraints) => Align(alignment: AlignmentDirectional.centerStart, child: SizedBox(width: math.min(_width, constraints.maxWidth), height: _height, child: dock)));
	}

	Widget _json() => KlpTextField(label: '布局 JSON', controller: _jsonController, multiline: true, minLines: 3, maxLines: 5);

	@override
	Widget build(BuildContext context) {
		final children = <Widget>[
			_controls(context),
			SizedBox(height: context.klp.space.contentStackGap),
			_dock(context),
			SizedBox(height: context.klp.space.contentStackGap),
			KlpText('已提交 $_count 次布局變更 · 關閉模式 $_closeMode · 左 ${_layout.left.extent} / 右 ${_layout.right.extent} / 下 ${_layout.bottom.extent}', role: KlpTextRole.caption),
			KlpText(_message, role: KlpTextRole.caption),
			KlpButton(label: _showJson ? '隱藏布局 JSON' : '顯示布局 JSON', onPressed: () => setState(() => _showJson = !_showJson)),
			if (_showJson) _json(),
		];
		return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
	}
}
