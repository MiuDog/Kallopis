import 'dart:async';

// 平台套件由正式 file_selector 相依提供，只用於測試平台替身。
// ignore: depend_on_referenced_packages
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_workspace_block.dart';

import 'klp_test_primitives.dart';

/// 只替換平台邊界；真實宿主、action 派送、adapter 與 lease 仍由產品組裝。
final class KlpFileSelectorProbe extends FileSelectorPlatform {

	final requests = <List<XTypeGroup>>[];
	final pending = <Completer<XFile?>>[];

	@override
	Future<XFile?> openFile({List<XTypeGroup>? acceptedTypeGroups, String? initialDirectory, String? confirmButtonText}) {
		requests.add(List.of(acceptedTypeGroups ?? const []));
		final result = Completer<XFile?>();
		pending.add(result);
		return result.future;
	}

	void select(int index, String path) => pending[index].complete(XFile(path));
	void cancel(int index) => pending[index].complete(null);
	void fail(int index, Object error, StackTrace stack) => pending[index].completeError(error, stack);
}

final klpFileHome = KlpDestination<int, String>(KlpId.parse('files.home'));
final klpFileDetail = KlpDestination<int, String>(KlpId.parse('files.detail'));

KlpScreen klpFileScreen(KlpAction action, {KlpAction? next}) {
	final blocks = [
		KlpWorkspaceBlock(id: KlpId.parse('pick'), kind: KlpWorkspaceBlockKind.action, title: 'Pick', action: action),
		if (next != null) KlpWorkspaceBlock(id: KlpId.parse('next'), kind: KlpWorkspaceBlockKind.action, title: 'Next', action: next),
	];
	final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: [KlpFrameGroup(id: KlpId.parse('group'), content: blocks)]);
	return KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Files', child: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: groups)));
}

KlpApplication klpFileApplication(KlpAction action, {bool alternate = false, KlpAction? secondAction}) {
	final routes = <KlpRoute<Object?, Object?>>[
		KlpRoute<int, String>(klpFileHome, screen: (input) => klpFileScreen(action, next: secondAction ?? input.navigate(klpFileDetail.location(1)))),
		KlpRoute<int, String>(klpFileDetail, screen: (input) => klpFileScreen(action, next: input.finish('done'))),
	];
	return KlpApplication(title: 'File selection', primitives: klpTestPrimitives(alternate: alternate), router: KlpRouter(id: KlpId.parse('files.router'), initial: klpFileHome.location(0), routes: routes));
}

void Function() klpFileActivation(WidgetTester tester, {String title = 'Pick'}) {
	// 讀取實際呈現 callback，讓測試能保留舊畫面的 activation 並觀察 lease 撤銷。
	return tester.widgetList<KlpFlutterWorkspaceBlock>(find.byType(KlpFlutterWorkspaceBlock)).singleWhere((widget) => widget.content.title == title).content.onPressed!;
}

Future<void> klpMountFiles(WidgetTester tester, KlpMutableState<KlpApplication> source) async {
	// 公開 bootstrap 是唯一宿主安裝入口。
	runKlpApp(source.readOnly);
	await tester.pump();
	await tester.pump();
	expect(tester.takeException(), isNull);
}

Future<void> klpUnmountFiles(WidgetTester tester) async {
	await tester.pumpWidget(const SizedBox.shrink());
	expect(tester.takeException(), isNull);
}
