import 'package:flutter/widgets.dart';

import '../data/klp_list_tile.dart';
import '../data/klp_badge.dart';
import '../editor/klp_message_composer.dart';
import '../feedback/klp_empty_state.dart';
import '../feedback/klp_view_states.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../navigation/klp_rail_item.dart';
import '../overlay/klp_dialog.dart';
import '../overlay/klp_menu.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_panel_frame.dart';
import 'klp_panel_header.dart';
import 'klp_sidebar_frame.dart';
import 'klp_status_bar.dart';
import 'klp_workbench_shell.dart';

class KlpAppScreen extends StatelessWidget {
  const KlpAppScreen({super.key, required this.child, this.windowHeader});

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

class KlpAppWindowHeader extends StatelessWidget {
  const KlpAppWindowHeader({
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
      height: KlpSize.header,
      child: KlpPanelHeader(title: title, leading: leading, actions: actions),
    );
  }
}

enum KlpContentState { loading, ready, empty, error, permission }

class KlpFeatureNavigationHost extends StatelessWidget {
  const KlpFeatureNavigationHost({
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

  final KlpContentState state;
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
      KlpContentState.loading => KlpLoadingState(label: loadingLabel),
      KlpContentState.ready => child,
      KlpContentState.empty when emptyIcon != null => KlpEmptyState(
        icon: emptyIcon!,
        title: emptyTitle,
        message: emptyMessage,
      ),
      KlpContentState.empty => _KlpTextState(
        title: emptyTitle,
        message: emptyMessage,
      ),
      KlpContentState.error => KlpErrorState(
        title: errorTitle,
        message: errorMessage,
        retryLabel: retryLabel,
        onRetry: onRetry,
      ),
      KlpContentState.permission => KlpPermissionState(
        title: permissionTitle ?? errorTitle,
        message: permissionMessage ?? errorMessage,
      ),
    };
  }
}

typedef KlpStageContentHost = KlpFeatureNavigationHost;
typedef KlpInspectorContentHost = KlpFeatureNavigationHost;

class _KlpTextState extends StatelessWidget {
  const _KlpTextState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(title, role: KlpTextRole.section),
          const SizedBox(height: KlpSpace.xs),
          KlpText(message, role: KlpTextRole.caption, tone: KlpTextTone.muted),
        ],
      ),
    );
  }
}

@immutable
class KlpProjectSummary {
  const KlpProjectSummary({
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

class KlpProjectList extends StatelessWidget {
  const KlpProjectList({
    super.key,
    required this.projects,
    required this.onOpen,
  });

  final List<KlpProjectSummary> projects;
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (context, index) => const SizedBox(height: KlpSpace.xs),
      itemBuilder: (context, index) {
        final project = projects[index];

        return KlpProjectListItem(
          project: project,
          onOpen: onOpen == null ? null : () => onOpen!(project.id),
        );
      },
    );
  }
}

class KlpProjectListItem extends StatelessWidget {
  const KlpProjectListItem({
    super.key,
    required this.project,
    required this.onOpen,
  });

  final KlpProjectSummary project;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return KlpListTile(
      title: project.name,
      subtitle: project.team,
      icon: project.icon,
      selected: project.selected,
      trailing: project.status == null
          ? null
          : KlpText(
              project.status!,
              role: KlpTextRole.label,
              tone: KlpTextTone.faint,
            ),
      onPressed: onOpen,
    );
  }
}

class KlpProjectEntryScreen extends StatelessWidget {
  const KlpProjectEntryScreen({
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
    return KlpSurface(
      tone: KlpSurfaceTone.base,
      radius: KlpRadius.panel,
      padding: const EdgeInsets.all(KlpSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: KlpSpace.xl),
          Expanded(child: projects),
          if (invites != null) ...[
            const SizedBox(height: KlpSpace.lg),
            invites!,
          ],
          if (actions != null) ...[
            const SizedBox(height: KlpSpace.lg),
            actions!,
          ],
        ],
      ),
    );
  }
}

class KlpProjectInviteList extends StatelessWidget {
  const KlpProjectInviteList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

class KlpProjectInviteAcceptanceScreen extends StatelessWidget {
  const KlpProjectInviteAcceptanceScreen({
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
        child: KlpSurface(
          tone: KlpSurfaceTone.base,
          padding: const EdgeInsets.all(KlpSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              content,
              const SizedBox(height: KlpSpace.lg),
              actions,
            ],
          ),
        ),
      ),
    );
  }
}

class KlpProjectRail extends StatelessWidget {
  const KlpProjectRail({
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

class KlpResponsivePaneCoordinator extends StatelessWidget {
  const KlpResponsivePaneCoordinator({
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

class KlpProjectSyncIndicator extends StatelessWidget {
  const KlpProjectSyncIndicator({
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
            borderRadius: BorderRadius.circular(KlpRadius.full),
          ),
        ),
        const SizedBox(width: KlpSpace.xs),
        KlpText(label, role: KlpTextRole.caption, color: color),
      ],
    );
  }
}

class KlpPaneCollapseControl extends StatelessWidget {
  const KlpPaneCollapseControl({
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
          dimension: KlpSize.controlSmall,
          child: Center(
            child: KlpIcon(
              icon,
              size: KlpSize.iconSmall,
              color: context.plnTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class KlpAiDock extends StatelessWidget {
  const KlpAiDock({
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
    return KlpPanelFrame(
      header: KlpPanelHeader(
        title: title,
        label: status,
        leading: leading,
        actions: actions,
      ),
      footerHeight: 116,
      footer: Padding(
        padding: const EdgeInsets.all(KlpSpace.sm),
        child: KlpMessageComposer(
          placeholder: placeholder,
          sendLabel: sendLabel,
          onSend: onSend,
        ),
      ),
      content: ListView.separated(
        padding: const EdgeInsets.all(KlpSpace.md),
        itemCount: messages.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: KlpSpace.sm),
        itemBuilder: (context, index) => messages[index],
      ),
    );
  }
}

typedef KlpProjectWorkbench = KlpWorkbenchShell;
typedef KlpProjectRailItem = KlpRailItem;
typedef KlpPrimarySidebarFrame = KlpSidebarFrame;
typedef KlpSecondarySidebarFrame = KlpPanelFrame;
typedef KlpInspectorHeader = KlpPanelHeader;
typedef KlpStageHeader = KlpPanelHeader;
typedef KlpStageStatusBar = KlpStatusBar;
typedef KlpProjectMenu = KlpMenu;
typedef KlpCreateProjectDialog = KlpDialog;
typedef KlpJoinProjectDialog = KlpDialog;
typedef KlpCreateResourceDialog = KlpDialog;
typedef KlpGlobalSearchDialog = KlpDialog;
typedef KlpUnsavedChangesDialog = KlpDialog;
typedef KlpPermissionRequestDialog = KlpDialog;
typedef KlpResourceMoveDialog = KlpDialog;
typedef KlpTrashConfirmationDialog = KlpDialog;
typedef KlpProjectEnvironmentBadge = KlpBadge;
typedef KlpProjectOpenFailureState = KlpErrorState;
