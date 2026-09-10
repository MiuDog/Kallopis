import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('avatar size 由 typed token 尺寸解析', (tester) async {
		await tester.pumpWidget(
			const KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpColumn(
						mainAxisSize: MainAxisSize.min,
						children: [
							KlpAvatar(
								key: ValueKey('standard-avatar'),
								label: 'S',
							),
							KlpAvatar(
								key: ValueKey('small-avatar'),
								label: 'M',
								size: KlpAvatarSize.small,
								tone: KlpAvatarTone.emphasized,
							),
						],
					),
				),
			),
		);

		final standard = find.byKey(const ValueKey('standard-avatar'));
		final small = find.byKey(const ValueKey('small-avatar'));
		final tokens = tester.element(standard).klp.space;

		expect(
			tester.getSize(standard),
			Size.square(tokens.controlHeightLarge),
		);
		expect(tester.getSize(small), Size.square(tokens.avatarSmall));
		expect(
			tester.widget<KlpAvatar>(small).tone,
			KlpAvatarTone.emphasized,
		);
	});

	testWidgets('avatar group 保留最大顯示數並呈現剩餘數量', (tester) async {
		await tester.pumpWidget(
			const KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAvatarGroup(
						maximumVisible: 2,
						avatars: [
							KlpAvatarData(id: 'a', label: 'A'),
							KlpAvatarData(id: 'b', label: 'B'),
							KlpAvatarData(id: 'c', label: 'C'),
						],
					),
				),
			),
		);

		expect(find.byType(KlpAvatar), findsNWidgets(3));
		expect(find.text('A'), findsOneWidget);
		expect(find.text('B'), findsOneWidget);
		expect(find.text('+1'), findsOneWidget);
		expect(find.text('C'), findsNothing);
	});
}
