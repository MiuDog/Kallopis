import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../../capabilities/state/klp_state.dart';
import '../../capabilities/state/klp_subscription.dart';
import '../../capabilities/actions/klp_action.dart';
import '../../capabilities/actions/klp_action_activation.dart';
import '../../capabilities/actions/klp_action_handler.dart';
import '../../capabilities/navigation/klp_destination.dart';
import '../../capabilities/navigation/klp_location.dart';
import '../../capabilities/navigation/klp_navigation_decision.dart';
import '../../capabilities/navigation/klp_navigation_entry.dart';
import '../../capabilities/navigation/klp_navigation_ticket.dart';
import '../../capabilities/navigation/klp_navigation_transition.dart';
import '../../capabilities/navigation/klp_route_policy.dart';
import '../../capabilities/navigation/internal/klp_navigation_machine.dart';
import '../../capabilities/navigation/internal/klp_navigation_commit_exception.dart';
import '../../capabilities/navigation/klp_navigation_cancellation.dart';
import '../../capabilities/navigation/klp_navigation_outcome.dart';
import '../../capabilities/navigation/klp_navigation_snapshot.dart';
import '../../capabilities/navigation/klp_navigation_restoration.dart';
import '../../capabilities/navigation/klp_route_uri.dart';
import '../../composition/nodes/internal/klp_scope_boundary.dart';
import '../../composition/nodes/klp_node.dart';
import '../../foundation/binding/internal/klp_bound_template.dart';
import '../../foundation/definitions/klp_component_definition.dart';
import '../../foundation/platform/klp_app_platform.dart';
import '../../foundation/platform/klp_platform_info.dart';
import '../../kernel/lifecycle/internal/klp_run_lifecycle_actions.dart';
import '../../kernel/identity/klp_placement_id.dart';
import '../../rendering/flutter/internal/klp_flutter_renderer.dart';
import '../../runtime/compilation/internal/klp_tree_runtime.dart';
import '../../runtime/compilation/internal/klp_runtime_frame.dart';
import '../../runtime/installation/internal/klp_installation_exception.dart';
import '../../styling/primitives/klp_primitive_set.dart';
import '../../styling/primitives/klp_style_value.dart';
import '../bootstrap/internal/klp_application_adapters.dart';
import 'klp_screen.dart';
import 'internal/klp_retained_screens.dart';

part '../routing/klp_router.dart';
part '../routing/klp_route.dart';
part '../routing/klp_route_input.dart';
part '../environment/klp_application_environment.dart';
part '../bootstrap/run_klp_app.dart';
part '../bootstrap/internal/klp_application_host.dart';
part '../bootstrap/internal/klp_application_host_state.dart';
part '../bootstrap/internal/klp_application_session.dart';
part '../bootstrap/internal/klp_application_session_commit.dart';
part '../bootstrap/internal/klp_application_session_actions.dart';

/// 整份應用宣告；外部只更新此資料，不負責掛載功能資源。
final class KlpApplication {
  final String title;
  final KlpPrimitiveSet primitives;
  final KlpRouter router;
  final List<KlpComponentDefinition<KlpNode>> components;
  final void Function(KlpNavigationRestoration restoration)?
  onNavigationRestorationChanged;

  KlpApplication({
    required this.title,
    required this.primitives,
    required this.router,
    Iterable<KlpComponentDefinition<KlpNode>> components = const [],
    this.onNavigationRestorationChanged,
  }) : components = List<KlpComponentDefinition<KlpNode>>.unmodifiable(
         components,
       ) {
    if (onNavigationRestorationChanged != null && !router.supportsRestoration) {
      throw ArgumentError(
        'Every registered route needs a restoration codec when restoration output is observed.',
      );
    }
  }
}
