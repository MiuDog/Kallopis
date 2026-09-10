/// 生命週期中多個步驟失敗時，保留每個原因與原始堆疊。
final class KlpLifecycleException implements Exception {

	final List<({Object error, StackTrace stackTrace})> issues;

	KlpLifecycleException(Iterable<({Object error, StackTrace stackTrace})> issues) : issues = List.unmodifiable(issues);

	@override
	String toString() => 'KlpLifecycleException(issues: ${issues.length})';
}
