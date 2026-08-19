import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../foundation/klp_inline_code.dart';
import '../theme/klp_theme.dart';
import 'klp_text.dart';

@immutable
class KlpRichTextSpan {
  const KlpRichTextSpan({required this.text, this.strong = false, this.color});

  final String text;
  final bool strong;
  final Color? color;
}

enum KlpRichTextKind {
  text,
  strong,
  emphasis,
  strike,
  code,
  link,
  mention,
  lineBreak,
}

@immutable
class KlpRichTextNode {
  const KlpRichTextNode({
    this.kind = KlpRichTextKind.text,
    this.text,
    this.href,
    this.label,
    this.missing = false,
    this.unsafe = false,
    this.children = const [],
  });

  final KlpRichTextKind kind;
  final String? text;
  final String? href;
  final String? label;
  final bool missing;
  final bool unsafe;
  final List<KlpRichTextNode> children;
}

class KlpRichText extends StatelessWidget {
  const KlpRichText({
    super.key,
    this.spans = const [],
    this.nodes = const [],
    this.selectable = false,
    this.onOpenLink,
    this.onOpenMention,
  });

  final List<KlpRichTextSpan> spans;
  final List<KlpRichTextNode> nodes;
  final bool selectable;
  final ValueChanged<String>? onOpenLink;
  final ValueChanged<String>? onOpenMention;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    final content = TextSpan(
      children: nodes.isEmpty
          ? [
              for (final span in spans)
                TextSpan(
                  text: span.text,
                  style: TextStyle(
                    color: KlpTextStyles.colorFor(
                      tokens,
                      role: KlpTextRole.body,
                      requestedColor: span.color,
                    ),
                    fontWeight: span.strong
                        ? context.klp.type.medium
                        : context.klp.type.regular,
                  ),
                ),
            ]
          : [for (final node in nodes) _spanFor(context, node)],
    );

    final style = TextStyle(
      color: KlpTextStyles.colorFor(tokens, role: KlpTextRole.body),
      fontSize: context.klp.type.body,
      height: context.klp.type.bodyLeading,
      fontFamily: context.klp.type.uiFamily,
      fontFamilyFallback: context.klp.type.fallbackFor(
        context.klp.type.uiFamily,
      ),
    );

    if (selectable) return SelectableText.rich(content, style: style);

    return Text.rich(content, style: style);
  }

  InlineSpan _spanFor(BuildContext context, KlpRichTextNode node) {
    final tokens = context.klpColors;
    final children = node.children.isEmpty
        ? null
        : [for (final child in node.children) _spanFor(context, child)];

    if (node.kind == KlpRichTextKind.lineBreak) {
      return const TextSpan(text: '\n');
    }

    if (node.kind == KlpRichTextKind.code) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: KlpInlineCode(
          node.text ?? '',
          color: node.unsafe ? tokens.danger : null,
        ),
      );
    }

    if (node.kind == KlpRichTextKind.mention) {
      final label = node.label ?? node.text ?? '';

      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onOpenMention == null ? null : () => onOpenMention!(label),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: context.klp.space.tight),
            decoration: BoxDecoration(
              color: node.missing
                  ? tokens.danger.withValues(
                      alpha: context.klp.surface.statusFillOpacity,
                    )
                  : tokens.surfaceInset,
              borderRadius: BorderRadius.circular(context.klp.shape.control),
            ),
            child: KlpText(
              '@$label${node.missing ? ' (missing)' : ''}',
              role: KlpTextRole.code,
              color: node.missing ? tokens.danger : tokens.text,
            ),
          ),
        ),
      );
    }

    final isLink = node.kind == KlpRichTextKind.link;
    final href = node.href ?? '';
    return TextSpan(
      text: node.text,
      children: children,
      recognizer: isLink && onOpenLink != null
          ? (TapGestureRecognizer()..onTap = () => onOpenLink!(href))
          : null,
      style: TextStyle(
        color: KlpTextStyles.colorFor(
          tokens,
          role: KlpTextRole.body,
          tone: isLink ? KlpTextTone.primary : KlpTextTone.automatic,
          requestedColor: node.unsafe ? tokens.danger : null,
        ),
        fontWeight: node.kind == KlpRichTextKind.strong
            ? context.klp.type.medium
            : context.klp.type.regular,
        fontStyle: node.kind == KlpRichTextKind.emphasis
            ? FontStyle.italic
            : FontStyle.normal,
        decoration: node.kind == KlpRichTextKind.strike
            ? TextDecoration.lineThrough
            : isLink
            ? TextDecoration.underline
            : null,
        decorationStyle: node.unsafe ? TextDecorationStyle.wavy : null,
      ),
    );
  }
}
