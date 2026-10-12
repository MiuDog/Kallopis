import 'package:flutter/widgets.dart';

/// Avatar 群組使用的無產品語意資料。
@immutable
class KlpAvatarData {
  const KlpAvatarData({required this.id, required this.label, this.image});

  final String id;
  final String label;
  final ImageProvider? image;
}
