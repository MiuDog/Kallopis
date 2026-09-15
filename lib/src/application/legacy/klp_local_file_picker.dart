import 'package:kallopis/src/capabilities/files/klp_file_selection.dart';
import 'package:kallopis/src/application/environment/klp_file_selection_adapter.dart';

/// 舊零宿主選檔相容契約；現行宣告式應用使用 KlpPickFileAction。
final class KlpLocalFilePicker {

	final List<String> acceptedExtensions;
	final void Function(String path) onPicked;

	const KlpLocalFilePicker({this.acceptedExtensions = const [], required this.onPicked});

	Future<void> pick() async {
		final request = KlpFileSelectionRequest(acceptedExtensions: acceptedExtensions);
		final result = await const KlpFileSelectionAdapter().select(request);
		switch (result) {
			case KlpFileSelected(:final path):
				onPicked(path);
			case KlpFileSelectionCancelled():
				return;

			case KlpFileSelectionFailed(:final error, :final stackTrace):
				Error.throwWithStackTrace(error, stackTrace);
		}
	}
}
