import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

import '../foundation/klp_geometric_spinner.dart';

class KlpLoadingState extends StatelessWidget {
  const KlpLoadingState({
    super.key,
    required this.label,
    this.color,
    this.spinnerSize,
  });

  final String label;
  final Color? color;
  final double? spinnerSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: EdgeInsets.all(context.klp.space.loose),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KlpGeometricSpinner(
              size: spinnerSize ?? context.klp.space.iconLarge,
              color: color ?? context.klpColors.info,
            ),
            SizedBox(height: context.klp.space.base),
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
      iconColor: context.klpColors.danger,
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
      iconColor: context.klpColors.warning,
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
    this.backgroundColor,
  });

  final Widget child;
  final bool visible;
  final String label;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final isDark = tokens.surface.computeLuminance() < 0.5;
    final veil = context.klp.surface.veilOpacity;
    final effectiveOverlayColor =
        backgroundColor ??
        (isDark
            ? tokens.stageSurface.withValues(alpha: veil)
            : tokens.surface.withValues(alpha: veil));

    return Stack(
      children: [
        child,
        if (visible)
          Positioned.fill(
            child: ColoredBox(
              color: effectiveOverlayColor,
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
    return KlpDashedBorder(
      radius: context.klp.shape.card,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.klp.space.loose),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              KlpIcon(
                icon!,
                size: context.klp.space.iconLarge,
                color: iconColor,
              ),
              SizedBox(height: context.klp.space.base),
            ],
            KlpText(
              title,
              role: KlpTextRole.section,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.klp.space.tight),
            KlpText(
              message,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              SizedBox(height: context.klp.space.comfortable),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
