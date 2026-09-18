/// 單次啟動時的限制快照；保留每個原始值與順序。
final class KlpFileSelectionRequest {

	final List<String> acceptedExtensions;

	KlpFileSelectionRequest({List<String> acceptedExtensions = const []}) : acceptedExtensions = List.unmodifiable(acceptedExtensions);
}

/// 套件內部的選檔能力；平台與檔案讀取不屬於此契約。
abstract interface class KlpFileSelectionPort {

	Future<KlpFileSelectionResult> select(KlpFileSelectionRequest request);
}

/// 選檔結果只攜帶路徑、取消或原始失敗，不建立另一份檔案權威。
sealed class KlpFileSelectionResult {

	const KlpFileSelectionResult();
}

/// 使用者已選取的原始路徑。
final class KlpFileSelected extends KlpFileSelectionResult {

	final String path;

	const KlpFileSelected(this.path);
}

/// 使用者取消選檔。
final class KlpFileSelectionCancelled extends KlpFileSelectionResult {

	const KlpFileSelectionCancelled();
}

/// 保留平台回報的錯誤及堆疊身分。
final class KlpFileSelectionFailed extends KlpFileSelectionResult {

	final Object error;
	final StackTrace stackTrace;

	const KlpFileSelectionFailed(this.error, this.stackTrace);
}
