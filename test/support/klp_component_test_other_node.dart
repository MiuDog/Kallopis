import 'package:kallopis/kallopis_declarative.dart';

/// 定義識別相同但未具備該資料型別的負向案例。
final class KlpComponentTestOtherNode implements KlpNode {

	@override
	String get id => 'other';
	@override
	String get definitionId => 'fixture';
	@override
	Iterable<KlpNode> get children => const [];
}
