import 'package:flutter/material.dart';

import '../controls/klp_icon_button.dart';
import '../controls/klp_text_field.dart';
import '../foundation/klp_icons.dart';
import '../l10n/klp_localizations.dart';
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
        spacing: context.klp.space.tight,
        runSpacing: context.klp.space.tight,
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
        spacing: context.klp.space.compact,
        runSpacing: context.klp.space.tight,
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
    final l10n = KlpLocalizations.of(context);
    return _ActionSurface(
      child: Row(
        children: [
          Expanded(
            child: KlpTextField(
              initialValue: initialQuery,
              onChanged: onQueryChanged,
            ),
          ),
          SizedBox(width: context.klp.space.compact),
          KlpText('$current/$total', role: KlpTextRole.code),
          SizedBox(width: context.klp.space.tight),
          Transform.rotate(
            angle: 3.141592653589793,
            child: KlpIconButton(
              icon: KlpIcons.chevronDown,
              label: l10n.searchPreviousResultLabel,
              onPressed: onPrevious,
            ),
          ),
          KlpIconButton(
            icon: KlpIcons.chevronDown,
            label: l10n.searchNextResultLabel,
            onPressed: onNext,
          ),
          KlpIconButton(
            icon: KlpIcons.x,
            label: l10n.searchCloseLabel,
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
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(context.klp.shape.card),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.klp.space.compact),
        child: child,
      ),
    );
  }
}

class _EditorAction extends StatelessWidget {
  const _EditorAction({required this.data});

  final KlpEditorActionData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final foreground = data.danger
        ? tokens.danger
        : data.onPressed == null
        ? tokens.textFaint
        : tokens.text;

    return Material(
      color: data.selected ? tokens.surfaceMuted : tokens.surfaceInset,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: data.onPressed,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.klp.space.compact,
            vertical: context.klp.space.tight,
          ),
          child: KlpText(data.label, role: KlpTextRole.code, color: foreground),
        ),
      ),
    );
  }
}
