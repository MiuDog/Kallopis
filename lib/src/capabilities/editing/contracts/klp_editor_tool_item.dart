import 'klp_editor_mode_item.dart';

/// 工具接受的指標種類；不攜帶平台事件或取代輸入路由。
enum KlpEditorPointerKind { mouse, touch, stylus }

/// 工具只描述可驗證處理通道；不攜帶 Widget、樣式或原生 handler。
final class KlpEditorToolItem {
	final String id;
	final String label;
	final String modeId;
	final KlpEditorModeAvailability availability;
	final String? disabledReason;
	final Set<KlpEditorPointerKind> pointerKinds;
	final bool acceptsTextInput;
	final bool controlsViewport;
	final bool commitsInk;

	KlpEditorToolItem({
		required this.id,
		required this.label,
		required this.modeId,
		required this.availability,
		required Set<KlpEditorPointerKind> pointerKinds,
		required this.acceptsTextInput,
		required this.controlsViewport,
		required this.commitsInk,
		this.disabledReason,
	}) : pointerKinds = Set.unmodifiable(pointerKinds) {
		if (id.trim().isEmpty || label.trim().isEmpty || modeId.trim().isEmpty) throw ArgumentError('Tool identity and label must not be blank');
		if (availability == KlpEditorModeAvailability.enabled && disabledReason != null) throw ArgumentError('Enabled tools cannot carry a disabled reason');
		if (availability == KlpEditorModeAvailability.disabled && (disabledReason?.trim().isEmpty ?? true)) throw ArgumentError('Disabled tools require a reason');
		final channels = [acceptsTextInput, controlsViewport, commitsInk].where((value) => value).length;
		if (channels != 1) throw ArgumentError('Each editor tool requires exactly one input channel');
		if ((controlsViewport || commitsInk) && this.pointerKinds.isEmpty) throw ArgumentError('Pointer tools must declare their supported pointer kinds');
	}

	bool get enabled => availability == KlpEditorModeAvailability.enabled;
}
