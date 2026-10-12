import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

import '../catalog_model.dart';

final registeredCommandsPage = CatalogPageData(
	label: 'Commands',
	title: '命令與入口',
	description: '同一份清冊供工具列、選單與搜尋面板使用；產品持有條件、結果及開關。',
	icon: KlpIcons.search,
	coveredComponents: const ['KlpRegisteredCommandToolbar', 'KlpRegisteredCommandMenu'],
	specimens: [Specimen(name: 'KlpRegisteredCommandPalette', note: '搜尋、停用、執行中與錯誤保留均可操作；關閉只由產品採用意圖。', build: _buildCommands)],
);

Widget _buildCommands(BuildContext context) => const _CommandsDemo();

class _DemoContext {
	const _DemoContext(this.canSave, this.grid, this.showFailure);
	/* 當前產品條件只透過 getContext 投影，不由入口維護另一份狀態。 */
	final bool canSave;
	final bool grid;
	final bool showFailure;
}

class _CommandsDemo extends StatefulWidget {
	const _CommandsDemo();
	@override
	State<_CommandsDemo> createState() => _CommandsDemoState();
}

class _CommandsDemoState extends State<_CommandsDemo> {
	/* 清冊與草稿屬於這個產品展示，主題／尺寸更新保持同一份 owner。 */
	final _registry = KlpCommandRegistry<_DemoContext>();
	final _draft = TextEditingController(text: '保留這份草稿與游標');
	/* 條件、開關與回饋由產品持有；入口只查詢與提出執行／關閉意圖。 */
	bool _canSave = true;
	bool _grid = false;
	bool _showFailure = false;
	bool _open = false;
	int _resultCount = 0;
	String _message = '尚未執行命令';
	KlpCommandDismissReason? _dismissReason;
	/* 參照只擁有排列與角色，沒有複製 handler 或 checked。 */
	static const _toolbarItems = [KlpCommandReference(commandId: 'document.save'), KlpCommandReference(commandId: 'view.grid', kind: KlpCommandKind.toggle)];
	static const _menuItems = [..._toolbarItems, KlpCommandReference(commandId: 'document.fail')];

	_DemoContext _getContext() => _DemoContext(_canSave, _grid, _showFailure);

	@override
	void initState() {
		super.initState();
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
	void _toggleSave() { setState(() => _canSave = !_canSave); _registry.refresh(); }
	void _toggleFailure() { setState(() => _showFailure = !_showFailure); _registry.refresh(); }

	@override
	void dispose() {
		_registry.dispose();
		_draft.dispose();
		super.dispose();
	}

	Widget _controls(BuildContext context) {
		final children = [
			KlpButton(label: '允許儲存：${_canSave ? '開' : '關'}', onPressed: _toggleSave),
			KlpButton(label: '顯示失敗命令：${_showFailure ? '開' : '關'}', onPressed: _toggleFailure),
			KlpButton(label: '開啟命令面板', onPressed: _openPalette),
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
		final children = <Widget>[
			KlpTextField(label: '命令展示草稿', controller: _draft),
			_controls(context),
			toolbar,
			menu,
			palette,
			KlpText('結果 $_resultCount 次：$_message · 格線：${_grid ? '開' : '關'} · 最近關閉：${_dismissReason?.name ?? '尚未關閉'}', role: KlpTextRole.caption),
		];
		final spaced = <Widget>[];
		for (final child in children) {
			if (spaced.isNotEmpty) spaced.add(SizedBox(height: context.klp.space.contentStackGap));
			spaced.add(child);
		}
		return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: spaced);
	}
}
