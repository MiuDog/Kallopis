import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../klp_inline_code.dart';
import '../../styling/legacy_theme/klp_theme.dart';
import 'klp_rich_text_kind.dart';
import 'klp_rich_text_node.dart';
import 'klp_rich_text_span.dart';
import 'klp_text.dart';

export 'klp_rich_text_kind.dart';
export 'klp_rich_text_node.dart';
export 'klp_rich_text_span.dart';

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
