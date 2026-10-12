import 'package:flutter/widgets.dart';

/// App background 後唯一合法的 Kallopis Panel Tree 節點。
///
/// 產品不得以任意 Flutter widget 擔任 app 主內容根節點；必須使用
/// [KlpPanelFrame] 或 Kallopis 提供的具名 Panel 排版元件。
abstract interface class KlpPanelLayout implements Widget {
  Widget buildPanelLayout(BuildContext context);
}
