part of 'klp_command_anchor.dart';

/// 區塊命令只錨定 stable ID；visual rect 不作文字命中。
final class KlpBlockCommandAnchor extends KlpCommandAnchor {
	final String blockId;

	KlpBlockCommandAnchor({required super.stamp, required super.viewportWidth, required super.viewportHeight, required super.rect, required this.blockId}) {
		if (blockId.trim().isEmpty) throw ArgumentError('Block command anchor requires an identity');
	}

	@override
	bool sameIdentity(KlpCommandAnchor other) => other is KlpBlockCommandAnchor && stamp == other.stamp && blockId == other.blockId
		&& viewportWidth == other.viewportWidth && viewportHeight == other.viewportHeight && rect == other.rect;
}
