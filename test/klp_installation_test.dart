import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_default_placement.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_installation.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_installation_exception.dart';

import 'support/klp_installation_fixture.dart';
import 'klp_test_item.dart';

KlpTestItem _tree([List<KlpNode> children = const []]) => KlpTestItem('root', 'item', children);
KlpTestItem _item(String id) => KlpTestItem(id, 'item');

void main() {
	late KlpInstallationFixture fixture;
	setUp(() => fixture = KlpInstallationFixture());

	test('invalid descendant allocates no resources', () {
		expect(() => fixture.installation.update(_tree([KlpTestItem('bad', 'missing')])), throwsA(isA<KlpContractError>()));
		expect(fixture.events, isEmpty);
		expect(fixture.installation.tree, isNull);
	});

	test('invalid update preserves previous tree and releases busy guard', () {
		fixture.installation.update(_tree());
		final previous = fixture.installation.tree;
		fixture.events.clear();
		expect(() => fixture.installation.update(_tree([_item('root')])), throwsA(isA<KlpContractError>()));
		expect(fixture.installation.tree, same(previous));
		expect(fixture.events, isEmpty);
		fixture.installation.update(_tree([_item('valid')]));
		expect(fixture.installation.resources.keys.map((identity) => identity.localId), ['root', 'valid']);
	});

	test('same identities retain resources and suppress no op notifications', () {
		final installation = KlpInstallation(KlpInstallationFixture.registry());
		addTearDown(installation.dispose);
		installation.update(_tree([_item('a')]));
		final root = installation.resources[KlpPlacementId(localId: 'root')]! as KlpDefaultPlacement;
		var notifications = 0;
		root.state.subscribe((_) => notifications++);
		final child = installation.resources[KlpPlacementId(localId: 'a')];
		installation.update(_tree([_item('a')]));
		expect(installation.resources[KlpPlacementId(localId: 'root')], same(root));
		expect(installation.resources[KlpPlacementId(localId: 'a')], same(child));
		expect(notifications, 0);
	});

	test('same id with different definition replaces resource', () {
		fixture.installation.update(_tree([_item('a')]));
		final old = fixture.resource('a');
		fixture.events.clear();
		fixture.installation.update(_tree([KlpTestItem('a', 'other')]));
		expect(fixture.resource('a'), isNot(same(old)));
		expect(old.disposed, isTrue);
		expect(fixture.events, ['create:a', 'dispose:a']);
	});

	test('reorder updates parent snapshot without recreating children', () {
		fixture.installation.update(_tree([_item('a'), _item('b')]));
		final child = fixture.resource('a');
		fixture.events.clear();
		fixture.installation.update(_tree([_item('b'), _item('a')]));
		expect(fixture.events, ['update:root']);
		expect(fixture.resource('root').node.childrenIds, ['b', 'a']);
		expect(fixture.resource('a'), same(child));
	});

	test('creation failure rolls back new resources despite cleanup failure', () {
		fixture.installation.update(_tree([_item('old')]));
		final previous = fixture.installation.tree;
		final root = fixture.resource('root');
		fixture.failCreation = 'fail';
		fixture.failCleanup = 'b';
		fixture.events.clear();
		final failure = _capture(() => fixture.installation.update(_tree([_item('a'), _item('b'), _item('fail')])));
		expect(failure.committed, isFalse);
		expect(failure.issues.map((issue) => issue.error), [fixture.creationError, fixture.cleanupError]);
		expect(fixture.events, ['create:a', 'create:b', 'create:fail', 'dispose:b', 'dispose:a']);
		expect(fixture.installation.tree, same(previous));
		expect(fixture.resource('root'), same(root));
		expect(root.node.childrenIds, ['old']);
		expect(fixture.resource('old').disposed, isFalse);
		fixture.failCreation = null;
		fixture.installation.update(_tree());
		expect(fixture.installation.resources.keys.map((identity) => identity.localId), ['root']);
	});

	test('notification failure commits and still cleans removed placements', () {
		fixture.installation.update(_tree([_item('old')]));
		final notificationError = StateError('notification failed');
		fixture.resource('root').onUpdate = () => throw notificationError;
		fixture.resource('old').disposalError = fixture.cleanupError;
		fixture.events.clear();
		final failure = _capture(() => fixture.installation.update(_tree([_item('new')])));
		expect(failure.committed, isTrue);
		expect(failure.issues.map((issue) => issue.error), [notificationError, fixture.cleanupError]);
		expect(fixture.events, ['create:new', 'update:root', 'dispose:old']);
		expect(fixture.installation.resources.keys.map((identity) => identity.localId), ['root', 'new']);
		expect(fixture.installation.tree!.nodes.first.childrenIds, ['new']);
	});

	test('disposal reverses current tree and continues after errors', () {
		fixture.installation.update(_tree([KlpTestItem('a', 'item', [_item('nested')]), _item('b')]));
		fixture.resource('b').disposalError = fixture.cleanupError;
		fixture.events.clear();
		final failure = _capture(fixture.installation.dispose);
		expect(failure.committed, isTrue);
		expect(fixture.events, ['dispose:b', 'dispose:nested', 'dispose:a', 'dispose:root']);
		expect(fixture.installation.resources, isEmpty);
		expect(fixture.installation.tree, isNull);
		expect(fixture.installation.isDisposed, isTrue);
		fixture.installation.dispose();
		expect(fixture.events, hasLength(4));
		expect(() => fixture.installation.update(_tree()), throwsStateError);
	});

	test('creation rejects nested update and dispose without unlocking outer transaction', () {
		fixture.onCreate = () {
			expect(() => fixture.installation.update(_tree()), throwsStateError);
			expect(fixture.installation.dispose, throwsStateError);
			expect(() => fixture.installation.update(_tree()), throwsStateError);
		};
		fixture.installation.update(_tree([_item('a')]));
		expect(fixture.installation.resources.keys.map((identity) => identity.localId), ['root', 'a']);
	});

	test('committed notifications reject nested update and dispose', () {
		fixture.installation.update(_tree());
		fixture.resource('root').onUpdate = () {
			expect(() => fixture.installation.update(_tree()), throwsStateError);
			expect(fixture.installation.dispose, throwsStateError);
		};
		fixture.installation.update(_tree([_item('a')]));
		expect(fixture.installation.resources.keys.map((identity) => identity.localId), ['root', 'a']);
	});

	test('replacement cleanup rejects reentry while exposing committed tree', () {
		fixture.installation.update(_tree([_item('old')]));
		fixture.resource('old').onDispose = () {
			expect(fixture.installation.resources.keys.map((identity) => identity.localId), ['root']);
			expect(() => fixture.installation.update(_tree()), throwsStateError);
			expect(fixture.installation.dispose, throwsStateError);
		};
		fixture.installation.update(_tree());
		expect(fixture.installation.isDisposed, isFalse);
	});

	test('default placement disposal releases controller state and subscription', () {
		final installation = KlpInstallation(KlpInstallationFixture.registry());
		installation.update(_tree());
		final root = installation.resources[KlpPlacementId(localId: 'root')]! as KlpDefaultPlacement;
		final subscription = root.state.subscribe((_) {});
		installation.dispose();
		expect(root.controller.isDisposed, isTrue);
		expect(root.isDisposed, isTrue);
		expect(subscription.isCancelled, isTrue);
		expect(() => root.state.value, throwsStateError);
	});
}

KlpInstallationException _capture(void Function() operation) {
	try {
		operation();
	}
	on KlpInstallationException catch (error) {
		return error;
	}
	throw StateError('Expected an installation failure.');
}
