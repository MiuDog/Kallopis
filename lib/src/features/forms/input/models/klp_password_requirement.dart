part of '../klp_password_field.dart';

/// 密碼規則要求項。包含檢核描述與是否滿足之狀態。
@immutable
class KlpPasswordRequirement {
	const KlpPasswordRequirement({
		required this.label,
		required this.satisfied,
	});

	final String label;
	final bool satisfied;
}
