import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'dart:async';
import 'package:kallopis/src/capabilities/actions/klp_pick_file_action.dart';
import 'package:kallopis/src/capabilities/files/klp_file_selection.dart';
import 'package:kallopis/src/application/environment/klp_file_selection_adapter.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';

import 'package:kallopis/src/capabilities/state/klp_state.dart';
import 'package:kallopis/src/capabilities/state/klp_subscription.dart';
import 'package:kallopis/src/capabilities/actions/klp_action.dart';
import 'package:kallopis/src/capabilities/actions/klp_action_activation.dart';
import 'package:kallopis/src/capabilities/actions/klp_action_handler.dart';
import 'package:kallopis/src/capabilities/navigation/klp_destination.dart';
import 'package:kallopis/src/capabilities/navigation/klp_location.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_decision.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_entry.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_ticket.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_transition.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_policy.dart';
import 'package:kallopis/src/capabilities/navigation/engine/klp_navigation_machine.dart';
import 'package:kallopis/src/capabilities/navigation/engine/klp_navigation_commit_exception.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_cancellation.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_snapshot.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_restoration.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_uri.dart';
import 'package:kallopis/src/composition/nodes/klp_scope_boundary.dart';
import 'package:kallopis/src/composition/nodes/klp_platform_strategy.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/capabilities/environment/klp_app_platform.dart';
import 'package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart';
import 'package:kallopis/src/foundation/platform/klp_id_scope.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_run_lifecycle_actions.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/rendering/flutter/klp_viewport_capabilities.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/runtime/contracts/klp_runtime_frame.dart';
import 'package:kallopis/src/runtime/contracts/klp_installation_exception.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/presets/klp_workspace_preset.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'klp_screen.dart';
import 'internal/klp_retained_screens.dart';

part '../routing/klp_router.dart';
part '../routing/klp_route.dart';
part '../routing/klp_route_input.dart';
part '../environment/klp_application_environment.dart';
part '../environment/klp_application_environment_observer.dart';
part '../bootstrap/run_klp_app.dart';
part '../bootstrap/internal/klp_application_host.dart';
part '../bootstrap/internal/klp_application_host_state.dart';
part '../bootstrap/internal/klp_application_session.dart';
part '../bootstrap/internal/klp_application_session_commit.dart';
part '../bootstrap/internal/klp_application_session_actions.dart';

/// 整份應用宣告；外部只更新此資料，不負責掛載功能資源。
final class KlpApplication {

	final String title;
	final KlpRouter router;
	final void Function(KlpNavigationRestoration restoration)? onNavigationRestorationChanged;

	KlpApplication({required this.title, required this.router, this.onNavigationRestorationChanged}) {
		if (onNavigationRestorationChanged != null && !router.supportsRestoration) {
			throw ArgumentError('Every registered route needs a restoration codec when restoration output is observed.');
		}
	}
}
