import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final restoredWorkspaceComponentsPage = CatalogPageData(
	label: 'Workspace components',
	title: '工作區元件',
	description: '直接由 Flutter 組裝的工作區版面、文件分頁、內容群組與錨定命令。',
	icon: KlpIcons.panelSplit,
	specimens: [
		Specimen(
			name: 'KlpAppLayout',
			note: '以 8px 標準間距排列受控 layout node；floatingAction 可在工作區內拖曳。',
			build: (context) => SizedBox(
				height: 280,
				child: KlpAppLayout(
					floatingAction: KlpButton(
						label: '新增',
						onPressed: () {},
						tone: KlpButtonTone.primary,
					),
					child: LayoutRow(
						children: [
							KlpAppFrame(
								role: KlpAppFrameRole.sidebar,
								child: const Center(child: KlpText('SIDEBAR')),
							),
							KlpAppFrame(
								child: const Center(child: KlpText('WORKBENCH')),
							),
						],
					),
				),
			),
		),
		Specimen(
			name: 'KlpFrameGroups',
			note: 'Frame 只接收功能性群組；群組的內距、內容節奏與分隔線由 Kallopis 約束。',
			build: (context) => SizedBox(
				height: 240,
				child: KlpPanelFrame(
					header: const KlpPanelHeader(title: 'INSPECTOR'),
					content: KlpFrameGroups(
						groups: [
							KlpFrameGroup(
								content: const [
									KlpText('Selection'),
									KlpText('2 objects', tone: KlpTextTone.muted),
								],
								style: const KlpFrameGroupStyle(
									contentSpacing: KlpFrameGroupContentSpacing.standard,
								),
							),
							KlpFrameGroup(
								content: const [KlpText('Appearance')],
								style: const KlpFrameGroupStyle(
									divider: KlpFrameGroupDivider.dashed,
								),
							),
						],
						footer: KlpFrameGroup(
							content: [KlpButton(label: '套用', onPressed: () {})],
						),
					),
				),
			),
		),
		Specimen(
			name: 'KlpDocumentTabs',
			note: '文件生命週期由 consumer 持有；元件只回報選取、關閉與釘選意圖。',
			build: (context) => const _DocumentTabsSpecimen(),
		),
		Specimen(
			name: 'KlpAnchoredPopup',
			note: '以 trigger 實際位置錨定，並用 KlpWorkspaceCommand 呈現輸入或確認流程。',
			build: (context) => const _AnchoredPopupSpecimen(),
		),
	],
	coveredComponents: const ['KlpFrameGroup'],
);

final class _DocumentTabsSpecimen extends StatefulWidget {
	const _DocumentTabsSpecimen();

	@override
	State<_DocumentTabsSpecimen> createState() => _DocumentTabsSpecimenState();
}

final class _DocumentTabsSpecimenState extends State<_DocumentTabsSpecimen> {
	var _selectedId = 'brief';
	var _tabs = [
		KlpDocumentTab(id: 'brief', label: 'Brief', dirty: true, pinned: true),
		KlpDocumentTab(id: 'canvas', label: 'Canvas'),
		KlpDocumentTab(id: 'notes', label: 'Notes'),
	];

	void _close(String id) {
		setState(() {
			_tabs = _tabs.where((tab) => tab.id != id).toList();
			if (_selectedId == id) _selectedId = _tabs.isEmpty ? '' : _tabs.first.id;
		});
	}

	void _pin(String id, bool pinned) {
		setState(() {
			_tabs = [
				for (final tab in _tabs)
					KlpDocumentTab(
						id: tab.id,
						label: tab.label,
						dirty: tab.dirty,
						closable: tab.closable,
						pinned: tab.id == id ? pinned : tab.pinned,
					),
			];
		});
	}

	@override
	Widget build(BuildContext context) => KlpDocumentTabs(
		tabs: _tabs,
		selectedId: _selectedId,
		onSelected: (id) => setState(() => _selectedId = id),
		onClose: _close,
		onPinnedChanged: _pin,
	);
}

final class _AnchoredPopupSpecimen extends StatefulWidget {
	const _AnchoredPopupSpecimen();

	@override
	State<_AnchoredPopupSpecimen> createState() => _AnchoredPopupSpecimenState();
}

final class _AnchoredPopupSpecimenState extends State<_AnchoredPopupSpecimen> {
	var _open = false;

	@override
	Widget build(BuildContext context) => Align(
		alignment: Alignment.centerLeft,
		child: KlpAnchoredPopup(
			open: _open,
			accessibilityLabel: '文件動作',
			title: '文件動作',
			triggerBuilder: (context, toggle, expanded) => KlpButton(
				label: expanded ? '關閉動作' : '開啟動作',
				onPressed: toggle,
			),
			actions: [
				KlpWorkspaceCommand(
					label: '重新命名',
					inputLabel: '名稱',
					initialValue: 'Project brief',
					onInvoke: (value) {},
				),
				KlpWorkspaceCommand(
					label: '刪除',
					destructive: true,
					confirmation: '確定刪除這份文件？',
					onInvoke: (value) {},
				),
			],
			onOpenChanged: (open, reason) => setState(() => _open = open),
		),
	);
}
