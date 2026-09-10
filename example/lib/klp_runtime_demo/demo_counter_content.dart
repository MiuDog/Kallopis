import 'package:kallopis/kallopis_declarative.dart';

/// 計數插槽只接受提供數值資料的節點，不接受任意內容。
abstract interface class DemoCounterContent implements KlpNode {

	int get value;
}
