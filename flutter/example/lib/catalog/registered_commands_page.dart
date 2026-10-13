import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kallopis/kallopis_foundation.dart';

import '../catalog_model.dart';

final registeredCommandsPage = CatalogPageData(
	label: 'Commands',
	title: '命令與入口',
	description: '同一份清冊供工具列、選單與搜尋面板使用；產品持有條件、結果及開關。',
	icon: KlpIcons.search,
	coveredComponents: const ['KlpRegisteredCommandToolbar', 'KlpRegisteredCommandMenu', 'KlpRegisteredCommandPopup', 'KlpCommandShortcutHost'],
	specimens: [Specimen(name: 'KlpRegisteredCommandPalette', note: '搜尋、停用、執行中與錯誤保留均可操作；關閉只由產品採用意圖。', build: _buildCommands)],
);

const commandSpecimenNames = <String>['KlpRegisteredCommandToolbar', 'KlpRegisteredCommandMenu', 'KlpRegisteredCommandPalette', 'KlpRegisteredCommandPopup', 'KlpCommandShortcutHost'];

Widget _buildCommands(BuildContext context) => const RegisteredCommandsDemo();

class _DemoContext {
	const _DemoContext(this.canSave, this.grid, this.showFailure);
	/* 當前產品條件只透過 getContext 投影，不由入口維護另一份狀態。 */
	final bool canSave;
	final bool grid;
	final bool showFailure;
}

class RegisteredCommandsDemo extends StatefulWidget {
	const RegisteredCommandsDemo({super.key, this.specimen});
	/* null保留完整Catalog；專屬route只投影自己的命令入口。 */
	final String? specimen;
	@override
	State<RegisteredCommandsDemo> createState() => _CommandsDemoState();
}

class _CommandsDemoState extends State<RegisteredCommandsDemo> {
	/* 清冊與草稿屬於這個產品展示，主題／尺寸更新保持同一份 owner。 */
	final _registry = KlpCommandRegistry<_DemoContext>();
	final _draft = TextEditingController(text: '保留這份草稿與游標');
	/* keymap 借用同清冊；settings 為產品JSON暫存；recorderFocus 是明確原生錄製目標。
	 * handling 為最後核心事件，settingsMessage 為原錯誤回饋；refreshScheduled 只合併焦點重繪。 */
	late final KlpCommandKeymap<_DemoContext> _keymap;
	final _settings = TextEditingController();
	final _recorderFocus = FocusNode(debugLabel: 'commands-recorder');
	KlpShortcutHandling? _handling;
	String _settingsMessage = '尚未匯入設定';
	bool _refreshScheduled = false;
	/* 條件、開關與回饋由產品持有；入口只查詢與提出執行／關閉意圖。 */
	bool _canSave = true;
	bool _grid = false;
	bool _showFailure = false;
	bool _open = false;
	int _resultCount = 0;
	String _message = '尚未執行命令';
	KlpCommandDismissReason? _dismissReason;
	/* popupOpen／popupAnchor 為產品觸發資料；popupReason 為回饋；popupButton 量測按鈕原生bounds。
	 * ownsBrowserMenu 僅在此 Web demo 原本啟用時暫停原生context選單，卸載還原。 */
	bool _popupOpen = false;
	Rect _popupAnchor = Rect.zero;
	KlpCommandPopupDismissReason? _popupReason;
	final _popupButton = GlobalKey();
	bool _ownsBrowserMenu = false;
	/* 參照只擁有排列與角色，沒有複製 handler 或 checked。 */
	static const _toolbarItems = [KlpCommandReference(commandId: 'document.save'), KlpCommandReference(commandId: 'view.grid', kind: KlpCommandKind.toggle)];
	static const _menuItems = [..._toolbarItems, KlpCommandReference(commandId: 'document.fail')];

	_DemoContext _getContext() => _DemoContext(_canSave, _grid, _showFailure);

	@override
	void initState() {
		super.initState();
		FocusManager.instance.addListener(_refreshShortcuts);
		if (kIsWeb && BrowserContextMenu.enabled) {
			_ownsBrowserMenu = true;

			// 自訂 context trigger 只在 demo 掛載期間暫停瀏覽器原生選單。
			BrowserContextMenu.disableContextMenu();
		}
		_registry.register(KlpCommandDefinition<_DemoContext>(
			id: 'document.save',
			label: '儲存文件',
			description: '儲存目前文件',
			category: '文件',
			keywords: const ['save', 'document'],
			isEnabled: (context) => context.canSave,
			handler: _save,
		));
		_registry.register(KlpCommandDefinition<_DemoContext>(
			id: 'view.grid',
			label: '顯示格線',
			description: '切換畫布格線',
			category: '視圖',
			keywords: const ['grid', 'canvas'],
			isChecked: (context) => context.grid,
			handler: _toggleGrid,
		));
		_registry.register(KlpCommandDefinition<_DemoContext>(
			id: 'document.fail',
			label: '模擬失敗',
			description: '觀察原始錯誤與面板保留',
			category: '文件',
			keywords: const ['error', 'failure'],
			isVisible: (context) => context.showFailure,
			handler: _fail,
		));

		// 平台投影只決定 primary 修飾鍵；命令處理與清冊保持同一份。
		final isMac = defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.iOS;
		_keymap = KlpCommandKeymap(registry: _registry, platform: isMac ? KlpShortcutPlatform.mac : KlpShortcutPlatform.other);
		/* id 是覆寫識別，commandId 指向清冊，sequence 是預設按鍵；scope／scopeId 為產品作用域。
		 * allowInEditable 允許草稿儲存／局部格線，priority 讓同page衝突可觀察。 */
		_keymap.register(KlpShortcutBinding(id: 'document.save.primary', commandId: 'document.save', sequence: [KlpShortcutStroke(key: 's', primary: true)], scope: KlpShortcutScope.app, allowInEditable: true));
		_keymap.register(KlpShortcutBinding(id: 'document.save.chord', commandId: 'document.save', sequence: [KlpShortcutStroke(key: 'k', primary: true), KlpShortcutStroke(key: 's')], scope: KlpShortcutScope.app, allowInEditable: true));
		_keymap.register(KlpShortcutBinding(id: 'view.grid.primary', commandId: 'view.grid', sequence: [KlpShortcutStroke(key: 'g', primary: true)], scope: KlpShortcutScope.page, scopeId: 'commands'));
		_keymap.register(KlpShortcutBinding(id: 'view.grid.duplicate', commandId: 'view.grid', sequence: [KlpShortcutStroke(key: 'g', primary: true)], scope: KlpShortcutScope.page, scopeId: 'commands', priority: -1));
		_keymap.register(KlpShortcutBinding(id: 'view.grid.editor', commandId: 'view.grid', sequence: [KlpShortcutStroke(key: 'g', primary: true)], scope: KlpShortcutScope.component, scopeId: 'draft', allowInEditable: true));
		_keymap.register(KlpShortcutBinding(id: 'document.fail.region', commandId: 'document.fail', sequence: [KlpShortcutStroke(key: 'f', alt: true, shift: true)], scope: KlpShortcutScope.region, scopeId: 'commands'));
	}

	EditableText? _focusedEditor() {
		final context = FocusManager.instance.primaryFocus?.context;
		if (context?.widget is EditableText) return context!.widget as EditableText;

		return context?.findAncestorWidgetOfExactType<EditableText>();
	}
	KlpShortcutFocus _getFocus() {
		final focus = FocusManager.instance.primaryFocus;
		final controller = _focusedEditor()?.controller;
		return KlpShortcutFocus(focusId: 'commands-focus-${identityHashCode(focus)}', pageId: 'commands', regionId: 'commands', componentId: identical(controller, _draft) ? 'draft' : null, editable: identical(controller, _draft) || identical(controller, _settings));
	}
	bool _getIsComposing() {
		final composing = _focusedEditor()?.controller.value.composing;
		return composing != null && composing.isValid && !composing.isCollapsed;
	}
	void _refreshShortcuts() {
		if (!mounted || _refreshScheduled) return;

		_refreshScheduled = true;
		void refresh(Duration timestamp) {
			_refreshScheduled = false;
			if (mounted) setState(() {});
		}
		WidgetsBinding.instance.addPostFrameCallback(refresh);
		WidgetsBinding.instance.ensureVisualUpdate();
	}
	void _onHandling(KlpShortcutHandling value) => setState(() => _handling = value);
	void _beginRecording() {
		// Flutter requestFocus 在當幀後提交；只能以實際錄製目標取得的primary focus開始。
		_recorderFocus.requestFocus();
		void begin(Duration timestamp) {
			if (!mounted || !_recorderFocus.hasPrimaryFocus) return;

			_keymap.beginRecording(_getFocus().focusId);
			setState(() {});
		}
		WidgetsBinding.instance.addPostFrameCallback(begin);
	}
	void _applyRecording() {
		final sequence = _keymap.finishRecording();
		if (sequence.isNotEmpty) _keymap.setOverride('document.save.primary', sequence);
		setState(() => _settingsMessage = sequence.isNotEmpty ? '已套用儲存快捷鍵' : '沒有錄製按鍵；保留原設定');
	}
	void _cancelRecording() { _keymap.cancelRecording(); setState(() {}); }
	void _restoreShortcut() {
		_keymap.restore('document.save.primary');
		setState(() => _settingsMessage = '已還原儲存快捷鍵');
	}
	void _exportSettings() {
		// 僅序列化公開覆寫資料，不保存handler或產品context。
		_settings.text = jsonEncode(_keymap.exportOverrides());
		setState(() => _settingsMessage = '已匯出覆寫設定');
	}
	void _importSettings() {
		try {
			// 公開核心完整驗證後原子替換；產品只顯示原始錯誤。
			_keymap.importOverrides(jsonDecode(_settings.text));
			setState(() => _settingsMessage = '已匯入覆寫設定');
		}
		catch (error) {
			setState(() => _settingsMessage = '匯入失敗：$error');
		}
	}
	String _describeStroke(KlpShortcutStroke stroke) {
		final parts = <String>[];
		if (stroke.primary) parts.add(_keymap.platform == KlpShortcutPlatform.mac ? '⌘' : 'Ctrl');
		if (stroke.ctrl) parts.add('Ctrl');
		if (stroke.alt) parts.add('Alt');
		if (stroke.shift) parts.add('Shift');
		if (stroke.meta) parts.add('Meta');
		parts.add(stroke.key);
		return parts.join('+');
	}

	Future<String> _save(_DemoContext context) async {
		await Future<void>.delayed(const Duration(milliseconds: 800));
		return '文件已儲存';
	}

	Object? _toggleGrid(_DemoContext context) {
		setState(() => _grid = !_grid);
		_registry.refresh();
		return null;
	}

	Object? _fail(_DemoContext context) => throw StateError('展示儲存失敗');

	void _onResult(KlpCommandExecutionResult result) {
		setState(() {
			_resultCount++;
			if (result.status == KlpCommandExecutionStatus.executed) {
				_message = result.commandId == 'document.save' ? result.value.toString() : '已切換格線';
			}
			else if (result.status == KlpCommandExecutionStatus.error) { _message = result.error.toString(); }
			else { _message = '命令未執行：${result.status.name}'; }
		});
	}

	void _onDismiss(KlpCommandDismissReason reason) {
		setState(() { _dismissReason = reason; _open = false; });
	}

	void _openPalette() => setState(() => _open = true);
	void _openPopup(Rect anchor) {
		setState(() { _open = false; _popupAnchor = anchor; _popupOpen = true; });
	}
	void _openButtonPopup() {
		final render = _popupButton.currentContext?.findRenderObject();
		if (render is RenderBox) _openPopup(render.localToGlobal(Offset.zero) & render.size);
	}
	void _openPointPopup(TapDownDetails details) => _openPopup(details.globalPosition & Size.zero);
	void _dismissPopup(KlpCommandPopupDismissReason reason) {
		setState(() { _popupReason = reason; _popupOpen = false; });
	}
	void _toggleSave() { setState(() => _canSave = !_canSave); _registry.refresh(); }
	void _toggleFailure() { setState(() => _showFailure = !_showFailure); _registry.refresh(); }

	@override
	void dispose() {
		if (_ownsBrowserMenu) BrowserContextMenu.enableContextMenu();
		FocusManager.instance.removeListener(_refreshShortcuts);
		_keymap.dispose();
		_recorderFocus.dispose();
		_settings.dispose();
		_registry.dispose();
		_draft.dispose();
		super.dispose();
	}

	bool _shows(String name) => widget.specimen == null || widget.specimen == name;

	Widget _controls(BuildContext context) {
		final children = [
			KlpButton(label: '允許儲存：${_canSave ? '開' : '關'}', onPressed: _toggleSave),
			KlpButton(label: '顯示失敗命令：${_showFailure ? '開' : '關'}', onPressed: _toggleFailure),
			if (_shows('KlpRegisteredCommandPalette')) KlpButton(label: '開啟命令面板', onPressed: _openPalette),
			if (_shows('KlpRegisteredCommandPopup')) KlpButton(key: _popupButton, label: '開啟錨定選單', onPressed: _openButtonPopup),
		];
		return Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: children);
	}

	@override
	Widget build(BuildContext context) {
		final toolbar = KlpRegisteredCommandToolbar<_DemoContext>(registry: _registry, getContext: _getContext, items: _toolbarItems, label: '展示命令工具列', onResult: _onResult);
		final menu = KlpRegisteredCommandMenu<_DemoContext>(registry: _registry, getContext: _getContext, items: _menuItems, label: '展示命令選單', emptyLabel: '目前沒有命令', onResult: _onResult);
		final palette = KlpRegisteredCommandPalette<_DemoContext>(
			registry: _registry,
			getContext: _getContext,
			open: _open,
			label: '命令面板',
			searchLabel: '搜尋命令',
			emptyLabel: '沒有符合的命令',
			onResult: _onResult,
			onDismiss: _onDismiss,
		);
		final popup = KlpRegisteredCommandPopup<_DemoContext>(
			registry: _registry,
			getContext: _getContext,
			items: _menuItems,
			label: '快顯命令選單',
			emptyLabel: '目前沒有命令',
			open: _popupOpen,
			anchor: _popupAnchor,
			onResult: _onResult,
			onDismiss: _dismissPopup,
		);
		final contextArea = KlpSurface(child: Padding(padding: EdgeInsets.all(context.klp.space.contentStackGap), child: const KlpText('在此按右鍵開啟命令選單')));
		final children = <Widget>[
			KlpTextField(label: '命令展示草稿', controller: _draft),
			_controls(context),
			if (_shows('KlpRegisteredCommandPopup')) GestureDetector(behavior: HitTestBehavior.opaque, onSecondaryTapDown: _openPointPopup, child: contextArea),
			if (_shows('KlpRegisteredCommandToolbar')) toolbar,
			if (_shows('KlpRegisteredCommandMenu')) menu,
			if (_shows('KlpRegisteredCommandPalette')) palette,
			if (_shows('KlpRegisteredCommandPopup')) popup,
			KlpText('結果 $_resultCount 次：$_message · 格線：${_grid ? '開' : '關'} · 最近關閉：${_dismissReason?.name ?? '尚未關閉'} · 快顯關閉：${_popupReason?.name ?? '尚未關閉'}', role: KlpTextRole.caption),
			if (_shows('KlpCommandShortcutHost')) ..._shortcutControls(context),
			if (widget.specimen != null) KlpText(_usage(), role: KlpTextRole.code),
		];
		final spaced = <Widget>[];
		for (final child in children) {
			if (spaced.isNotEmpty) spaced.add(SizedBox(height: context.klp.space.contentStackGap));
			spaced.add(child);
		}
		return KlpCommandShortcutHost<_DemoContext>(
			keymap: _keymap,
			getContext: _getContext,
			getFocus: _getFocus,
			getIsComposing: _getIsComposing,
			onHandling: _onHandling,
			onResult: _onResult,
			child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: spaced),
		);
	}

	String _usage() {
		final name = widget.specimen!;
		const import = "import 'package:kallopis/kallopis_foundation.dart';";
		if (name == 'KlpCommandShortcutHost') return '$import\n$name<Context>(keymap: keymap, getContext: getContext, getFocus: getFocus, getIsComposing: getIsComposing, onHandling: onHandling, onResult: onResult, child: child)';
		if (name == 'KlpRegisteredCommandPalette') return '$import\n$name<Context>(registry: registry, getContext: getContext, open: open, label: label, searchLabel: searchLabel, emptyLabel: emptyLabel, onResult: onResult, onDismiss: onDismiss)';
		if (name == 'KlpRegisteredCommandPopup') return '$import\n$name<Context>(registry: registry, getContext: getContext, items: items, open: open, anchor: anchor, label: label, emptyLabel: emptyLabel, onResult: onResult, onDismiss: onDismiss)';
		return '$import\n$name<Context>(registry: registry, getContext: getContext, items: items, label: label, onResult: onResult)';
	}

	List<Widget> _shortcutControls(BuildContext context) {
		final focus = _getFocus();
		final conflicts = _keymap.conflicts(focus, _getContext());
		final conflictText = conflicts.map((value) => '${value.kind.name} ${value.bindingIds.join(' / ')} → ${value.winnerId}').join('；');
		final pending = _keymap.pendingSequence.map(_describeStroke).join(' → ');
		final recorded = _keymap.recordedSequence.map(_describeStroke).join(' → ');
		final controls = [
			KlpButton(label: '開始錄製', onPressed: _beginRecording),
			KlpButton(label: '套用錄製為儲存快捷鍵', onPressed: _keymap.recordedSequence.isEmpty ? null : _applyRecording),
			KlpButton(label: '取消錄製', onPressed: _cancelRecording),
			KlpButton(label: '還原儲存快捷鍵', onPressed: _restoreShortcut),
		];
		final recordText = _keymap.isRecording ? '正在錄製；最多四組按鍵，Escape 取消' : '按下開始錄製後，在此輸入新快捷鍵';
		return [
			const KlpText('快捷鍵與設定', role: KlpTextRole.bodyStrong),
			KlpText('Primary+S 儲存；Primary+K → S 連續按鍵；Primary+G 切換格線。草稿中的格線由component作用域接管；啟用失敗命令後可用Alt+Shift+F。Primary在此平台為${_keymap.platform == KlpShortcutPlatform.mac ? '⌘' : 'Ctrl'}。'),
			Focus(focusNode: _recorderFocus, child: Semantics(label: '快捷鍵錄製區', child: KlpSurface(child: Padding(padding: EdgeInsets.all(context.klp.space.contentStackGap), child: KlpText('錄製區：$recordText'))))),
			Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: controls),
			KlpText('最近處理：${_handling?.state.name ?? '尚未按鍵'} · 綁定：${_handling?.bindingId ?? '無'} · 目前連續按鍵：${pending.isEmpty ? '無' : pending} · 已錄製：${recorded.isEmpty ? '無' : recorded}', role: KlpTextRole.caption),
			KlpText('作用域：${focus.componentId ?? focus.pageId} · 衝突：${conflictText.isEmpty ? '無' : conflictText}', role: KlpTextRole.caption),
			KlpTextField(label: '快捷鍵設定 JSON', controller: _settings, helper: '匯入錯誤會保留既有設定'),
			Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: [KlpButton(label: '匯出設定', onPressed: _exportSettings), KlpButton(label: '匯入設定', onPressed: _importSettings)]),
			KlpText(_settingsMessage, role: KlpTextRole.caption),
		];
	}
}
