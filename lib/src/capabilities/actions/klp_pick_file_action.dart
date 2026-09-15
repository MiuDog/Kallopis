import 'klp_action.dart';

/// 由應用宿主執行選檔；consumer 只宣告限制與接收有效結果。
final class KlpPickFileAction implements KlpAction {

	final List<String> acceptedExtensions;
	final void Function(String path) onPicked;

	const KlpPickFileAction({this.acceptedExtensions = const [], required this.onPicked});
}
