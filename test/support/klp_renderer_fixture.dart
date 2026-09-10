import 'package:flutter/widgets.dart';
import 'package:kallopis/src/capabilities/state/klp_state.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_choice_style.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_renderer.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

/// 測試只供應任意有效已解析值，不宣告正式預設風格。
KlpBoundText klpRendererText(String text, {double size = 14}) {
	final style = KlpBoundTextStyle(
		color: KlpColor(240, 240, 240),
		fontFamily: KlpFontFamily('Test'),
		fontSize: KlpFontSize(size),
		fontWeight: KlpFontWeight(450),
		lineHeight: KlpLineHeight(1),
		letterSpacing: KlpLetterSpacing(0),
	);
	return KlpBoundText(text, style);
}

KlpBoundChoice klpRendererChoice({
	required KlpPlacementId id,
	required KlpState<KlpPlacementId?> selection,
	void Function()? onActivate,
	int channel = 20,
}) {
	final style = KlpBoundChoiceStyle(
		background: KlpColor(channel, channel, channel),
		selectedBackground: KlpColor(60, 60, 60),
		focusColor: KlpColor(200, 200, 200),
		extent: KlpDistance(48),
		radius: KlpRadius(4),
		focusWidth: KlpStrokeWidth(1),
	);
	return KlpBoundChoice(
		id: id,
		label: 'Action ${id.localId}',
		selection: selection,
		onActivate: onActivate,
		child: klpRendererText(id.localId),
		style: style,
	);
}

Widget klpRendererHost(KlpBoundTemplate content) {
	final renderer = Center(child: KlpFlutterRenderer(content: content));
	return WidgetsApp(color: const Color(0xFF000000), builder: (_, _) => renderer);
}
