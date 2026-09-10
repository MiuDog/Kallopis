import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/capabilities/state/klp_mutable_state.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/templates/klp_axis.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

import 'support/klp_renderer_fixture.dart';

void main() {
	testWidgets('completed placement identity preserves nested focus during sibling reorder', (tester) async {
		final selection = KlpMutableState<KlpPlacementId?>(null);
		addTearDown(selection.dispose);
		KlpBoundPlacement placement(String id) => KlpBoundPlacement(KlpPlacementId(localId: id), KlpBoundSurface(
			background: KlpColor(0, 0, 0),
			radius: KlpRadius(0),
			inset: KlpDistance(0),
			child: klpRendererChoice(id: KlpPlacementId(localId: id), selection: selection.readOnly, onActivate: () => selection.value = KlpPlacementId(localId: id)),
		));
		final first = placement('first');
		final second = placement('second');
		await tester.pumpWidget(klpRendererHost(KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), [first, second])));
		final selected = find.byWidgetPredicate((widget) => widget is KlpFlutterChoice && widget.content.id == KlpPlacementId(localId: 'first'));
		await tester.tap(selected);
		await tester.pump();
		final element = tester.element(selected);
		final focus = FocusManager.instance.primaryFocus;
		await tester.pumpWidget(klpRendererHost(KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), [second, first])));
		expect(tester.element(selected), same(element));
		expect(FocusManager.instance.primaryFocus, same(focus));
		expect(selection.value, KlpPlacementId(localId: 'first'));
		expect(tester.takeException(), isNull);
	});
}
