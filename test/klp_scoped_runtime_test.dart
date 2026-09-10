import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/nodes/internal/klp_scope_boundary.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_tree_runtime.dart';

import 'support/klp_runtime_fixture.dart';
import 'support/klp_test_primitives.dart';

void main() {
	test('one transaction retains independent scoped resources and removes one entry', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final adapter = KlpRuntimeFixture();
		KlpScopeBoundary entry(String id) => KlpScopeBoundary(id: id, child: KlpRuntimeNode('same'));
		void update(List<String> entries) => runtime.update(root: KlpRuntimeNode('root', entries.map(entry).toList()), adapters: [adapter, const KlpScopeBoundaryAdapter()], components: const [], primitives: klpTestPrimitives());
		update(['first', 'second']);
		final firstId = KlpPlacementId(scope: ['first'], localId: 'same');
		final secondId = KlpPlacementId(scope: ['second'], localId: 'same');
		final first = runtime.resources[firstId] as KlpRuntimeResource;
		final second = runtime.resources[secondId] as KlpRuntimeResource;
		expect(first, isNot(same(second)));
		update(['second', 'first']);
		expect(runtime.resources[firstId], same(first));
		expect(runtime.resources[secondId], same(second));
		update(['second']);
		expect(first.disposed, isTrue);
		expect(second.disposed, isFalse);
		expect(runtime.resources[secondId], same(second));
		expect(runtime.resources.containsKey(firstId), isFalse);
	});

	test('invalid scoped descendant preserves every previously committed entry', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final adapter = KlpRuntimeFixture();
		void update(KlpNode child) => runtime.update(root: KlpRuntimeNode('root', [KlpScopeBoundary(id: 'entry', child: child)]), adapters: [adapter, const KlpScopeBoundaryAdapter()], components: const [], primitives: klpTestPrimitives());
		update(KlpRuntimeNode('same'));
		final previous = runtime.frame;
		final resource = runtime.resources[KlpPlacementId(scope: ['entry'], localId: 'same')];
		adapter.failPrepare = 'broken';
		expect(() => update(KlpRuntimeNode('same', [KlpRuntimeNode('broken')])), throwsStateError);
		expect(runtime.frame, same(previous));
		expect(runtime.resources[KlpPlacementId(scope: ['entry'], localId: 'same')], same(resource));
		expect((resource as KlpRuntimeResource).disposed, isFalse);
	});
}
