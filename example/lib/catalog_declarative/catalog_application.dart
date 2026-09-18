import 'package:kallopis/kallopis_declarative.dart';
import '../workspace_demo/sample_content.dart';

/// Catalog 組合根；沿用已確認工作區，深色使用 CATALOG_DARK。
void runCatalog({KlpScreenBody? stage}) {
	const dark = bool.fromEnvironment('CATALOG_DARK', defaultValue: bool.fromEnvironment('WORKSPACE_DARK'));
	final destination = KlpDestination<Object?, Object?>(KlpId.parse('workspace.demo'));
	final source = KlpMutableState(KlpApplication(
		title: 'Kallopis Catalog — declarative',
		primitives: dark ? KlpWorkspacePreset.dark() : KlpWorkspacePreset.light(),
		router: KlpRouter(id: KlpId.parse('workspace.router'), initial: destination.location(null), routes: [
			KlpRoute<Object?, Object?>(destination, screen: (_) => KlpScreen(
				id: KlpId.parse('workspace.screen'), accessibilityLabel: '工作區布局樣板',
				child: stage ?? sampleContent(KlpId.parse('stage'), 'Kallopis Catalog\n\nConsumer 只組裝庫擁有元件。\n全宣告式組裝，零 Flutter 原生元件。'),
			)),
		]),
	));
	runKlpApp(source.readOnly);
}
