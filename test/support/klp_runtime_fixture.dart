import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/internal/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_placement_resource.dart';

/// 內部交易測試用 adapter，以明確注入的故障驗證失敗邊界。
final class KlpRuntimeFixture implements KlpNodeAdapter {

	final events = <String>[];
	String? failPrepare;
	String? failCreate;
	String? failMaterialize;
	void Function()? onUpdate;

	@override
	final contract = KlpDefinition<KlpRuntimeNode>('runtime');

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		events.add('prepare:${snapshot.id}');
		if (snapshot.id == failPrepare) throw StateError('prepare');

		return _Prepared(this, snapshot.id);
	}
}

final class KlpRuntimeNode implements KlpNode {

	final String placement;
	final List<KlpNode> descendants;
	int idReads = 0;
	int definitionReads = 0;
	int childReads = 0;

	KlpRuntimeNode(this.placement, [this.descendants = const []]);

	@override
	String get id {
		idReads++;
		return placement;
	}

	@override
	String get definitionId {
		definitionReads++;
		return 'runtime';
	}

	@override
	Iterable<KlpNode> get children {
		childReads++;
		return descendants;
	}
}

final class KlpRuntimeResource implements KlpPlacementResource {

	final KlpRuntimeFixture fixture;
	final String id;
	bool disposed = false;

	KlpRuntimeResource(this.fixture, this.id);

	@override
	void update(KlpValidatedNode node) {
		fixture.events.add('update:$id');
		fixture.onUpdate?.call();
	}

	@override
	void dispose() {
		disposed = true;
		fixture.events.add('dispose:$id');
	}
}

final class _Prepared implements KlpPreparedNode {

	final KlpRuntimeFixture fixture;
	final String id;

	_Prepared(this.fixture, this.id);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) {
		fixture.events.add('create:$id');
		if (id == fixture.failCreate) throw StateError('create');

		return KlpRuntimeResource(fixture, id);
	}

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		fixture.events.add('materialize:$id');
		if (id == fixture.failMaterialize) throw StateError('materialize');

		return KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), children);
	}
}
