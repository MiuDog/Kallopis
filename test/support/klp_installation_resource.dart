import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_placement_resource.dart';

/// 記錄副作用並提供故障注入，僅供安裝交易測試。
final class KlpInstallationResource implements KlpPlacementResource {

	KlpValidatedNode node;
	final List<String> events;
	Object? disposalError;
	void Function()? onUpdate;
	void Function()? onDispose;
	bool disposed = false;

	KlpInstallationResource(this.node, this.events);

	@override
	void update(KlpValidatedNode next) {
		node = next;
		events.add('update:${node.id}');
		onUpdate?.call();
	}

	@override
	void dispose() {
		disposed = true;
		events.add('dispose:${node.id}');
		onDispose?.call();
		if (disposalError != null) throw disposalError!;
	}
}
