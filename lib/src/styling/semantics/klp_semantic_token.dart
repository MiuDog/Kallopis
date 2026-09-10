import '../../kernel/diagnostics/klp_contract_error.dart';
import '../primitives/klp_style_value.dart';
import '../references/klp_style_ref.dart';
import 'klp_semantic_key.dart';

/// 元件定義期提供用途參照；公開只授權引用，不授權覆寫。
final class KlpSemanticToken<T extends KlpStyleValue> {

	final KlpSemanticKey<T> key;
	final KlpStyleRef<T> reference;
	final bool isPublic;

	KlpSemanticToken(this.key, this.reference, {this.isPublic = false}) {
		// 泛型可提升到共同基底，仍須核對封閉量值種類。
		if (!identical(key.kind, reference.kind)) {
			throw KlpContractError('semantic_kind_mismatch', key.path);
		}
	}
}
