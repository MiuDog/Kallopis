import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_selection_surface.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_workspace_block.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_set.dart';
import 'package:kallopis/src/styling/presets/klp_workspace_preset.dart';

import 'klp_explorer_test.dart' show explorerData;

part 'support/workspace_dialog_checks.dart';

/// 經應用的實際註冊、編譯及 renderer 驗證，避免只測到孤立的舊 Widget。
class _Harness {
	final runtime = KlpTreeRuntime();

	Future<void> show(WidgetTester tester, KlpNode child, {KlpPrimitiveSet? primitives}) async {
		final screen = KlpScreen(
			id: KlpId.parse('screen'), accessibilityLabel: 'Workspace',
			child: child is KlpAppLayout ? child : KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: _groups(child))),
		);
		final values = primitives ?? KlpWorkspacePreset.light();
		runtime.update(root: screen, adapters: klpApplicationAdapters(), primitives: values);
		await tester.pumpWidget(WidgetsApp(color: const Color(0xff000000), builder: (_, _) => KlpFlutterRenderer(content: runtime.frame!.content)));
		await tester.pump();
		expect(tester.takeException(), isNull);
	}
}

final class _UnsupportedAction implements KlpAction {
	const _UnsupportedAction();
}

void main() {
	registerWorkspaceDialogChecks();
	testWidgets('workspace action rejects an unsupported action without a handler', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		await expectLater(
			harness.show(
				tester,
				KlpWorkspaceBlock(
					id: KlpId.parse('action'),
					kind: KlpWorkspaceBlockKind.action,
					title: 'Unsupported',
					action: const _UnsupportedAction(),
				),
			),
			throwsA(
				isA<KlpContractError>().having(
					(error) => error.code,
					'code',
					'unsupported_workspace_action',
				),
			),
		);
	});
	testWidgets('icon toolbar keeps one asset action and exposes its label without visible text', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		var opened = 0;
		await harness.show(tester, KlpWorkspaceBlock(id: KlpId.parse('toolbar'), kind: KlpWorkspaceBlockKind.toolbar, title: '', items: [KlpWorkspaceItem(title: 'Assets', icon: KlpWorkspaceIcon.image, selected: true, onPressed: () => opened++)]));
		expect(find.text('Assets'), findsNothing);
		final surface = find.byType(KlpFlutterSelectionSurface);
		expect(surface, findsOneWidget);
		expect(tester.getSize(surface), const Size(32, 32));
		expect(tester.widget<KlpFlutterSelectionSurface>(surface).selected, isTrue);
		await tester.tap(surface);
		await tester.pump();
		expect(opened, 1);
		final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
		await mouse.addPointer(location: const Offset(1, 1));
		await mouse.moveTo(tester.getCenter(surface));
		await tester.pump(const Duration(seconds: 1));
		expect(find.text('Assets'), findsOneWidget);
		await mouse.removePointer();
		await tester.pumpAndSettle();
	});

	testWidgets('window controls share hover and press fill without borders and optically reduce square icons', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		var toggles = 0;
		KlpWindowControls controls(bool maximized) => KlpWindowControls(id: KlpId.parse('controls'), isMaximized: maximized, onMinimize: () {}, onToggleMaximize: () => toggles++, onClose: () {});
		for (final primitives in [KlpWorkspacePreset.light(), KlpWorkspacePreset.dark()]) {
			await harness.show(tester, controls(false), primitives: primitives);
			final square = find.byWidgetPredicate((w) => w is KlpFlutterLucideIcon && w.name == 'square');
			final target = find.ancestor(of: square, matching: find.byType(KlpFlutterSelectionSurface)).first;
			expect(tester.widget<KlpFlutterLucideIcon>(square).size, 14);
			expect(tester.getSize(target), const Size(32, 32));
			Color? fill() => (tester.widget<DecoratedBox>(find.descendant(of: target, matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration).color;
			final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
			await mouse.addPointer(location: const Offset(1, 1));
			await mouse.moveTo(tester.getCenter(target));
			await tester.pump();
			final hover = fill();
			expect(hover, isNotNull);
			await mouse.down(tester.getCenter(target));
			await tester.pump();
			expect(fill(), hover);
			await mouse.up();
			await mouse.moveTo(const Offset(1, 1));
			await tester.pump();
			for (final box in tester.widgetList<DecoratedBox>(find.descendant(of: target, matching: find.byType(DecoratedBox)))) {
				expect((box.decoration as BoxDecoration).border, isNull);
			}
			await mouse.removePointer();
			await harness.show(tester, controls(true), primitives: primitives);
			final copy = tester.widget<KlpFlutterLucideIcon>(find.byWidgetPredicate((w) => w is KlpFlutterLucideIcon && w.name == 'copy'));
			expect(copy.size, 14);
		}
		expect(toggles, 2);
	});

	testWidgets('floating action drags without activation, clamps and keeps footer fixed', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		var taps = 0;
		KlpWorkspaceBlock action(String id) => KlpWorkspaceBlock(id: KlpId.parse(id), kind: KlpWorkspaceBlockKind.action, title: id, onPressed: () => taps++);
		KlpAppLayout layout() => KlpAppLayout(id: KlpId.parse('layout'), floatingAction: action('AI'), child: KlpAppFrame(id: KlpId.parse('frame'), child: KlpFrameGroups(id: KlpId.parse('groups'), groups: [for (var i = 0; i < 30; i++) KlpFrameGroup(id: KlpId.parse('group$i'), content: [action('row$i')])], footer: KlpFrameGroup(id: KlpId.parse('footer'), content: [action('Assets')]))));
		await harness.show(tester, layout());
		final footer = find.byWidgetPredicate((w) => w is KlpIdScope && w.id.value == 'footer');
		final rect = tester.getRect(footer);
		expect(rect.bottom, 588);
		expect(rect.center.dx, 400);
		final before = tester.getCenter(find.text('AI'));
		await tester.drag(find.text('AI'), const Offset(-180, -120));
		await tester.pump();
		expect(taps, 0);
		final moved = tester.getCenter(find.text('AI'));
		expect(moved.dx, lessThan(before.dx - 100));
		expect(moved.dy, lessThan(before.dy - 60));
		await harness.show(tester, layout());
		expect(tester.getCenter(find.text('AI')), moved);
		await tester.tap(find.text('AI'));
		await tester.pump();
		expect(taps, 1);
		await tester.drag(find.text('row0'), const Offset(0, -250));
		await tester.pumpAndSettle();
		expect(tester.getRect(footer), rect);
		await tester.drag(find.text('AI'), const Offset(-2000, -2000));
		await tester.pump();
		expect(tester.getTopLeft(find.text('AI')).dx, greaterThanOrEqualTo(12));
		expect(tester.getTopLeft(find.text('AI')).dy, greaterThanOrEqualTo(56));
		tester.view.physicalSize = const Size(480, 360);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		await tester.pump();
		await tester.drag(find.text('AI'), const Offset(2000, 2000));
		await tester.pump();
		expect(tester.getBottomRight(find.text('AI')).dx, lessThanOrEqualTo(468));
		expect(tester.getBottomRight(find.text('AI')).dy, lessThanOrEqualTo(348));
		expect(tester.takeException(), isNull);
	});

	testWidgets('compact categories have no persistent fill and document rows use button gaps', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final category = KlpId.parse('category');
		final children = [for (var i = 0; i < 2; i++) KlpExplorerNodeModel(id: KlpId.parse('file$i'), row: KlpExplorerRowData(title: 'File$i', icon: KlpExplorerGlyph.file), canHaveChildren: false)];
		final item = KlpExplorerCategoryModel(id: category, row: KlpExplorerRowData(title: 'Category'), children: children);
		await harness.show(tester, KlpExplorer(id: KlpId.parse('explorer'), data: explorerData([item])));
		final rows = find.byType(KlpFlutterSelectionSurface);
		expect(tester.getSize(rows.at(0)).height, 28);
		expect(tester.widget<Text>(find.text('Category')).style!.fontSize, 12);
		expect(tester.getRect(rows.at(2)).top - tester.getRect(rows.at(1)).bottom, 4);
		expect(tester.widgetList<KlpFlutterLucideIcon>(find.byType(KlpFlutterLucideIcon)).where((icon) => icon.name == 'file-text').map((icon) => icon.size), everyElement(20));

		// 普通分類保持透明；點擊產生的焦點填色由互動契約另行驗證。
		final boxes = tester.widgetList<DecoratedBox>(find.descendant(of: rows.first, matching: find.byType(DecoratedBox)));
		for (final box in boxes) {
			expect((box.decoration as BoxDecoration).color, isNull);
			expect((box.decoration as BoxDecoration).border, isNull);
		}
	});

	testWidgets('Explorer selection and click focus use the hover fill without borders', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final file = KlpId.parse('file');
		KlpExplorer tree(bool selected) => KlpExplorer(id: KlpId.parse('explorer'), data: explorerData([KlpExplorerNodeModel(id: file, row: KlpExplorerRowData(title: 'Document'), canHaveChildren: false, capabilities: const KlpExplorerCapabilities(selectable: true))], selected: selected ? {file} : {}), onIntent: (_) {});
		await harness.show(tester, tree(false));
		final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
		await mouse.addPointer(location: const Offset(1, 1));
		await mouse.moveTo(tester.getCenter(find.text('Document')));
		await tester.pump();
		Color? fill() => (tester.widget<DecoratedBox>(find.descendant(of: find.byType(KlpFlutterSelectionSurface), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration).color;
		final hover = fill();
		expect(hover, isNotNull);
		await tester.tap(find.text('Document'));
		await harness.show(tester, tree(true));
		await mouse.moveTo(const Offset(1, 1));
		await tester.pump();
		expect(fill(), hover);
		for (final box in tester.widgetList<DecoratedBox>(find.descendant(of: find.byType(KlpFlutterSelectionSurface), matching: find.byType(DecoratedBox)))) {
			if (box.decoration is BoxDecoration) expect((box.decoration as BoxDecoration).border, isNull);
		}
		await mouse.removePointer();
	});

	testWidgets('category toggles without selection and keeps icon badge children controlled', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final category = KlpId.parse('category');
		final file = KlpId.parse('file');
		final toggles = <(KlpId, bool)>[];
		final selections = <KlpId>[];
		final child = KlpExplorerNodeModel(id: file, row: KlpExplorerRowData(title: 'Photo', icon: KlpExplorerGlyph.image, badge: '3'), canHaveChildren: false, capabilities: const KlpExplorerCapabilities(selectable: true));
		final parent = KlpExplorerCategoryModel(id: category, row: KlpExplorerRowData(title: 'Documents'), capabilities: const KlpExplorerCapabilities(collapsible: true, primaryAction: KlpExplorerPrimaryAction.toggleExpansion), children: [child]);
		KlpExplorer tree(bool open) => KlpExplorer(id: KlpId.parse('explorer'), data: explorerData([parent], expanded: open ? {category} : {}), onIntent: (intent) {
			if (intent case KlpExplorerSelectionRequested(:final selectedIds)) selections.addAll(selectedIds);
			if (intent case KlpExplorerExpansionRequested(:final itemId, :final expanded)) toggles.add((itemId, expanded));
		});
		await harness.show(tester, tree(false));
		expect(find.text('Photo'), findsNothing);
		await tester.tap(find.text('Documents'));
		expect(toggles, [(category, true)]);
		expect(selections, isEmpty);
		expect(find.text('Photo'), findsNothing);
		await harness.show(tester, tree(true));
		expect(find.text('3'), findsOneWidget);
		expect(tester.widgetList<KlpFlutterLucideIcon>(find.byType(KlpFlutterLucideIcon)).map((icon) => icon.name), contains('image'));
		await tester.tap(find.text('Photo'));
		expect(selections, [file]);
		expect(tester.getSize(find.byType(KlpFlutterSelectionSurface).first).height, 28);
	});

	testWidgets('noncollapsible nodes keep descendants visible and preserve tree indentation', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final folder = KlpId.parse('folder');
		final file = KlpId.parse('file');
		final selections = <KlpId>[];
		final child = KlpExplorerNodeModel(id: file, row: KlpExplorerRowData(title: 'File'), canHaveChildren: false, capabilities: const KlpExplorerCapabilities(selectable: true));
		final parent = KlpExplorerNodeModel(id: folder, row: KlpExplorerRowData(title: 'Folder'), canHaveChildren: true, children: [child]);
		await harness.show(tester, KlpExplorer(id: KlpId.parse('explorer'), data: explorerData([parent]), onIntent: (intent) {
			if (intent case KlpExplorerSelectionRequested(:final selectedIds)) selections.addAll(selectedIds);
		}));
		expect(find.text('File'), findsOneWidget);
		expect(find.bySemanticsLabel('Expand Folder'), findsNothing);
		expect(tester.getTopLeft(find.text('File')).dx, greaterThan(tester.getTopLeft(find.text('Folder')).dx));
		await tester.tap(find.text('File'));
		expect(selections, [file]);
	});

	testWidgets('hover and selected share only the background and preserve text style', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		KlpWorkspaceBlock item(bool selected) => KlpWorkspaceBlock(id: KlpId.parse('action'), kind: KlpWorkspaceBlockKind.action, title: 'Planist AI', selected: selected, onPressed: () {});
		await harness.show(tester, item(false));
		final label = find.text('Planist AI');
		final normalStyle = tester.widget<Text>(label).style;
		Color? background() => (tester.widget<DecoratedBox>(find.descendant(of: find.byType(KlpFlutterSelectionSurface), matching: find.byType(DecoratedBox)).first).decoration as BoxDecoration).color;
		expect(background(), isNull);
		final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
		await mouse.addPointer(location: const Offset(1, 1));
		await mouse.moveTo(tester.getCenter(label));
		await tester.pump();
		final hoverColor = background();
		expect(hoverColor, isNotNull);
		expect(tester.widget<Text>(label).style, normalStyle);
		await mouse.moveTo(const Offset(1, 1));
		await tester.pump();
		expect(background(), isNull);
		await harness.show(tester, item(true));
		expect(background(), hoverColor);
		expect(tester.widget<Text>(label).style, normalStyle);
		expect(normalStyle!.fontWeight, FontWeight.w400);
		await mouse.moveTo(tester.getCenter(label));
		await tester.pump();
		await mouse.moveTo(const Offset(1, 1));
		await tester.pump();
		expect(background(), hoverColor);
		await mouse.removePointer();
	});

	testWidgets('empty identity keeps utility actions in a navigation-height header', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		var actions = 0;
		await harness.show(tester, KlpWorkspaceBlock(id: KlpId.parse('identity'), kind: KlpWorkspaceBlockKind.identity, title: '', secondaryActionLabel: 'Search', onSecondaryAction: () => actions++, tertiaryActionLabel: 'Appearance', onTertiaryAction: () => actions++));
		expect(tester.getSize(find.byType(KlpFlutterWorkspaceBlock)).height, 32);
		expect(find.text('Planist'), findsNothing);
		expect(find.text('p.'), findsNothing);
		await tester.tap(find.bySemanticsLabel('Search'));
		await tester.tap(find.bySemanticsLabel('Appearance'));
		expect(actions, 2);
	});

	testWidgets('collapsed explorer descendants still participate in tree validation', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final duplicate = KlpId.parse('duplicate');
		final hidden = KlpExplorerNodeModel(id: duplicate, row: KlpExplorerRowData(title: 'Hidden'), canHaveChildren: false);
		final parent = KlpExplorerNodeModel(id: KlpId.parse('folder'), row: KlpExplorerRowData(title: 'Folder'), canHaveChildren: true, capabilities: const KlpExplorerCapabilities(collapsible: true), children: [hidden]);
		final visible = KlpExplorerNodeModel(id: duplicate, row: KlpExplorerRowData(title: 'Visible'), canHaveChildren: false);
		expect(
			() => KlpExplorer(id: KlpId.parse('explorer'), data: explorerData([parent, visible])),
			throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'explorer_duplicate_id')),
		);
	});

	testWidgets('explorer expansion and selection remain consumer controlled', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final folder = KlpId.parse('folder');
		final file = KlpId.parse('file');
		final selected = <KlpId>[];
		final expansionEvents = <(KlpId, bool)>[];
		final child = KlpExplorerNodeModel(id: file, row: KlpExplorerRowData(title: 'Readme'), canHaveChildren: false, capabilities: const KlpExplorerCapabilities(selectable: true));
		final parent = KlpExplorerNodeModel(id: folder, row: KlpExplorerRowData(title: 'Folder'), canHaveChildren: true, capabilities: const KlpExplorerCapabilities(collapsible: true), children: [child]);
		KlpExplorer tree(Set<KlpId> open) => KlpExplorer(id: KlpId.parse('explorer'), data: explorerData([parent], expanded: open), onIntent: (intent) {
			if (intent case KlpExplorerSelectionRequested(:final selectedIds)) selected.addAll(selectedIds);
			if (intent case KlpExplorerExpansionRequested(:final itemId, :final expanded)) expansionEvents.add((itemId, expanded));
		});
		await harness.show(tester, tree({}));
		expect(find.text('Readme'), findsNothing);
		await tester.tap(find.bySemanticsLabel('Expand Folder'));
		await tester.pump();
		expect(expansionEvents, [(folder, true)]);
		expect(find.text('Readme'), findsNothing);
		await harness.show(tester, tree({folder}));
		await tester.tap(find.text('Readme'));
		expect(selected, [file]);
		await tester.tap(find.bySemanticsLabel('Collapse Folder'));
		expect(expansionEvents.last, (folder, false));
	});

	testWidgets('document close requests preserve dirty data until consumer rebuilds', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final first = KlpId.parse('first');
		final second = KlpId.parse('second');
		final selected = <KlpId>[];
		final closed = <KlpId>[];
		KlpDocumentTabs tabs({bool includeFirst = true}) => KlpDocumentTabs(
			id: KlpId.parse('tabs'),
			data: KlpDocumentTabsData(
				selectedId: second,
				tabs: [
					if (includeFirst) KlpDocumentTabData(id: first, label: 'Draft', dirty: true),
					KlpDocumentTabData(id: second, label: 'Reference', closable: false),
				],
			),
			onIntent: (intent) {
				if (intent case KlpDocumentTabSelectionRequested(:final tabId)) selected.add(tabId);
				if (intent case KlpDocumentTabCloseRequested(:final tabId)) closed.add(tabId);
			},
		);
		await harness.show(tester, tabs());
		expect(find.bySemanticsLabel(RegExp('Draft.*Modified')), findsOneWidget);
		await tester.tap(find.text('Reference'));
		expect(selected, [second]);
		await tester.tap(find.bySemanticsLabel('Close Draft'));
		await tester.pump();
		expect(closed, [first]);
		expect(find.text('Draft'), findsOneWidget);
		expect(find.bySemanticsLabel('Close Reference'), findsNothing);
		await harness.show(tester, tabs(includeFirst: false));
		expect(find.text('Draft'), findsNothing);
	});

	testWidgets('window controls dispatch host actions and reflect maximized input', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final calls = <String>[];
		KlpWindowControls controls(bool maximized) => KlpWindowControls(
			id: KlpId.parse('window'), isMaximized: maximized,
			onMinimize: () => calls.add('minimize'), onToggleMaximize: () => calls.add('toggle'), onClose: () => calls.add('close'),
		);
		await harness.show(tester, controls(false));
		expect(tester.getSize(find.bySemanticsLabel('Minimize window')).height, 32);
		await tester.tap(find.bySemanticsLabel('Minimize window'));
		await tester.tap(find.bySemanticsLabel('Maximize window'));
		await tester.tap(find.bySemanticsLabel('Close window'));
		expect(calls, ['minimize', 'toggle', 'close']);
		await harness.show(tester, controls(true));
		expect(find.bySemanticsLabel('Maximize window'), findsNothing);
		await tester.tap(find.bySemanticsLabel('Restore window'));
		expect(calls.last, 'toggle');
	});

	testWidgets('new workspace components inherit replacement primitives', (tester) async {
		final harness = _Harness();
		addTearDown(harness.runtime.dispose);
		final id = KlpId.parse('item');
		final child = KlpDocumentTabs(
			id: KlpId.parse('tabs'),
			data: KlpDocumentTabsData(tabs: [KlpDocumentTabData(id: id, label: 'Styled')], selectedId: id),
			onIntent: (_) {},
		);
		await harness.show(tester, child, primitives: KlpWorkspacePreset.light());
		final light = tester.widget<Text>(find.text('Styled')).style!.color;
		final lightSurface = tester.widget<ColoredBox>(find.ancestor(of: find.text('Styled'), matching: find.byType(ColoredBox)).first).color;
		expect(lightSurface, const Color(0xfff8f6f1), reason: '分頁內容應維持 v1 主內容表面，不覆蓋為 app 底色。');
		await harness.show(tester, child, primitives: KlpWorkspacePreset.dark());
		final dark = tester.widget<Text>(find.text('Styled')).style!.color;
		final darkSurface = tester.widget<ColoredBox>(find.ancestor(of: find.text('Styled'), matching: find.byType(ColoredBox)).first).color;
		expect(darkSurface, const Color(0xff35322d));
		expect(light, isNotNull);
		expect(dark, isNot(light), reason: '文字不得固定在舊 theme 或 renderer 局部色彩。');
	});

	testWidgets('workspace actions remain keyboard accessible', (tester) async {
		var calls = 0;
		final node = KlpWindowControls(id: KlpId.parse('window'), isMaximized: false, onMinimize: () => calls++, onToggleMaximize: () {}, onClose: () {});
		final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Workspace', child: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: _groups(node))));
		final destination = KlpDestination<int, String>(KlpId.parse('home'));
		final source = KlpMutableState(KlpApplication(
			title: 'Keyboard workspace',
			router: KlpRouter(id: KlpId.parse('router'), initial: destination.location(0), routes: [KlpRoute(destination, screen: (_) => screen)]),
		));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		await tester.sendKeyEvent(LogicalKeyboardKey.tab);
		await tester.pump();
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.pump();
		expect(calls, 1);
	});
}

KlpFrameGroups _groups(KlpNode child) => KlpFrameGroups(
	id: KlpId.parse('frame.groups'),
	groups: [KlpFrameGroup(id: KlpId.parse('frame.group'), content: [child])],
);
