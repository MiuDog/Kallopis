import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../foundation/klp_inline_code.dart';
import '../theme/klp_theme.dart';
import 'klp_text.dart';

/// [KlpRichText.spans] 的簡化片段：一段純文字，只能加粗或換色，沒有連結、
/// 提及或行內程式碼這類結構。適合輕量的混排場合；需要連結、mention 或巢狀
/// 結構時請改用 [KlpRichTextNode]（[KlpRichText.nodes]）。
@immutable
class KlpRichTextSpan {
  const KlpRichTextSpan({required this.text, this.strong = false, this.color});

  final String text;
  final bool strong;
  final Color? color;
}

/// [KlpRichTextNode] 代表的行內語意種類。[lineBreak] 是硬換行，[code] 會用
/// [KlpInlineCode] 渲染成 `WidgetSpan`，[mention] 會渲染成可點擊的標籤膠囊。
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

/// 結構化的行內文字節點，可巢狀組成粗體、斜體、連結、mention 等混排內容。
///
/// [missing] 標示這個 mention 指向的實體已不存在（例如被刪除的使用者），
/// 會改用危險色並附加提示文字；[unsafe] 標示內容本身可能不安全（例如未經
/// 驗證的外部連結），會加上波浪底線並換成危險色作為視覺警示。兩者都只影響
/// 呈現，不會阻止 [KlpRichText] 渲染或觸發 [KlpRichText.onOpenLink] 之類的
/// callback——是否要真的擋下動作由呼叫端在 callback 裡自行判斷。
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

/// 行內混排文字：連結、mention、粗斜體、行內程式碼可以出現在同一段落裡。
///
/// [spans] 與 [nodes] 是兩種不同精細度的輸入，二擇一——給了 [nodes]（非空）
/// 就完全忽略 [spans]；只需要簡單加粗／換色時用 [spans] 即可，不需要為此
/// 組出完整的節點樹。[onOpenLink]／[onOpenMention] 為 null 時，對應的連結與
/// mention 仍會照樣顯示，只是不可點擊。
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
