import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('renders workspace identity with Klp-owned chrome', (tester) async {
		await tester.pumpWidget(
			const KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpSidebarIdentityHeader(
							icon: KlpIcons.folder,
							title: 'Flows',
							trailing: KlpAvatar(
								label: 'C',
								semanticLabel: 'Chia-Yu',
							),
						),
					),
				),
			),
		);

		expect(find.text('Flows'), findsOneWidget);
		expect(find.byType(KlpIcon), findsOneWidget);
		expect(find.byType(KlpAvatar), findsOneWidget);
		expect(find.bySemanticsLabel(RegExp('Chia-Yu')), findsOneWidget);
		expect(find.byType(KlpLayoutBuilder), findsOneWidget);
		expect(find.byType(KlpRow), findsOneWidget);

		final icon = find.byType(KlpIcon);
		final context = tester.element(icon);
		expect(tester.widget<KlpIcon>(icon).size, context.klp.space.iconGlyph);
	});

	testWidgets('narrow identity keeps only its icon', (tester) async {
		await tester.pumpWidget(
			const KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpAlign(
							alignment: Alignment.topLeft,
							child: KlpBox(
								widthSize: KlpSpaceSize.navigationRailControl,
								child: KlpSidebarIdentityHeader(
									icon: KlpIcons.folder,
									title: 'Flows',
									avatarLabel: 'C',
								),
							),
						),
					),
				),
			),
		);

		expect(find.byType(KlpIcon), findsOneWidget);
		expect(find.text('Flows'), findsNothing);
		expect(find.byType(KlpAvatar), findsNothing);
	});
}
