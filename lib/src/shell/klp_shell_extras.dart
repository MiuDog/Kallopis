import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import 'klp_panel_header.dart';

class KlpAppScreen extends StatelessWidget {
  const KlpAppScreen({super.key, required this.child, this.windowHeader});

  final Widget? windowHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.klpColors.app,
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
              color: context.klpColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

