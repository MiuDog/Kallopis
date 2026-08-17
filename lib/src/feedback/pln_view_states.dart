import 'package:flutter/material.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnLoadingState extends StatelessWidget {
  const PlnLoadingState({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.all(PlnSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: PlnSize.iconLarge,
              child: CircularProgressIndicator(
                strokeWidth: PlnLine.width,
                color: context.plnTheme.info,
              ),
            ),
            const SizedBox(height: PlnSpace.md),
            PlnText(label, role: PlnTextRole.caption),
          ],
        ),
      ),
    );
  }
}

class PlnErrorState extends StatelessWidget {
  const PlnErrorState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.retryLabel,
    this.onRetry,
  });

  final String title;
  final String message;
  final String? icon;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _PlnViewState(
      icon: icon,
      iconColor: context.plnTheme.danger,
      title: title,
      message: message,
      action: retryLabel == null
          ? null
          : PlnButton(
              label: retryLabel!,
              tone: PlnButtonTone.primary,
              onPressed: onRetry,
            ),
    );
  }
}

class PlnPermissionState extends StatelessWidget {
  const PlnPermissionState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.action,
  });

  final String title;
  final String message;
  final String? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return _PlnViewState(
      icon: icon,
      iconColor: context.plnTheme.warning,
      title: title,
      message: message,
      action: action,
    );
  }
}

class PlnProgressOverlay extends StatelessWidget {
  const PlnProgressOverlay({
    super.key,
    required this.child,
    required this.visible,
    required this.label,
  });

  final Widget child;
  final bool visible;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (visible)
          Positioned.fill(
            child: ColoredBox(
              color: context.plnTheme.app.withValues(alpha: 0.72),
              child: Center(child: PlnLoadingState(label: label)),
            ),
          ),
      ],
    );
  }
}

class _PlnViewState extends StatelessWidget {
  const _PlnViewState({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.action,
  });

  final String? icon;
  final Color iconColor;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            PlnIcon(icon!, size: PlnSize.iconLarge, color: iconColor),
            const SizedBox(height: PlnSpace.md),
          ],
          PlnText(
            title,
            role: PlnTextRole.section,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PlnSpace.xs),
          PlnText(
            message,
            role: PlnTextRole.caption,
            tone: PlnTextTone.muted,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: PlnSpace.lg), action!],
        ],
      ),
    );
  }
}
