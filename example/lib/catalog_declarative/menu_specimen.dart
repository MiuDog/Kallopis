import 'package:kallopis/kallopis_declarative.dart';

/// 選單遷移的真實宣告式展示；操作後以新資料更新同一棵應用樹。
void runMenuCatalog() {
	final catalog = _MenuCatalog();
	runKlpApp(catalog.source.readOnly);
}

final class _MenuCatalog {

	late final source = KlpMutableState(_application());
	final destination = KlpDestination<Object?, Object?>(KlpId.parse('menu.catalog'));
	String _lastAction = '以滑鼠或方向鍵操作';
	bool _showHidden = false;

	void _record(String label) {
		_lastAction = label;
		source.value = _application();
	}

	KlpApplication _application() {
		return KlpApplication(
			title: 'Kallopis Catalog — Menu migration',
			router: KlpRouter(id: KlpId.parse('menu.router'), initial: destination.location(null), routes: [KlpRoute<Object?, Object?>(destination, screen: (_) => KlpScreen(
				id: KlpId.parse('menu.screen'),
				accessibilityLabel: '新版選單元件展示',
				child: KlpAppLayout(id: KlpId.parse('menu.layout'), child: KlpAppFrame(id: KlpId.parse('menu.frame'), child: KlpFrameGroups(id: KlpId.parse('menu.groups'), groups: [KlpFrameGroup(id: KlpId.parse('menu.group'), content: [
					KlpMenu(
						id: KlpId.parse('menu.specimen'),
						triggerLabel: '開啟選單',
						label: _lastAction,
						onEscape: () => _record('已按 Escape'),
						items: [
							KlpMenuItem(id: KlpId.parse('open'), label: '開啟', icon: KlpWorkspaceIcon.folder, shortcut: 'Enter', onPressed: () => _record('開啟')),
							KlpMenuItem(id: KlpId.parse('selected'), label: '目前選取', selected: true, onPressed: () => _record('目前選取')),
							KlpMenuItem(id: KlpId.parse('disabled'), label: '無法使用', enabled: false, onPressed: () => _record('錯誤：停用操作')),
							KlpMenuItem(id: KlpId.parse('toggle'), label: '顯示隱藏項目', separatedBefore: true, toggleValue: _showHidden, onPressed: () { _showHidden = !_showHidden; _record('顯示隱藏：$_showHidden'); }),
							KlpMenuItem(id: KlpId.parse('submenu'), label: '更多操作', children: [
								KlpMenuItem(id: KlpId.parse('copy-link'), label: '複製連結', icon: KlpWorkspaceIcon.link, onPressed: () => _record('已複製連結（展示事件）')),
								KlpMenuItem(id: KlpId.parse('nested-disabled'), label: '暫不可用', enabled: false),
								KlpMenuItem(id: KlpId.parse('export'), label: '匯出格式', children: [
									KlpMenuItem(id: KlpId.parse('export-text'), label: '純文字', onPressed: () => _record('純文字匯出（展示事件）')),
									KlpMenuItem(id: KlpId.parse('export-markdown'), label: 'Markdown', onPressed: () => _record('Markdown 匯出（展示事件）')),
								]),
							]),
							KlpMenuItem(id: KlpId.parse('remove'), label: '刪除', destructive: true, dashedSeparatorBefore: true, onPressed: () => _record('刪除事件')),
						],
					),
				])]))),
			))]),
		);
	}
}
