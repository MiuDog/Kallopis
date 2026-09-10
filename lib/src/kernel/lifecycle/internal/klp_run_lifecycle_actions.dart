import 'klp_lifecycle_exception.dart';

/// 每個生命週期步驟都會執行；單一失敗保留原錯誤，多個失敗完整彙整。
void klpRunLifecycleActions(Iterable<void Function()> actions) {
	final issues = <({Object error, StackTrace stackTrace})>[];
	for (final action in actions) {
		try {
			action();
		}
		catch (error, stackTrace) {
			issues.add((error: error, stackTrace: stackTrace));
		}
	}
	if (issues.length == 1) Error.throwWithStackTrace(issues.single.error, issues.single.stackTrace);
	if (issues.isNotEmpty) throw KlpLifecycleException(issues);
}
