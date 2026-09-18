import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_endpoint.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';

/// 提交測試的核心端點固定在段首；不從 byte 位移猜測字素。
KlpEditingProjection editingFixture(KlpEditingTextWindow window) => KlpEditingProjection(
	stamp: window.stamp,
	anchor: KlpEditingEndpoint(window.blockId, 0, KlpEditingAffinity.upstream),
	focus: KlpEditingEndpoint(window.blockId, 0, KlpEditingAffinity.downstream),
	blockSelection: false,
	window: window,
);
