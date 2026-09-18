import 'klp_command_anchor.dart';
import 'klp_command_item.dart';
import 'klp_editing_stamp.dart';

/// 同一 drawing 的有序命令候選；revision 只識別這份不可變候選。
final class KlpCommandProjection {
	final KlpEditingStamp stamp;
	final int revision;
	final KlpCommandAnchor anchor;
	final String emptyLabel;
	final List<KlpCommandItem> items;

	KlpCommandProjection({required this.stamp, required this.revision, required this.anchor, required this.emptyLabel, required Iterable<KlpCommandItem> items}) : items = List.unmodifiable(items) {
		if (revision < 0) throw ArgumentError('Command revision must not be negative');
		stamp.requireExact(anchor.stamp);
		if (emptyLabel.trim().isEmpty) throw ArgumentError('Command empty label must not be blank');
		final ids = <String>{};
		for (final item in this.items) {
			if (!ids.add(item.id)) throw ArgumentError('Duplicate command identity');
		}
	}
}
