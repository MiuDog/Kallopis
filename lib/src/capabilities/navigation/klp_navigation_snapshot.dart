import 'klp_navigation_entry.dart';

/// 導覽唯一已提交堆疊的不可變快照。
final class KlpNavigationSnapshot {
  final int revision;
  final List<KlpNavigationEntry> entries;

  KlpNavigationSnapshot(this.revision, Iterable<KlpNavigationEntry> entries)
    : entries = List.unmodifiable(entries) {
    if (this.entries.isEmpty) {
      throw ArgumentError('Navigation stack cannot be empty.');
    }
  }

  KlpNavigationEntry get current => entries.last;
  bool get canPop => entries.length > 1;
}
