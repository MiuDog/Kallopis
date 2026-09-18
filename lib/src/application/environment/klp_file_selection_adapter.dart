import 'package:file_selector/file_selector.dart';
import 'package:kallopis/src/capabilities/files/klp_file_selection.dart';

/// 應用擁有的唯一平台選檔接點，不保留檔案或作業狀態。
final class KlpFileSelectionAdapter implements KlpFileSelectionPort {

	const KlpFileSelectionAdapter();

	@override
	Future<KlpFileSelectionResult> select(KlpFileSelectionRequest request) async {
		try {
			final group = request.acceptedExtensions.isEmpty ? null : XTypeGroup(label: 'assets', extensions: request.acceptedExtensions);

			// 平台只回傳使用者選取的路徑，正文與檔案讀取仍由既有擁有者掌管。
			final file = await openFile(acceptedTypeGroups: group == null ? const [] : [group]);
			if (file == null) return const KlpFileSelectionCancelled();

			return KlpFileSelected(file.path);
		}
		catch (error, stackTrace) {
			return KlpFileSelectionFailed(error, stackTrace);
		}
	}
}
