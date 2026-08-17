import 'package:flutter/widgets.dart';

import '../data/pln_list_tile.dart';
import '../data/pln_badge.dart';
import '../editor/pln_message_composer.dart';
import '../feedback/pln_empty_state.dart';
import '../feedback/pln_view_states.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../navigation/pln_rail_item.dart';
import '../overlay/pln_dialog.dart';
import '../overlay/pln_menu.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'pln_panel_frame.dart';
import 'pln_panel_header.dart';
import 'pln_sidebar_frame.dart';
import 'pln_status_bar.dart';
import 'pln_workbench_shell.dart';

class PlanistAppScreen extends StatelessWidget {
  const PlanistAppScreen({super.key, required this.child, this.windowHeader});

  final Widget? windowHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.plnTheme.app,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?windowHeader,
          Expanded(child: child),
        ],
      ),
    );
  }
}

class PlnAppWindowHeader extends StatelessWidget {
  const PlnAppWindowHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PlnSize.header,
      child: PlnPanelHeader(title: title, leading: leading, actions: actions),
    );
  }
}

enum PlnContentState { loading, ready, empty, error, permission }

class PlnFeatureNavigationHost extends StatelessWidget {
  const PlnFeatureNavigationHost({
    super.key,
    required this.state,
    required this.child,
    required this.loadingLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorTitle,
    required this.errorMessage,
    this.permissionTitle,
    this.permissionMessage,
    this.emptyIcon,
    this.onRetry,
    this.retryLabel,
  });

  final PlnContentState state;
  final Widget child;
  final String loadingLabel;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String errorMessage;
  final String? permissionTitle;
  final String? permissionMessage;
  final String? emptyIcon;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      PlnContentState.loading => PlnLoadingState(label: loadingLabel),
      PlnContentState.ready => child,
      PlnContentState.empty when emptyIcon != null => PlnEmptyState(
        icon: emptyIcon!,
        title: emptyTitle,
        message: emptyMessage,
      ),
      PlnContentState.empty => _PlnTextState(
        title: emptyTitle,
        message: emptyMessage,
      ),
      PlnContentState.error => PlnErrorState(
        title: errorTitle,
        message: errorMessage,
        retryLabel: retryLabel,
        onRetry: onRetry,
      ),
      PlnContentState.permission => PlnPermissionState(
        title: permissionTitle ?? errorTitle,
        message: permissionMessage ?? errorMessage,
      ),
    };
  }
}

typedef PlnStageContentHost = PlnFeatureNavigationHost;
typedef PlnInspectorContentHost = PlnFeatureNavigationHost;

class _PlnTextState extends StatelessWidget {
  const _PlnTextState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlnText(title, role: PlnTextRole.section),
          const SizedBox(height: PlnSpace.xs),
          PlnText(message, role: PlnTextRole.caption, tone: PlnTextTone.muted),
        ],
      ),
    );
  }
}

@immutable
class PlnProjectSummary {
  const PlnProjectSummary({
    required this.id,
    required this.name,
    required this.team,
    this.icon,
    this.status,
    this.selected = false,
  });

  final String id;
  final String name;
  final String team;
  final String? icon;
  final String? status;
  final bool selected;
}

class PlnProjectList extends StatelessWidget {
  const PlnProjectList({
    super.key,
    required this.projects,
    required this.onOpen,
  });

  final List<PlnProjectSummary> projects;
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (context, index) => const SizedBox(height: PlnSpace.xs),
      itemBuilder: (context, index) {
        final project = projects[index];

        return PlnProjectListItem(
          project: project,
          onOpen: onOpen == null ? null : () => onOpen!(project.id),
        );
      },
    );
  }
}

class PlnProjectListItem extends StatelessWidget {
  const PlnProjectListItem({
    super.key,
    required this.project,
    required this.onOpen,
  });

  final PlnProjectSummary project;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return PlnListTile(
      title: project.name,
      subtitle: project.team,
      icon: project.icon,
      selected: project.selected,
      trailing: project.status == null
          ? null
          : PlnText(
              project.status!,
              role: PlnTextRole.label,
              tone: PlnTextTone.faint,
            ),
      onPressed: onOpen,
    );
  }
}

class PlnProjectEntryScreen extends StatelessWidget {
  const PlnProjectEntryScreen({
    super.key,
    required this.header,
    required this.projects,
    this.invites,
    this.actions,
  });

  final Widget header;
  final Widget projects;
  final Widget? invites;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.base,
      radius: PlnRadius.panel,
      padding: const EdgeInsets.all(PlnSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: PlnSpace.xl),
          Expanded(child: projects),
          if (invites != null) ...[
            const SizedBox(height: PlnSpace.lg),
            invites!,
          ],
          if (actions != null) ...[
            const SizedBox(height: PlnSpace.lg),
            actions!,
          ],
        ],
      ),
    );
  }
}

class PlnProjectInviteList extends StatelessWidget {
  const PlnProjectInviteList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

class PlnProjectInviteAcceptanceScreen extends StatelessWidget {
  const PlnProjectInviteAcceptanceScreen({
    super.key,
    required this.content,
    required this.actions,
  });

  final Widget content;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: PlnSurface(
          tone: PlnSurfaceTone.base,
          padding: const EdgeInsets.all(PlnSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              content,
              const SizedBox(height: PlnSpace.lg),
              actions,
            ],
          ),
        ),
      ),
    );
  }
}

class PlnProjectRail extends StatelessWidget {
  const PlnProjectRail({
    super.key,
    required this.destinations,
    this.bottom = const [],
  });

  final List<Widget> destinations;
  final List<Widget> bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...destinations,
        if (bottom.isNotEmpty) const Spacer(),
        ...bottom,
      ],
    );
  }
}

class PlnResponsivePaneCoordinator extends StatelessWidget {
  const PlnResponsivePaneCoordinator({
    super.key,
    required this.wide,
    required this.compact,
    this.breakpoint = 960,
  });

  final Widget wide;
  final Widget compact;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth >= breakpoint ? wide : compact;
      },
    );
  }
}

class PlnProjectSyncIndicator extends StatelessWidget {
  const PlnProjectSyncIndicator({
    super.key,
    required this.label,
    required this.synced,
  });

  final String label;
  final bool synced;

  @override
  Widget build(BuildContext context) {
    final color = synced ? context.plnTheme.success : context.plnTheme.warning;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(PlnRadius.full),
          ),
        ),
        const SizedBox(width: PlnSpace.xs),
        PlnText(label, role: PlnTextRole.caption, color: color),
      ],
    );
  }
}

class PlnPaneCollapseControl extends StatelessWidget {
  const PlnPaneCollapseControl({
    super.key,
    required this.icon,
    required this.label,
    required this.collapsed,
    required this.onToggle,
  });

  final String icon;
  final String label;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Semantics(
        button: true,
        label: label,
        expanded: !collapsed,
        child: SizedBox.square(
          dimension: PlnSize.controlSmall,
          child: Center(
            child: PlnIcon(
              icon,
              size: PlnSize.iconSmall,
              color: context.plnTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class PlnAiDock extends StatelessWidget {
  const PlnAiDock({
    super.key,
    required this.title,
    required this.status,
    required this.messages,
    required this.placeholder,
    required this.sendLabel,
    required this.onSend,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String status;
  final List<Widget> messages;
  final String placeholder;
  final String sendLabel;
  final ValueChanged<String> onSend;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return PlnPanelFrame(
      header: PlnPanelHeader(
        title: title,
        label: status,
        leading: leading,
        actions: actions,
      ),
      footerHeight: 116,
      footer: Padding(
        padding: const EdgeInsets.all(PlnSpace.sm),
        child: PlnMessageComposer(
          placeholder: placeholder,
          sendLabel: sendLabel,
          onSend: onSend,
        ),
      ),
      content: ListView.separated(
        padding: const EdgeInsets.all(PlnSpace.md),
        itemCount: messages.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: PlnSpace.sm),
        itemBuilder: (context, index) => messages[index],
      ),
    );
  }
}

typedef PlnProjectWorkbench = PlnWorkbenchShell;
typedef PlnProjectRailItem = PlnRailItem;
typedef PlnPrimarySidebarFrame = PlnSidebarFrame;
typedef PlnSecondarySidebarFrame = PlnPanelFrame;
typedef PlnInspectorHeader = PlnPanelHeader;
typedef PlnStageHeader = PlnPanelHeader;
typedef PlnStageStatusBar = PlnStatusBar;
typedef PlnProjectMenu = PlnMenu;
typedef PlnCreateProjectDialog = PlnDialog;
typedef PlnJoinProjectDialog = PlnDialog;
typedef PlnCreateResourceDialog = PlnDialog;
typedef PlnGlobalSearchDialog = PlnDialog;
typedef PlnUnsavedChangesDialog = PlnDialog;
typedef PlnPermissionRequestDialog = PlnDialog;
typedef PlnResourceMoveDialog = PlnDialog;
typedef PlnTrashConfirmationDialog = PlnDialog;
typedef PlnProjectEnvironmentBadge = PlnBadge;
typedef PlnProjectOpenFailureState = PlnErrorState;
