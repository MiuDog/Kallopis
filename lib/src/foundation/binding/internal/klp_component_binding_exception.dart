/// 資料 selector 失敗時保留原錯誤及來源，並標示放置與模板位置。
final class KlpComponentBindingException implements Exception {

	final String placementId;
	final String templatePath;
	final Object cause;
	final StackTrace stackTrace;

	const KlpComponentBindingException({
		required this.placementId,
		required this.templatePath,
		required this.cause,
		required this.stackTrace,
	});

	@override
	String toString() => 'KlpComponentBindingException($placementId, $templatePath): $cause';
}
