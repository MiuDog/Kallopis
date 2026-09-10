import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('split layout 依 typed pane 尺寸組成三欄並呈現分隔線', (tester) async {
		final base = KlpVisualStyle.defaultStyle;
		final style = base.copyWith(
			geometry: base.geometry.copyWith(
				layout: base.geometry.layout.copyWith(
					primaryPaneWidth: 180,
					secondaryPaneWidth: 220,
				),
			),
		);

		await tester.pumpWidget(
			KlpApp(
				style: style,
				showWindowHeader: false,
				home: const KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpBox(
							height: 120,
							child: KlpSplitLayout(
								leadingSize: KlpSplitPaneSize.primary,
								trailingSize: KlpSplitPaneSize.secondary,
								showDashedDivider: true,
								leading: KlpBox.expand(key: Key('leading')),
								center: KlpBox.expand(key: Key('center')),
								trailing: KlpBox.expand(key: Key('trailing')),
							),
						),
					),
				),
			),
		);

		expect(
			tester.getSize(find.byKey(const Key('leading'))).width,
			180,
		);
		expect(
			tester.getSize(find.byKey(const Key('trailing'))).width,
			220,
		);
		expect(find.byType(KlpDashedDivider), findsNWidgets(2));
	});
}
