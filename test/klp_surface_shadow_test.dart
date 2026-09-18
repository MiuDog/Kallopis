import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolver.dart';
import 'package:kallopis/src/foundation/templates/klp_template.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';

import 'support/klp_component_test_item.dart';
import 'support/klp_renderer_fixture.dart';
import 'support/klp_test_primitives.dart';

void main() {
	test('paper shadow resolves only explicit semantics into immutable snapshots', () {
		final semantics = _shadow();
		final first = klpTestPrimitives();
		final second = klpTestPrimitives(alternate: true);
		final oldSurface = _surface(semantics, first);
		final newSurface = _surface(semantics, second);
		expect(oldSurface.shadow!.color, same(first.colors[1]));
		expect(oldSurface.shadow!.scale, same(first.distances[1]));
		expect(newSurface.shadow!.color, same(second.colors[1]));
		expect(newSurface.shadow!.scale, same(second.distances[1]));
		final flat = _surface(null, first);
		expect(flat.shadow, isNull);
	});

	test('shadow references enforce actual kind and owner permissions', () {
		final shared = KlpSemanticKey('shared', 'color', KlpStyleKind.color);
		final sharedDefinition = KlpDefinition<KlpComponentTestItem>('shared', semantics: KlpSemanticSchema('shared', [KlpSemanticToken(shared, KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1), isPublic: true)]));
		for (final (key, code) in [
			(KlpSemanticKey('fixture', 'radius', KlpStyleKind.color), 'semantic_kind_mismatch'),
			(shared, 'undeclared_semantic_dependency'),
		]) {
			expect(() => _validate(_shadow(color: key), shared: sharedDefinition.semantics), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code)));
		}
		final wrongScale = KlpSurfaceShadowSemantics(color: KlpSemanticKey('fixture', 'color', KlpStyleKind.color), scale: KlpSemanticKey('fixture', 'radius', KlpStyleKind.distance));
		expect(() => _validate(wrongScale), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'semantic_kind_mismatch')));
	});

	testWidgets('paper shadows paint outside clip and preserve surface layout', (tester) async {
		KlpBoundSurface surface(KlpBoundSurfaceShadow? shadow) => KlpBoundSurface(background: KlpColor(250, 247, 240), radius: KlpRadius(12), inset: KlpDistance(16), shadow: shadow, child: klpRendererText('Paper'));
		await tester.pumpWidget(klpRendererHost(surface(null)));
		final flatSize = tester.getSize(find.byType(ClipRRect));
		for (final scale in [12.0, 24.0]) {
			await tester.pumpWidget(klpRendererHost(surface(KlpBoundSurfaceShadow(color: KlpColor(0, 0, 0, alpha: 34), scale: KlpDistance(scale)))));
			final finder = find.byWidgetPredicate((widget) => widget is DecoratedBox && (widget.decoration as BoxDecoration).boxShadow != null);
			final outer = tester.widget<DecoratedBox>(finder);
			final shadows = (outer.decoration as BoxDecoration).boxShadow!;
			expect(shadows.length, 2);
			expect(shadows.map((shadow) => shadow.offset.dy), [2 * scale / 12, 8 * scale / 12]);
			expect(shadows.map((shadow) => shadow.blurRadius), [3 * scale / 12, 20 * scale / 12]);
			expect(shadows.every((shadow) => shadow.color == const Color(0x22000000) && shadow.spreadRadius == 0 && shadow.offset.dx == 0), isTrue);
			expect(outer.child, isA<ClipRRect>());
			expect(find.ancestor(of: finder, matching: find.byType(ClipRRect)), findsNothing);
			expect(tester.getSize(find.byType(ClipRRect)), flatSize);
		}
		await tester.pumpWidget(klpRendererHost(surface(null)));
		expect(find.byWidgetPredicate((widget) => widget is DecoratedBox && (widget.decoration as BoxDecoration).boxShadow != null), findsNothing);
	});
}

KlpSurfaceShadowSemantics _shadow({KlpSemanticKey<KlpColor>? color}) => KlpSurfaceShadowSemantics(color: color ?? KlpSemanticKey('fixture', 'color', KlpStyleKind.color), scale: KlpSemanticKey('fixture', 'distance', KlpStyleKind.distance));

KlpSemanticSchema _schema() => KlpSemanticSchema('fixture', [
	KlpSemanticToken(KlpSemanticKey('fixture', 'color', KlpStyleKind.color), const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1)),
	KlpSemanticToken(KlpSemanticKey('fixture', 'distance', KlpStyleKind.distance), const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1)),
	KlpSemanticToken(KlpSemanticKey('fixture', 'radius', KlpStyleKind.radius), const KlpPrimitiveRef(KlpStyleKind.radius, KlpPrimitiveIndex.i1)),
]);

KlpSemanticResolver _validate(KlpSurfaceShadowSemantics shadow, {KlpSemanticSchema? shared}) {
	final resolver = KlpSemanticResolver([_schema(), ?shared]);
	resolver.validateUsage('fixture', shadow.color);
	resolver.validateUsage('fixture', shadow.scale);
	return resolver;
}

KlpBoundSurface _surface(KlpSurfaceShadowSemantics? shadow, KlpPrimitiveSet primitives) {
	KlpBoundSurfaceShadow? resolved;
	if (shadow != null) {
		final style = _validate(shadow).resolve(primitives);
		resolved = KlpBoundSurfaceShadow(color: style.read(shadow.color), scale: style.read(shadow.scale));
	}
	return KlpBoundSurface(background: primitives.colors[1], radius: primitives.radii[1], inset: primitives.distances[1], child: KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), []), shadow: resolved);
}
