import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('Klp background editor snaps and connects points', (tester) async {
		var recipe = KlpCustomPageBackgroundRecipe(snapSpacing: 10);

		await tester.pumpWidget(
			_EditorHarness(
				recipe: recipe,
				tool: KlpPageBackgroundEditorTool.connect,
				onChanged: (value) => recipe = value,
			),
		);

		final editor = find.byType(KlpPageBackgroundEditor);
		final topLeft = tester.getTopLeft(editor);
		await tester.tapAt(topLeft + const Offset(13, 17));
		await tester.pump();
		expect(recipe.points.single.position, const Offset(10, 20));

		await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
		await tester.tapAt(topLeft + const Offset(26, 24));
		await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
		await tester.pump();
		expect(recipe.points.last.position, const Offset(26, 24));
		expect(recipe.lines, hasLength(1));
	});

	testWidgets('Klp background editor deletes a point and connected lines', (tester) async {
		var recipe = KlpCustomPageBackgroundRecipe(
			points: const [
				KlpPageBackgroundPoint(id: 1, position: Offset(20, 20)),
				KlpPageBackgroundPoint(id: 2, position: Offset(80, 20)),
			],
			lines: const [
				KlpPageBackgroundLine(id: 1, startPointId: 1, endPointId: 2),
			],
		);

		await tester.pumpWidget(
			_EditorHarness(
				recipe: recipe,
				tool: KlpPageBackgroundEditorTool.delete,
				onChanged: (value) => recipe = value,
			),
		);
		await tester.tapAt(tester.getTopLeft(find.byType(KlpPageBackgroundEditor)) + const Offset(20, 20));
		await tester.pump();

		expect(recipe.points.map((point) => point.id), [2]);
		expect(recipe.lines, isEmpty);
	});
}

class _EditorHarness extends StatefulWidget {
	const _EditorHarness({required this.recipe, required this.tool, required this.onChanged});

	final KlpCustomPageBackgroundRecipe recipe;
	final KlpPageBackgroundEditorTool tool;
	final ValueChanged<KlpCustomPageBackgroundRecipe> onChanged;

	@override
	State<_EditorHarness> createState() => _EditorHarnessState();
}

class _EditorHarnessState extends State<_EditorHarness> {
	late KlpCustomPageBackgroundRecipe recipe = widget.recipe;

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			themeAnimationDuration: Duration.zero,
			theme: buildKlpTheme(Brightness.light),
			home: Align(
				alignment: Alignment.topLeft,
				child: SizedBox(
					width: 200,
					height: 160,
					child: KlpPageBackgroundEditor(
						recipe: recipe,
						tool: widget.tool,
						onChanged: (value) {
							setState(() => recipe = value);
							widget.onChanged(value);
						},
					),
				),
			),
		);
	}
}
