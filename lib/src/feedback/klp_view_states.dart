import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpLoadingState extends StatelessWidget {
  const KlpLoadingState({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.all(KlpSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: KlpSize.iconLarge,
              child: CircularProgressIndicator(
                strokeWidth: KlpLine.width,
                color: context.plnTheme.info,
              ),
            ),
            const SizedBox(height: KlpSpace.md),
            KlpText(label, role: KlpTextRole.caption),
          ],
        ),
      ),
    );
  }
}

class KlpErrorState extends StatelessWidget {
  const KlpErrorState({
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
    return _KlpViewState(
      icon: icon,
      iconColor: context.plnTheme.danger,
      title: title,
      message: message,
      action: retryLabel == null
          ? null
          : KlpButton(
              label: retryLabel!,
              tone: KlpButtonTone.primary,
              onPressed: onRetry,
            ),
    );
  }
}

class KlpPermissionState extends StatelessWidget {
  const KlpPermissionState({
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
    return _KlpViewState(
      icon: icon,
      iconColor: context.plnTheme.warning,
      title: title,
      message: message,
      action: action,
    );
  }
}

class KlpProgressOverlay extends StatelessWidget {
  const KlpProgressOverlay({
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
              child: Center(child: KlpLoadingState(label: label)),
            ),
          ),
      ],
    );
  }
}

class _KlpViewState extends StatelessWidget {
  const _KlpViewState({
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
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            KlpIcon(icon!, size: KlpSize.iconLarge, color: iconColor),
            const SizedBox(height: KlpSpace.md),
          ],
          KlpText(
            title,
            role: KlpTextRole.section,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: KlpSpace.xs),
          KlpText(
            message,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: KlpSpace.lg), action!],
        ],
      ),
    );
  }
}
