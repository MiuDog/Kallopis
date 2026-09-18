import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:kallopis/kallopis_declarative.dart' as klp;
import 'catalog/explorer_preview.dart';

void main() => runApp(const _ExplorerCatalog());

final class _ExplorerCatalog extends StatefulWidget {

	const _ExplorerCatalog();

	@override
	State<_ExplorerCatalog> createState() => _ExplorerCatalogState();
}

final class _ExplorerCatalogState extends State<_ExplorerCatalog> {

	bool _dark = false;
	bool _geometry = false;
	bool _allowDrop = false;
	bool _collapseDescendants = false;
	String _event = '選取、啟用、展開與拖放事件會顯示在此';

	List<klp.KlpExplorerItemModel> _items() {
		klp.KlpExplorerNodeModel node(String id, String title, {bool container = false, List<klp.KlpExplorerItemModel> children = const []}) => klp.KlpExplorerNodeModel(
			id: klp.KlpId.root(id), row: klp.KlpExplorerRowData(title: title, icon: klp.KlpExplorerGlyph.file, contextActions: [klp.KlpWorkspaceCommand(label: '重新命名', inputLabel: '名稱', initialValue: title, onInvoke: (value) => setState(() => _event = '提交名稱：$value'), onResult: (result) => setState(() => _event = '命令結果：${result.status.name}'))]), canHaveChildren: container, capabilities: const klp.KlpExplorerCapabilities(selectable: true, collapsible: true, draggable: true, primaryAction: klp.KlpExplorerPrimaryAction.activate), children: children,
		);
		return [
			klp.KlpExplorerCategoryModel(
				id: klp.KlpId.root('category'), row: klp.KlpExplorerRowData(title: '分類：可收合，不可選取'), capabilities: const klp.KlpExplorerCapabilities(collapsible: true, primaryAction: klp.KlpExplorerPrimaryAction.toggleExpansion),
				children: [node('plain', '節點：選取與啟用分離'), node('parent', '可承載節點', container: true, children: [node('child', '子節點'), node('deep', '第二層', container: true, children: [node('leaf', '第三層節點')])]), node('empty', '空的可承載節點：不顯示箭頭', container: true), node('long', '長標題：應在可用空間省略，而不越出列的視覺及命中範圍，也不壓縮必要操作')],
			),
			klp.KlpExplorerCategoryModel(id: klp.KlpId.root('selectable-category'), row: klp.KlpExplorerRowData(title: '分類也可選取', badge: '3'), capabilities: const klp.KlpExplorerCapabilities(selectable: true)),
			klp.KlpExplorerCategoryModel(id: klp.KlpId.root('empty-category'), row: klp.KlpExplorerRowData(title: '空分類：仍可展開／收合'), capabilities: const klp.KlpExplorerCapabilities(collapsible: true, primaryAction: klp.KlpExplorerPrimaryAction.toggleExpansion)),
			klp.KlpExplorerNodeModel(id: klp.KlpId.root('always-open'), row: klp.KlpExplorerRowData(title: '不收合，子項一直可見'), canHaveChildren: true, children: [node('visible', '沒有展開狀態仍可見')]),
			klp.KlpExplorerNodeModel(id: klp.KlpId.root('inline'), row: klp.KlpExplorerRowData(title: '明列行內命令', inlineActions: [klp.KlpWorkspaceCommand(label: '確認', confirmation: '確定執行示例命令？', onInvoke: (_) => setState(() => _event = '已確認執行'))]), canHaveChildren: false),
		];
	}

	@override
	Widget build(BuildContext context) => MaterialApp(
		debugShowCheckedModeBanner: false,
		theme: ThemeData(brightness: _dark ? Brightness.dark : Brightness.light),
		home: Scaffold(
			appBar: AppBar(title: const Text('Explorer v1 · 視覺候選，尚待接受')),
			body: Column(children: [
				Wrap(spacing: 24, children: [
					Row(mainAxisSize: MainAxisSize.min, children: [const Text('深色'), Switch(value: _dark, onChanged: (value) => setState(() => _dark = value))]),
					Row(mainAxisSize: MainAxisSize.min, children: [const Text('布局／命中框'), Switch(value: _geometry, onChanged: (value) => setState(() { _geometry = value; debugPaintSizeEnabled = value; }))]),
					Row(mainAxisSize: MainAxisSize.min, children: [const Text('允許拖放'), Switch(value: _allowDrop, onChanged: (value) => setState(() => _allowDrop = value))]),
					Row(mainAxisSize: MainAxisSize.min, children: [const Text('遞迴收合後代'), Switch(value: _collapseDescendants, onChanged: (value) => setState(() => _collapseDescendants = value))]),
				]),
				const Padding(padding: EdgeInsets.all(12), child: Text('一般列背景透明。Ctrl／⌘ 切換選取，Shift 連續選取，方向鍵移動焦點，Enter 啟用。右鍵選單與行內命令分開宣告。')),
				Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
					Expanded(child: Padding(padding: const EdgeInsets.all(16), child: ExplorerPreview(framed: true, items: _items(), dark: _dark, allowDrop: _allowDrop, collapseDescendants: _collapseDescendants, onEvent: (value) => setState(() => _event = value)))),
					if (constraints.maxWidth >= 720) const VerticalDivider(),
					if (constraints.maxWidth >= 720) SizedBox(width: 280, child: Padding(padding: const EdgeInsets.all(16), child: ExplorerPreview(framed: true, items: _items(), dark: _dark, allowDrop: _allowDrop, collapseDescendants: _collapseDescendants, onEvent: (value) => setState(() => _event = value)))),
				]))),
				Padding(padding: const EdgeInsets.all(16), child: Text(_event)),
			]),
		),
	);
}
