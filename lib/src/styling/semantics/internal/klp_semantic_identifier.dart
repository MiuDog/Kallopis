import '../../../kernel/diagnostics/klp_contract_error.dart';
import '../../../kernel/identity/internal/klp_identifier.dart';

/// 識別不可包含顯示路徑的分隔符或隱藏空白，不默默正規化輸入。
void requireSemanticIdentifier(String value, String path) {
	if (value.trim().isEmpty) throw KlpContractError('empty_id', path);
	if (!isKlpIdentifier(value)) {
		throw KlpContractError('invalid_semantic_identifier', '$path=$value');
	}
}
