/// 編輯投影的完整身分；內容未提交時，組字與選取仍可發布新投影。
final class KlpEditingStamp {

	final String documentId;
	final String pageId;
	final int generation;
	final int projectionRevision;
	final int contentRevision;
	final int compositionRevision;
	final int layoutRevision;
	final String environmentId;

	KlpEditingStamp({
		required this.documentId,
		required this.pageId,
		required this.generation,
		required this.projectionRevision,
		required this.contentRevision,
		required this.compositionRevision,
		required this.layoutRevision,
		required this.environmentId,
	}) {
		for (final id in [documentId, pageId, environmentId]) {
			if (id.trim().isEmpty) throw ArgumentError('Editing identities must not be empty');
		}
		for (final revision in [generation, projectionRevision, contentRevision, compositionRevision, layoutRevision]) {
			if (revision < 0) throw ArgumentError('Editing revisions must not be negative');
		}
	}

	bool sameSession(KlpEditingStamp other) => documentId == other.documentId && pageId == other.pageId && generation == other.generation;

	void requireExact(KlpEditingStamp expected) {
		if (this != expected) throw StateError('Editing projection is stale or belongs to another session');
	}

	@override
	bool operator ==(Object other) => other is KlpEditingStamp
		&& sameSession(other)
		&& projectionRevision == other.projectionRevision
		&& contentRevision == other.contentRevision
		&& compositionRevision == other.compositionRevision
		&& layoutRevision == other.layoutRevision
		&& environmentId == other.environmentId;

	@override
	int get hashCode => Object.hash(documentId, pageId, generation, projectionRevision, contentRevision, compositionRevision, layoutRevision, environmentId);
}
