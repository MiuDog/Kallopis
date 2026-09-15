/// 文字端點在邊界上的親和方向；不決定排版或選取權威。
enum KlpEditingAffinity { upstream, downstream }

/// 核心發布的穩定端點；字素位置不得與平台 byte 位移互換。
final class KlpEditingEndpoint {

	final String blockId;
	final int graphemeBoundary;
	final KlpEditingAffinity affinity;

	KlpEditingEndpoint(this.blockId, this.graphemeBoundary, this.affinity) {
		if (blockId.trim().isEmpty || graphemeBoundary < 0) throw ArgumentError('Invalid stable editing endpoint');
	}

	@override
	bool operator ==(Object other) => other is KlpEditingEndpoint && blockId == other.blockId && graphemeBoundary == other.graphemeBoundary && affinity == other.affinity;

	@override
	int get hashCode => Object.hash(blockId, graphemeBoundary, affinity);
}
