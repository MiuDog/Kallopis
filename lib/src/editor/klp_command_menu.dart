import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

@immutable
class KlpCommandItemData {
  const KlpCommandItemData({
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
class KlpCommandSectionData {
  const KlpCommandSectionData({required this.label, required this.items});

  final String label;
  final List<KlpCommandItemData> items;
}

class KlpCommandMenu extends StatelessWidget {
  const KlpCommandMenu({
    super.key,
    required this.sections,
    this.width = 300,
    this.framed = true,
  });

  final List<KlpCommandSectionData> sections;
  final double width;
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    final content = Padding(
      padding: EdgeInsets.all(context.klp.space.tight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final section in sections) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.klp.space.compact,
                context.klp.space.compact,
                context.klp.space.compact,
                context.klp.space.tight,
              ),
              child: KlpText(
                section.label.toUpperCase(),
                role: KlpTextRole.label,
                tone: KlpTextTone.faint,
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
              borderRadius: BorderRadius.circular(context.klp.shape.card),
            ),
            child: content,
          )
        : content;

    return SizedBox(width: width, child: menu);
  }
}

class _CommandItem extends StatelessWidget {
  const _CommandItem({required this.data});

  final KlpCommandItemData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final enabled = data.onPressed != null;
    final foreground = data.danger
        ? tokens.danger
        : enabled
        ? tokens.text
        : tokens.textFaint;

    return Material(
      color: data.selected ? tokens.surfaceMuted : tokens.clear,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: data.onPressed,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.klp.space.compact,
            vertical: context.klp.space.compact,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KlpText(data.label, color: foreground),
                    if (data.caption != null)
                      KlpText(
                        data.caption!,
                        role: KlpTextRole.caption,
                        tone: enabled ? KlpTextTone.muted : KlpTextTone.faint,
                      ),
                  ],
                ),
              ),
              if (data.shortcut != null)
                KlpText(
                  data.shortcut!,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.faint,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
