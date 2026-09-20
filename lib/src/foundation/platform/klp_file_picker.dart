import 'package:file_selector/file_selector.dart';

/// 由產品直接呼叫的本機單檔選取服務。
final class KlpFilePicker {
	final List<String> acceptedExtensions;

	const KlpFilePicker({this.acceptedExtensions = const []});

	Future<String?> pick() async {
		final group = acceptedExtensions.isEmpty
			? null
			: XTypeGroup(label: 'files', extensions: acceptedExtensions);
		final file = await openFile(
			acceptedTypeGroups: group == null ? const [] : [group],
		);
		return file?.path;
	}
}
