import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/runtime/contracts/klp_installation_exception.dart';

import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'support/klp_runtime_fixture.dart';
import 'support/klp_test_primitives.dart';

void main() {
	late KlpTreeRuntime runtime;
	late KlpRuntimeFixture adapter;
	setUp(() {
		runtime = KlpTreeRuntime();
		adapter = KlpRuntimeFixture();
	});
	tearDown(() => runtime.dispose());
	void update(KlpRuntimeNode root) => runtime.update(
		root: root,
		adapters: [adapter],
		primitives: klpTestPrimitives(),
	);

	test('captures getters once and prepares entire tree before resources', () {
		final child = KlpRuntimeNode('child');
		final root = KlpRuntimeNode('root', [child]);
		update(root);
		for (final node in [root, child]) {
			expect([node.idReads, node.definitionReads, node.childReads], [1, 1, 1]);
		}
		expect(adapter.events, [
			'prepare:root',
			'prepare:child',
			'create:root',
			'create:child',
			'materialize:child',
			'materialize:root',
		]);
	});

	test('invalid preparation leaves old resources frame and lease usable', () {
		update(KlpRuntimeNode('root'));
		final frame = runtime.frame!;
		final resource = runtime.resources[KlpPlacementId(localId: 'root')];
		adapter.events.clear();
		adapter.failPrepare = 'child';
		expect(
			() => update(KlpRuntimeNode('root', [KlpRuntimeNode('child')])),
			throwsStateError,
		);
		expect(runtime.frame, same(frame));
		expect(runtime.resources[KlpPlacementId(localId: 'root')], same(resource));
		expect(frame.lease.isActive, isTrue);
		expect(adapter.events, ['prepare:root', 'prepare:child']);
	});

	test(
		'creation rollback preserves previous frame and cleans staged resources',
		() {
			update(KlpRuntimeNode('root'));
			final frame = runtime.frame!;
			adapter.failCreate = 'bad';
			expect(
				() => update(
					KlpRuntimeNode('root', [
						KlpRuntimeNode('new'),
						KlpRuntimeNode('bad'),
					]),
				),
				throwsA(
					isA<KlpInstallationException>().having(
						(error) => error.committed,
						'committed',
						isFalse,
					),
				),
			);
			expect(runtime.frame, same(frame));
			expect(frame.lease.isActive, isTrue);
			expect(runtime.resources.keys.map((identity) => identity.localId), [
				'root',
			]);
			expect(adapter.events, contains('dispose:new'));
		},
	);

	test(
		'reuses identities removes resources and revokes stale action lease',
		() {
			update(KlpRuntimeNode('root', [KlpRuntimeNode('old')]));
			final first = runtime.frame!;
			final root = runtime.resources[KlpPlacementId(localId: 'root')];
			final old =
					runtime.resources[KlpPlacementId(localId: 'old')]!
							as KlpRuntimeResource;
			update(KlpRuntimeNode('root', [KlpRuntimeNode('new')]));
			expect(runtime.resources[KlpPlacementId(localId: 'root')], same(root));
			expect(old.disposed, isTrue);
			var calls = 0;
			first.lease.run(() => calls++);
			runtime.frame!.lease.run(() => calls++);
			expect(calls, 1);
		},
	);

	test('commit revokes old actions before resource notifications', () {
		update(KlpRuntimeNode('root'));
		final first = runtime.frame!;
		var calls = 0;
		adapter.onUpdate = () => first.lease.run(() => calls++);
		update(KlpRuntimeNode('root', [KlpRuntimeNode('new')]));
		expect(calls, 0);
	});

	test(
		'committed notification failure still publishes consistent new frame',
		() {
			update(KlpRuntimeNode('root'));
			final first = runtime.frame!;
			adapter.onUpdate = () => throw StateError('listener');
			expect(
				() => update(KlpRuntimeNode('root', [KlpRuntimeNode('new')])),
				throwsA(
					isA<KlpInstallationException>().having(
						(error) => error.committed,
						'committed',
						isTrue,
					),
				),
			);
			expect(runtime.frame, isNot(same(first)));
			expect(runtime.frame!.lease.isActive, isTrue);
			expect(first.lease.isActive, isFalse);
			expect(runtime.resources.keys.map((identity) => identity.localId), [
				'root',
				'new',
			]);
		},
	);

	test(
		'internal materialization violation cannot retain stale resource frame',
		() {
			update(KlpRuntimeNode('root'));
			final first = runtime.frame!;
			adapter.failMaterialize = 'root';
			expect(
				() => update(KlpRuntimeNode('root')),
				throwsA(
					isA<KlpInstallationException>().having(
						(error) => error.committed,
						'committed',
						isTrue,
					),
				),
			);
			expect(first.lease.isActive, isFalse);
			expect(runtime.frame, isNull);
			adapter.failMaterialize = null;
			update(KlpRuntimeNode('root'));
			expect(runtime.frame, isNotNull);
		},
	);

	test('built-in component changes data and style without replacing resources or old snapshots', () {
		KlpWorkspaceBlock block(String title) => KlpWorkspaceBlock(id: KlpId.parse('placement'), kind: KlpWorkspaceBlockKind.paper, title: title);
		final adapters = KlpWorkspaceBlockAdapter.createAll();
		final firstStyle = klpTestPrimitives();
		runtime.update(root: block('First'), adapters: adapters, primitives: firstStyle);
		final identity = KlpPlacementId(localId: 'placement');
		final resource = runtime.resources[identity];
		final previous = runtime.frame!;
		final oldContent = (previous.content as KlpBoundPlacement).content as KlpBoundWorkspaceBlock;
		final secondStyle = klpTestPrimitives(alternate: true);
		runtime.update(root: block('Changed'), adapters: adapters, primitives: secondStyle);
		final content = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundWorkspaceBlock;
		expect(runtime.resources[identity], same(resource));
		expect(content, isNot(same(oldContent)));
		expect(oldContent.title, 'First');
		expect(content.title, 'Changed');
		expect(oldContent.background, same(firstStyle.colors[3]));
		expect(content.background, same(secondStyle.colors[3]));
		expect(previous.lease.isActive, isFalse);
	});

	test('dispose releases resources and permanently revokes last frame', () {
		update(KlpRuntimeNode('root'));
		final frame = runtime.frame!;
		final resource =
				runtime.resources[KlpPlacementId(localId: 'root')]!
						as KlpRuntimeResource;
		runtime.dispose();
		runtime.dispose();
		expect(resource.disposed, isTrue);
		expect(frame.lease.isActive, isFalse);
		expect(runtime.resources, isEmpty);
		expect(() => update(KlpRuntimeNode('root')), throwsStateError);
	});
}
