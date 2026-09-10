import 'package:flutter/foundation.dart';

import 'klp_rich_text_kind.dart';

/// 可巢狀組成粗體、斜體、連結與 mention 的行內文字節點。
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
