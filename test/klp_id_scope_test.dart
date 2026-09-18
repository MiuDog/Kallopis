import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
	group('KlpIdScope', () {
		test('宣告期巢狀 Scope 會合成完整路徑並在離開後還原', () {
			final root = KlpId.root('scope_declaration');
			expect(KlpId.current, isNull);
			expect(KlpId.leaf('standalone'), same(KlpId.root('standalone')));

			KlpIdScope.run(root, () {
				expect(KlpId.current, same(root));
				final workspace = KlpId.leaf('workspace');
				expect(workspace.value, 'scope_declaration.workspace');

				KlpIdScope.run(workspace, () {
					expect(KlpId.current, same(workspace));
					expect(KlpId.leaf('stage').value, 'scope_declaration.workspace.stage');
				});
				expect(KlpId.current, same(root));
			});

			expect(KlpId.current, isNull);
		});

		testWidgets('渲染期 Scope 可由 context 讀取並衍生子節點', (tester) async {
			final root = KlpId.root('scope_widget');
			KlpId? read;
			KlpId? child;
			await tester.pumpWidget(
				Directionality(
					textDirection: TextDirection.ltr,
					child: KlpIdScope(
						id: root,
						child: Builder(
							builder: (context) {
								read = context.klpId;
								child = KlpIdScope.childOf(context, 'child');
								return const SizedBox();
							},
						),
					),
				),
			);

			expect(read, same(root));
			expect(child, same(KlpId.leaf('scope_widget').child('child')));
		});

		test('宣告期與渲染期衍生節點共用享元實例', () {
			final root = KlpId.root('scope_flyweight');
			final fromChild = root.child('leaf');
			final fromScope = KlpIdScope.run(root, () => KlpId.leaf('leaf'));

			expect(fromScope, same(fromChild));
		});
	});
}
