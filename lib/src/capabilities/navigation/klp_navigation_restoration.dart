import 'klp_navigation_entry.dart';
import 'klp_navigation_snapshot.dart';
import 'klp_route_address.dart';

/// 已提交導覽堆疊的可保存資料。其編解碼演算法仍由 Kallopis 的 Router 集中呼叫。
final class KlpNavigationRestoration {
  final String routerId;
  final List<KlpRouteAddress> stack;

  KlpNavigationRestoration({
    required this.routerId,
    required Iterable<KlpRouteAddress> stack,
  }) : stack = List.unmodifiable(stack) {
    if (routerId.trim().isEmpty) {
      throw ArgumentError.value(
        routerId,
        'routerId',
        'Restoration router identity cannot be empty.',
      );
    }
    if (this.stack.isEmpty) {
      throw ArgumentError.value(
        stack,
        'stack',
        'Restoration stack cannot be empty.',
      );
    }
  }

  factory KlpNavigationRestoration.fromSnapshot(
    String routerId,
    KlpNavigationSnapshot snapshot,
  ) => KlpNavigationRestoration(
    routerId: routerId,
    stack: snapshot.entries.map(_addressFor),
  );

  static KlpRouteAddress _addressFor(KlpNavigationEntry entry) =>
      entry.location.destination.encodeAddress(entry.location.parameters);
}
