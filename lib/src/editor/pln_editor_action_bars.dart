import 'package:flutter/material.dart';

import '../controls/pln_icon_button.dart';
import '../controls/pln_text_field.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

@immutable
class PlnEditorActionData {
  const PlnEditorActionData({
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

class PlnEditorToolbar extends StatelessWidget {
  const PlnEditorToolbar({super.key, required this.actions});

  final List<PlnEditorActionData> actions;

  @override
  Widget build(BuildContext context) {
    return _ActionSurface(
      child: Wrap(
        spacing: PlnSpace.xs,
        runSpacing: PlnSpace.xs,
        children: [for (final action in actions) _EditorAction(data: action)],
      ),
    );
  }
}

class PlnBulkActionBar extends StatelessWidget {
  const PlnBulkActionBar({
    super.key,
    required this.label,
    required this.actions,
  });

  final String label;
  final List<PlnEditorActionData> actions;

  @override
  Widget build(BuildContext context) {
    return _ActionSurface(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: PlnSpace.sm,
        runSpacing: PlnSpace.xs,
        children: [
          PlnText(label, role: PlnTextRole.code),
          for (final action in actions) _EditorAction(data: action),
        ],
      ),
    );
  }
}

class PlnSearchNavigator extends StatelessWidget {
  const PlnSearchNavigator({
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
            child: PlnTextField(
              initialValue: initialQuery,
              onChanged: onQueryChanged,
            ),
          ),
          const SizedBox(width: PlnSpace.sm),
          PlnText('$current/$total', role: PlnTextRole.code),
          const SizedBox(width: PlnSpace.xs),
          Transform.rotate(
            angle: 3.141592653589793,
            child: PlnIconButton(
              icon: PlnIcons.chevronDown,
              label: 'Previous result',
              onPressed: onPrevious,
            ),
          ),
          PlnIconButton(
            icon: PlnIcons.chevronDown,
            label: 'Next result',
            onPressed: onNext,
          ),
          PlnIconButton(
            icon: PlnIcons.x,
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
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Padding(padding: const EdgeInsets.all(PlnSpace.sm), child: child),
    );
  }
}

class _EditorAction extends StatelessWidget {
  const _EditorAction({required this.data});

  final PlnEditorActionData data;

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
      borderRadius: BorderRadius.circular(PlnRadius.control),
      child: InkWell(
        onTap: data.onPressed,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PlnSpace.sm,
            vertical: PlnSpace.xs,
          ),
          child: PlnText(data.label, role: PlnTextRole.code, color: foreground),
        ),
      ),
    );
  }
}
