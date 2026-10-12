import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'gui_scenario_metadata.dart';

class GuiScenarioApp extends StatefulWidget {
	const GuiScenarioApp({super.key, required this.id});
	/* 外部 query 只選場景，不直接成為庫模板或布局資料。 */
	final String id;
	@override
	State<GuiScenarioApp> createState() => _GuiScenarioAppState();
}

class _GuiScenarioAppState extends State<GuiScenarioApp> {
	/* 同環境 owner 保持 State；只有明確 epoch 重設才丟棄場景草稿。 */
	late final Future<List<GuiScenarioMetadata>> _metadata = _load();
	final _base = KlpStylePack.defaults();
	late final _spacious = _base.applyOverrides({
		'semantics': {
			'theme.spacing.contentStackGap': {for (final mode in KlpThemeVariant.values) mode.name: 'p(space600)'},
			'theme.spacing.actionGap': {for (final mode in KlpThemeVariant.values) mode.name: 'p(space300)'},
		},
	});
	KlpThemeVariant _mode = KlpThemeVariant.light;
	bool _alternate = false;
	int _epoch = 0;
	late String _id = widget.id;

	Future<List<GuiScenarioMetadata>> _load() async {
		final source = await rootBundle.loadString('assets/gui-scenarios.json');
		return GuiScenarioMetadata.fromJson(jsonDecode(source));
	}

	@override
	Widget build(BuildContext context) => MaterialApp(
		debugShowCheckedModeBanner: false,
		title: 'Kallopis GUI 場景',
		theme: buildKlpThemeVariant(_mode, stylePack: _alternate ? _spacious : _base),
		home: Material(child: FutureBuilder<List<GuiScenarioMetadata>>(
			future: _metadata,
			builder: (context, snapshot) {
				if (snapshot.hasError) { return _announce(context, '場景資料載入失敗', Center(child: KlpText('場景資料載入失敗：${snapshot.error}'))); }
				if (!snapshot.hasData) { return const Center(child: KlpText('場景資料載入中…')); }
				final entries = snapshot.data!;
				final found = entries.where((entry) => entry.id == _id).toList();
				if (found.isEmpty || !_scenes.containsKey(_id)) { return _announce(context, '找不到 GUI 場景', Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
					KlpText('找不到 GUI 場景：$_id'),
					KlpButton(label: '返回場景入口', onPressed: () => setState(() => _id = entries.first.id)),
				]))); }
				return _content(context, entries, found.single);
			},
		)),
	);

	Widget _announce(BuildContext context, String title, Widget child) => Title(title: '$title Flutter 互動展示', color: Theme.of(context).colorScheme.primary, child: child);

	Widget _content(BuildContext context, List<GuiScenarioMetadata> entries, GuiScenarioMetadata scene) {
		final space = context.klp.space;
		final content = SafeArea(child: SingleChildScrollView(child: Padding(
			padding: EdgeInsets.all(space.contentInset),
			child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
				Semantics(header: true, child: KlpText(scene.title, role: KlpTextRole.section)),
				Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: [
					for (final entry in entries) KlpButton(label: entry.title, selected: entry.id == scene.id, onPressed: () => setState(() => _id = entry.id)),
				]),
				SizedBox(height: space.contentStackGap),
				Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: [
					for (final mode in KlpThemeVariant.values) KlpButton(label: mode.name, selected: _mode == mode, onPressed: () => setState(() => _mode = mode)),
					KlpButton(label: _alternate ? '風格：寬鬆' : '風格：預設', selected: _alternate, onPressed: () => setState(() => _alternate = !_alternate)),
					KlpButton(label: '重設場景', onPressed: () => setState(() => _epoch++)),
				]),
				SizedBox(height: space.contentStackGap),
				GuiWorkbench(key: ValueKey('${scene.id}-$_epoch'), id: scene.id),
				SizedBox(height: space.contentStackGap),
				const KlpText('復刻資訊區塊與工作台操作；3D、正文及終端是示意，核心由產品接入。', role: KlpTextRole.caption),
				SelectableText('官方布局參考：${scene.reference}'),
				const KlpText('公開組裝：ShortcutHost → RegisteredToolbar／Menu／Palette ＋ DockLayout → FileExplorer／PanelFrame／Surface／TextField', role: KlpTextRole.code),
			]),
		)));
		return _announce(context, scene.title, content);
	}
}

class _SceneData {
	const _SceneData({required this.left, required this.right, required this.bottom,
		required this.files, required this.action, required this.draft});
	/* 分區與檔案是這個產品 example 的資料，不能變為庫的固定業務布局。 */
	final List<String> left;
	final List<String> right;
	final List<String> bottom;
	final List<String> files;
	final String action;
	final String draft;
}
const _scenes = <String, _SceneData>{
	'vscode': _SceneData(left: ['Explorer', 'Search'], right: ['Outline'], bottom: ['Output', 'Problems'],
		files: ['main.ts', 'theme.ts', 'README.md'], action: '執行檢查', draft: 'export const greeting = "Kallopis";\n// 正文核心由產品接入。'),
	'blockbench': _SceneData(left: ['Outliner', 'Tools'], right: ['Properties', 'Textures'], bottom: ['Animations'],
		files: ['Cube', 'Head', 'Body'], action: '新增方塊', draft: 'untitled_model.bbmodel'),
	'blender': _SceneData(left: ['Tools'], right: ['Outliner', 'Properties'], bottom: ['Timeline'],
		files: ['Cube', 'Camera', 'Light'], action: '移動物件', draft: 'workspace.blend'),
};

class GuiWorkbench extends StatefulWidget {
	const GuiWorkbench({super.key, required this.id});
	/* scene identity 決定自己的產品資料，不連到私有 library。 */
	final String id;
	@override
	State<GuiWorkbench> createState() => _GuiWorkbenchState();
}

class _SceneContext {
	const _SceneContext(this.owner);
	/* 命令只借用目前 State 操作，沒有另一份快照狀態或 handler。 */
	final _GuiWorkbenchState owner;
}

class _GuiWorkbenchState extends State<GuiWorkbench> {
	/* 唯一保存資料與 controllers 由 State 擁有；mode／pack 不重建它們。 */
	late final _SceneData _scene = _scenes[widget.id]!;
	late KlpDockLayoutData _layout = _initial();
	late final _draft = TextEditingController(text: _scene.draft);
	final _saved = TextEditingController();
	final _frame = TextEditingController(text: '1');
	final _search = TextEditingController(text: 'theme');
	final _positions = {for (final axis in ['X', 'Y', 'Z']) axis: TextEditingController(text: '0')};
	final _registry = KlpCommandRegistry<_SceneContext>();
	late final KlpCommandKeymap<_SceneContext> _keymap;
	late String _selected = _scene.files.first;
	bool _expanded = true;
	bool _paletteOpen = false;
	bool _menuOpen = false;
	String _workspace = 'Layout';
	int _layoutCount = 0;
	int _explorerCount = 0;
	int _commandCount = 0;
	int _operations = 0;
	String _message = '拖動面板分頁、分隔線或使用命令。';
	KlpShortcutHandling? _handling;
	bool _focusRefreshPending = false;
	static const _items = [KlpCommandReference(commandId: 'layout.save'), KlpCommandReference(commandId: 'layout.restore'), KlpCommandReference(commandId: 'layout.reset'),
		KlpCommandReference(commandId: 'scene.run'), KlpCommandReference(commandId: 'panel.bottom', kind: KlpCommandKind.toggle)];

	KlpDockLayoutData _initial() => KlpDockLayoutData(
		left: KlpDockAreaData(axis: Axis.vertical, extent: 180, groups: [KlpDockGroupData(id: 'navigation', panelIds: _scene.left, activePanelId: _scene.left.first, mainAxisExtent: 320)]),
		right: KlpDockAreaData(axis: Axis.vertical, extent: 190, groups: [for (var i = 0; i < _scene.right.length; i++) KlpDockGroupData(id: 'properties-$i', panelIds: [_scene.right[i]], activePanelId: _scene.right[i], mainAxisExtent: 210)]),
		bottom: KlpDockAreaData(axis: Axis.horizontal, extent: 120, groups: [KlpDockGroupData(id: 'messages', panelIds: _scene.bottom, activePanelId: _scene.bottom.first, mainAxisExtent: 320)]),
	);
	List<KlpDockPanelPolicy> get _policies => [for (final id in [..._scene.left, ..._scene.right, ..._scene.bottom]) KlpDockPanelPolicy(id: id)];
	_SceneContext _getContext() => _SceneContext(this);

	@override
	void initState() {
		super.initState();
		FocusManager.instance.addListener(_refreshFocus);
		_saved.addListener(_refreshRegistry);
		_register('layout.save', '保存布局', (context) => context.owner._save());
		_registry.register(KlpCommandDefinition<_SceneContext>(
			id: 'layout.restore', label: '還原布局', category: '工作區',
			isEnabled: (context) => context.owner._saved.text.isNotEmpty,
			handler: (context) => context.owner._restore(),
		));
		_register('layout.reset', '重設布局', (context) => context.owner._resetLayout());
		_register('scene.run', _scene.action, (context) => context.owner._run());
		_registry.register(KlpCommandDefinition<_SceneContext>(
			id: 'panel.bottom', label: '底部面板', category: '視圖',
			isChecked: (context) => context.owner._layout.bottom.isVisible,
			handler: (context) => context.owner._toggleBottom(),
		));
		_register('command.search', '搜尋命令', (context) { context.owner._openPalette(); return '已開啟命令面板'; });
		final isMac = defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.iOS;
		_keymap = KlpCommandKeymap(registry: _registry, platform: isMac ? KlpShortcutPlatform.mac : KlpShortcutPlatform.other);
		_keymap.register(KlpShortcutBinding(id: 'save.primary', commandId: 'layout.save', sequence: [KlpShortcutStroke(key: 's', primary: true)],
			scope: KlpShortcutScope.app, allowInEditable: true));
		_keymap.register(KlpShortcutBinding(id: 'save.chord', commandId: 'layout.save', sequence: [KlpShortcutStroke(key: 'k', primary: true), KlpShortcutStroke(key: 's')],
			scope: KlpShortcutScope.app, allowInEditable: true));
		_keymap.register(KlpShortcutBinding(id: 'search.primary', commandId: 'command.search', sequence: [KlpShortcutStroke(key: 'p', primary: true, shift: true)],
			scope: KlpShortcutScope.app, allowInEditable: true));
	}
	void _register(String id, String label, Object? Function(_SceneContext) handler) => _registry.register(KlpCommandDefinition<_SceneContext>(
		id: id, label: label, category: '工作區', handler: handler,
	));
	void _refreshRegistry() => _registry.refresh();
	void _refreshFocus() {
		if (!mounted || _focusRefreshPending) return;
		_focusRefreshPending = true;
		WidgetsBinding.instance.addPostFrameCallback((time) {
			_focusRefreshPending = false;
			if (mounted) setState(() {});
		});
		WidgetsBinding.instance.ensureVisualUpdate();
	}
	EditableText? _focusedEditor() {
		final focusContext = FocusManager.instance.primaryFocus?.context;
		if (focusContext?.widget is EditableText) return focusContext!.widget as EditableText;
		return focusContext?.findAncestorWidgetOfExactType<EditableText>();
	}
	KlpShortcutFocus _getFocus() => KlpShortcutFocus(
		focusId: 'scene-focus-${identityHashCode(FocusManager.instance.primaryFocus)}', pageId: widget.id, editable: _focusedEditor() != null,
	);
	bool _getIsComposing() {
		final range = _focusedEditor()?.controller.value.composing;
		return range != null && range.isValid && !range.isCollapsed;
	}
	@override
	void dispose() {
		FocusManager.instance.removeListener(_refreshFocus);
		_saved.removeListener(_refreshRegistry);
		_keymap.dispose();
		_registry.dispose();
		for (final controller in [_draft, _saved, _frame, _search, ..._positions.values]) { controller.dispose(); }
		super.dispose();
	}

	void _commit(KlpDockLayoutData value) {
		if (KlpDockLayoutCodec.encode(value) == KlpDockLayoutCodec.encode(_layout)) return;
		setState(() { _layout = value; _layoutCount++; });
		_registry.refresh();
	}
	void _action(KlpDockAction action) {
		final result = applyKlpDockAction(layout: _layout, panels: _policies, action: action);
		if (result.changed) _commit(result.layout);
	}
	String _save() { _saved.text = KlpDockLayoutCodec.encode(_layout); return '布局已保存到展示 JSON'; }
	String _restore() { _commit(KlpDockLayoutCodec.restore(_saved.text, panels: _policies).layout); return '布局已還原，正文與選取保持'; }
	String _resetLayout() { _commit(_initial()); return '布局已重設，草稿保持'; }
	String _run() { setState(() => _operations++); return '${_scene.action}：$_selected（示意）'; }
	String _toggleBottom() { _action(KlpDockAction.visibility(area: KlpDockArea.bottom, isVisible: !_layout.bottom.isVisible)); return '底部區域已切換'; }
	void _openPalette() => setState(() => _paletteOpen = true);
	void _onResult(KlpCommandExecutionResult value) => setState(() {
		_commandCount++;
		_message = value.status == KlpCommandExecutionStatus.error ? '命令失敗，布局保留：${value.error}' : '${value.value ?? value.status.name}';
	});
	void _select(String id) => setState(() { _selected = id; _explorerCount++; });
	bool _approveClose() => true;
	void _openPanel(String id) {
		final groups = _layout.left.groups;
		final destination = groups.isEmpty ? KlpDockDestination.group(area: KlpDockArea.left, groupId: 'reopened', index: 0, extent: 280) : KlpDockDestination.tab(area: KlpDockArea.left, groupId: groups.first.id, index: groups.first.panelIds.length);
		_action(KlpDockAction.open(panelId: id, destination: destination));
	}
	void _switchWorkspace(String value) {
		setState(() => _workspace = value);
		_action(KlpDockAction.resizeArea(area: KlpDockArea.bottom, extent: value == 'Animation' ? 180 : 120));
	}

	Widget _stack(BuildContext context, List<Widget> children) {
		final spaced = <Widget>[];
		for (final child in children) { if (spaced.isNotEmpty) spaced.add(SizedBox(height: context.klp.space.contentStackGap)); spaced.add(child); }
		return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: spaced);
	}
	Widget _explorer() => KlpFileExplorer(
		sections: [KlpFileExplorerSection(id: 'project', title: widget.id == 'vscode' ? 'KALLOPIS' : 'Scene Collection', items: [for (final file in _scene.files) KlpFileExplorerItem(id: file, label: file)])],
		expandedSectionIds: {if (_expanded) 'project'}, expandedItemIds: const {}, selectedId: _selected,
		onSectionToggle: (id) => setState(() { _expanded = !_expanded; _explorerCount++; }),
		onItemToggle: (id) {}, onItemSelected: _select,
	);
	Widget _panel(BuildContext context, String label) {
		if (label == 'Explorer' || label == 'Outliner') return _explorer();
		final children = <Widget>[];
		if (label == 'Search') {
			children.addAll([KlpTextField(label: '搜尋檔案', controller: _search), const KlpText('theme.ts · 2 results（示意）')]);
		} else if (label == 'Tools') {
			children.addAll([for (final tool in ['Select', 'Move', 'Rotate', 'Scale']) KlpButton(label: tool, onPressed: () => setState(() => _message = '工具：$tool（示意）'))]);
		} else if (label == 'Properties') {
			children.add(KlpText(_selected, role: KlpTextRole.label));
			children.addAll([for (final axis in _positions.keys) KlpTextField(label: 'Position $axis', controller: _positions[axis])]);
		} else if (label == 'Textures') {
			children.addAll([KlpButton(label: 'wood.png', onPressed: () => setState(() => _message = '已選取 wood.png（示意）')), const KlpText('16 × 16 · 材質示意')]);
		} else if (label == 'Timeline' || label == 'Animations') {
			children.addAll([KlpButton(label: '播放（示意）', onPressed: _run), KlpTextField(label: '目前影格', controller: _frame, onChanged: (value) => setState(() {})), const KlpText('1 ──── 20 ──── 40 ──── 60', role: KlpTextRole.code)]);
		} else if (label == 'Outline') {
			children.add(const KlpText('greeting · exported constant\nMain · function（示意）'));
		} else {
			children.add(KlpText(label == 'Problems' ? '0 errors · 0 warnings（示意）' : 'Kallopis · 操作 $_operations 次 · $_message', role: KlpTextRole.code));
		}
		return SingleChildScrollView(child: Padding(padding: EdgeInsets.all(context.klp.space.contentInset), child: _stack(context, children)));
	}
	KlpPanelFrame _stage(BuildContext context) {
		if (widget.id == 'vscode') { return KlpPanelFrame(
			header: KlpPanelHeader(content: Wrap(spacing: context.klp.space.actionGap, children: [for (final file in _scene.files) KlpButton(label: file, selected: _selected == file, onPressed: () => _select(file))])),
			content: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(context.klp.space.contentInset), child: _stack(context, [
				KlpText('$_selected · 正文編輯示意', role: KlpTextRole.caption), KlpTextField(label: '正文草稿', controller: _draft, multiline: true, minLines: 5, maxLines: 8),
			]))),
		); }
		return KlpPanelFrame(header: KlpPanelHeader(title: 'Scene · $_selected'), content: KlpSurface(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(context.klp.space.contentInset), child: _stack(context, [
			KlpText('$_workspace · 3D Viewport（示意）', role: KlpTextRole.label),
			KlpTextField(label: '場景草稿', controller: _draft),
			SizedBox(height: 160, child: Center(child: Transform.rotate(angle: _operations * math.pi / 12, child: const KlpText('  +────+\n /    /|\n+────+ |\n|    | +\n|    |/\n+────+', role: KlpTextRole.code)))),
			KlpText('選取：$_selected · 操作：$_operations · 影格：${_frame.text}', role: KlpTextRole.caption),
		])))));
	}
	@override
	Widget build(BuildContext context) {
		final panels = [for (final label in [..._scene.left, ..._scene.right, ..._scene.bottom]) KlpDockPanel(
			id: label, header: KlpText(label, role: KlpTextRole.code), content: _panel(context, label),
			onCloseRequested: _approveClose, closeLabel: '關閉 $label',
		)];
		final available = KlpDockLayoutCodec.restore(KlpDockLayoutCodec.encode(_layout), panels: _policies).availablePanelIds;
		final children = <Widget>[
			Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: [
				KlpButton(label: '工作區選單', selected: _menuOpen, onPressed: () => setState(() => _menuOpen = !_menuOpen)),
				KlpButton(label: '命令面板', onPressed: _openPalette),
				if (widget.id == 'blender') ...[for (final value in ['Layout', 'Modeling', 'Animation']) KlpButton(label: value, selected: _workspace == value, onPressed: () => _switchWorkspace(value))],
			]),
			if (_menuOpen) KlpRegisteredCommandMenu<_SceneContext>(registry: _registry, getContext: _getContext, items: _items,
				label: '工作區選單命令', emptyLabel: '沒有可用命令', onResult: _onResult),
			KlpRegisteredCommandToolbar<_SceneContext>(registry: _registry, getContext: _getContext, items: _items,
				label: '場景命令工具列', onResult: _onResult),
			SizedBox(height: 540, child: KlpDockLayout(stage: _stage(context), layout: _layout, panels: panels,
				onLayoutChanged: _commit, leftConstraints: const KlpDockAreaConstraints(minExtent: 100, maxExtent: 320), rightConstraints: const KlpDockAreaConstraints(minExtent: 120, maxExtent: 320),
				bottomConstraints: const KlpDockAreaConstraints(minExtent: 70, maxExtent: 240))),
			KlpText('布局 $_layoutCount 次 · Explorer $_explorerCount 次 · 命令 $_commandCount 次 · $_message · 快捷鍵：${_handling?.state.name ?? '尚未按鍵'}', role: KlpTextRole.caption),
			Wrap(spacing: context.klp.space.actionGap, children: [for (final id in available) KlpButton(label: '重開 $id', onPressed: () => _openPanel(id))]),
			KlpTextField(label: '保存布局 JSON', controller: _saved, multiline: true, minLines: 2, maxLines: 5),
			KlpRegisteredCommandPalette<_SceneContext>(registry: _registry, getContext: _getContext, open: _paletteOpen,
				label: '場景命令面板', searchLabel: '搜尋場景命令', emptyLabel: '沒有符合的命令',
				onResult: _onResult, onDismiss: (reason) => setState(() => _paletteOpen = false)),
		];
		return KlpCommandShortcutHost<_SceneContext>(keymap: _keymap, getContext: _getContext, getFocus: _getFocus,
			getIsComposing: _getIsComposing, onHandling: (value) => setState(() => _handling = value), onResult: _onResult,
			child: _stack(context, children));
	}
}
