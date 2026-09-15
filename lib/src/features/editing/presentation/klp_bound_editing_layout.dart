part of 'klp_editing_presentation.dart';

/// renderer 可用的內部重排面；唯讀來源也能採用 Kallopis style 與 viewport。
abstract interface class KlpBoundEditingLayout {
	KlpEditingDrawing layout(KlpEditingLayout layout);
}
