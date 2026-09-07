import 'package:flutter/foundation.dart';

import '../../../feedback/klp_feedback_tone.dart';
import '../../../foundation/klp_icon.dart';

@immutable
class KlpDataColumn {
	const KlpDataColumn({
		required this.id,
		required this.label,
		this.width,
		this.sortable = false,
		this.alignment = KlpDataAlignment.start,
		this.verbatim = false,
	});

	final String id;
	final String label;
	final double? width;
	final bool sortable;
	final KlpDataAlignment alignment;
	final bool verbatim;
}

enum KlpDataAlignment { start, end }
enum KlpSortDirection { ascending, descending }

@immutable
class KlpDataSort {
	const KlpDataSort({required this.columnId, required this.direction});

	final String columnId;
	final KlpSortDirection direction;
}

@immutable
class KlpDataRow {
	const KlpDataRow({required this.id, required this.cells});

	final String id;
	final Map<String, Object> cells;
}

@immutable
class KlpTreeNode {
	const KlpTreeNode({
		required this.id,
		required this.label,
		this.icon,
		this.children = const [],
		this.expanded = true,
		this.selected = false,
		this.hasChildren = false,
		this.deleted = false,
		this.badge,
		this.tone,
	});

	final String id;
	final String label;
	final KlpIconData? icon;
	final List<KlpTreeNode> children;
	final bool expanded;
	final bool selected;
	final bool hasChildren;
	final bool deleted;
	final String? badge;
	final KlpFeedbackTone? tone;
}

enum KlpFilePreviewState { ready, loading, error, unsupported }
