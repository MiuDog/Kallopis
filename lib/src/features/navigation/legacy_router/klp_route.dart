part of 'klp_router.dart';

/// 由產品註冊、Kallopis 只負責分發的目的地。
@immutable
class KlpRoute {
  const KlpRoute({required this.id, required this.builder, this.data});

  final String id;
  final KlpPanelLayoutBuilder builder;
  final Object? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpRoute &&
          id == other.id &&
          builder == other.builder &&
          data == other.data;

  @override
  int get hashCode => Object.hash(id, builder, data);
}
