import 'package:flutter/material.dart';

import '../controls/klp_icon_button.dart';
import '../controls/klp_text_field.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

@immutable
class KlpEditorActionData {
  const KlpEditorActionData({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final bool danger;
}

class KlpEditorToolbar extends StatelessWidget {
  const KlpEditorToolbar({super.key, required this.actions});

  final List<KlpEditorActionData> actions;

  @override
  Widget build(BuildContext context) {
    return _ActionSurface(
      child: Wrap(
        spacing: KlpSpace.xs,
        runSpacing: KlpSpace.xs,
        children: [for (final action in actions) _EditorAction(data: action)],
      ),
    );
  }
}

class KlpBulkActionBar extends StatelessWidget {
  const KlpBulkActionBar({
    super.key,
    required this.label,
    required this.actions,
  });

  final String label;
  final List<KlpEditorActionData> actions;

  @override
  Widget build(BuildContext context) {
    return _ActionSurface(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: KlpSpace.sm,
        runSpacing: KlpSpace.xs,
        children: [
          KlpText(label, role: KlpTextRole.code),
          for (final action in actions) _EditorAction(data: action),
        ],
      ),
    );
  }
}

class KlpSearchNavigator extends StatelessWidget {
  const KlpSearchNavigator({
    super.key,
    required this.initialQuery,
    required this.current,
    required this.total,
    required this.onPrevious,
    required this.onNext,
    required this.onClose,
    this.onQueryChanged,
  });

  final String initialQuery;
  final int current;
  final int total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onClose;
  final ValueChanged<String>? onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return _ActionSurface(
      child: Row(
        children: [
          Expanded(
            child: KlpTextField(
              initialValue: initialQuery,
              onChanged: onQueryChanged,
            ),
          ),
          const SizedBox(width: KlpSpace.sm),
          KlpText('$current/$total', role: KlpTextRole.code),
          const SizedBox(width: KlpSpace.xs),
          Transform.rotate(
            angle: 3.141592653589793,
            child: KlpIconButton(
              icon: KlpIcons.chevronDown,
              label: 'Previous result',
              onPressed: onPrevious,
            ),
          ),
          KlpIconButton(
            icon: KlpIcons.chevronDown,
            label: 'Next result',
            onPressed: onNext,
          ),
          KlpIconButton(
            icon: KlpIcons.x,
            label: 'Close search',
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _ActionSurface extends StatelessWidget {
  const _ActionSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(KlpRadius.card),
      ),
      child: Padding(padding: const EdgeInsets.all(KlpSpace.sm), child: child),
    );
  }
}

class _EditorAction extends StatelessWidget {
  const _EditorAction({required this.data});

  final KlpEditorActionData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final foreground = data.danger
        ? tokens.danger
        : data.onPressed == null
        ? tokens.textFaint
        : tokens.text;

    return Material(
      color: data.selected ? tokens.surfaceMuted : tokens.surfaceInset,
      borderRadius: BorderRadius.circular(KlpRadius.control),
      child: InkWell(
        onTap: data.onPressed,
        borderRadius: BorderRadius.circular(KlpRadius.control),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: KlpSpace.sm,
            vertical: KlpSpace.xs,
          ),
          child: KlpText(data.label, role: KlpTextRole.code, color: foreground),
        ),
      ),
    );
  }
}
