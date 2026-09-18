part of 'klp_command_anchor.dart';

/// 文字命令錨定目前 caret 的 stable endpoint。
final class KlpCaretCommandAnchor extends KlpCommandAnchor {
	final KlpEditingEndpoint endpoint;

	KlpCaretCommandAnchor({required super.stamp, required super.viewportWidth, required super.viewportHeight, required super.rect, required this.endpoint});

	@override
	bool sameIdentity(KlpCommandAnchor other) => other is KlpCaretCommandAnchor && stamp == other.stamp && endpoint == other.endpoint
		&& viewportWidth == other.viewportWidth && viewportHeight == other.viewportHeight && rect == other.rect;
}
