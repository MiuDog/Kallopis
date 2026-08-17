import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

@immutable
class PlnCommandItemData {
  const PlnCommandItemData({
    required this.label,
    this.onPressed,
    this.caption,
    this.shortcut,
    this.selected = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? caption;
  final String? shortcut;
  final bool selected;
  final bool danger;
}

@immutable
class PlnCommandSectionData {
  const PlnCommandSectionData({required this.label, required this.items});

  final String label;
  final List<PlnCommandItemData> items;
}

class PlnCommandMenu extends StatelessWidget {
  const PlnCommandMenu({
    super.key,
    required this.sections,
    this.width = 300,
    this.framed = true,
  });

  final List<PlnCommandSectionData> sections;
  final double width;
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    final content = Padding(
      padding: const EdgeInsets.all(PlnSpace.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final section in sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PlnSpace.sm,
                PlnSpace.sm,
                PlnSpace.sm,
                PlnSpace.xs,
              ),
              child: PlnText(
                section.label.toUpperCase(),
                role: PlnTextRole.label,
                tone: PlnTextTone.faint,
              ),
            ),
            for (final item in section.items) _CommandItem(data: item),
          ],
        ],
      ),
    );
    final menu = framed
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.component,
              borderRadius: BorderRadius.circular(PlnRadius.card),
            ),
            child: content,
          )
        : content;

    return SizedBox(width: width, child: menu);
  }
}

class _CommandItem extends StatelessWidget {
  const _CommandItem({required this.data});

  final PlnCommandItemData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final enabled = data.onPressed != null;
    final foreground = data.danger
        ? tokens.danger
        : enabled
        ? tokens.text
        : tokens.textFaint;

    return Material(
      color: data.selected ? tokens.surfaceMuted : const Color(0x00000000),
      borderRadius: BorderRadius.circular(PlnRadius.control),
      child: InkWell(
        onTap: data.onPressed,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PlnSpace.sm,
            vertical: PlnSpace.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlnText(data.label, color: foreground),
                    if (data.caption != null)
                      PlnText(
                        data.caption!,
                        role: PlnTextRole.caption,
                        tone: enabled ? PlnTextTone.muted : PlnTextTone.faint,
                      ),
                  ],
                ),
              ),
              if (data.shortcut != null)
                PlnText(
                  data.shortcut!,
                  role: PlnTextRole.code,
                  tone: PlnTextTone.faint,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
