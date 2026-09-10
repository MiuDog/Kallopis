import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_installation.dart';

import '../klp_test_item.dart';
import 'klp_installation_resource.dart';

final class KlpInstallationFixture {

	final events = <String>[];
	final created = <KlpInstallationResource>[];
	final creationError = StateError('create failed');
	final cleanupError = StateError('cleanup failed');
	String? failCreation;
	String? failCleanup;
	void Function()? onCreate;
	late final installation = KlpInstallation(registry(), create: create);

	static KlpRegistry registry() => KlpRegistry([KlpDefinition<KlpTestItem>('item'), KlpDefinition<KlpTestItem>('other')]);

	KlpInstallationResource create(KlpValidatedNode node) {
		events.add('create:${node.id}');
		onCreate?.call();
		if (node.id == failCreation) throw creationError;

		final resource = KlpInstallationResource(node, events);
		if (node.id == failCleanup) resource.disposalError = cleanupError;

		created.add(resource);
		return resource;
	}

	KlpInstallationResource resource(String id) => installation.resources[KlpPlacementId(localId: id)]! as KlpInstallationResource;
}
