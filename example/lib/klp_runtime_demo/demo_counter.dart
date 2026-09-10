import 'package:kallopis/kallopis_declarative.dart';

import 'demo_counter_content.dart';

/// 子元件只有放置識別與計數，風格由註冊定義提供。
final class DemoCounter implements DemoCounterContent {
  static const typeId = 'demo.counter';

  @override
  final String id;
  @override
  final int value;

  const DemoCounter({required this.id, required this.value});

  @override
  String get definitionId => typeId;
  @override
  Iterable<KlpNode> get children => const [];
}
