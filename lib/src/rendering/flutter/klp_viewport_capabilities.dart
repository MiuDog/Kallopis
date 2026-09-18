import 'package:flutter/widgets.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';

/// 平台能力只由應用宿主注入，renderer 不自行讀取另一個平台來源。
final class KlpViewportCapabilities extends InheritedWidget {
	final bool desktop;
	final bool nativeWindows;
	final String adaptiveMode;
	final List<bool Function()> backHandlers;
	final KlpEditingHostFailureSink onEditingHostFailure;
	const KlpViewportCapabilities({
		required this.desktop,
		required this.backHandlers,
		required this.onEditingHostFailure,
		required super.child,
		this.adaptiveMode = 'desktop',
		this.nativeWindows = false,
		super.key,
	});
	static KlpViewportCapabilities? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<KlpViewportCapabilities>();
	static bool allowsDesktop(BuildContext context) => context.dependOnInheritedWidgetOfExactType<KlpViewportCapabilities>()?.desktop ?? false;
	static String resolveMode(BuildContext context) => context.dependOnInheritedWidgetOfExactType<KlpViewportCapabilities>()?.adaptiveMode ?? 'desktop';
	@override
	bool updateShouldNotify(KlpViewportCapabilities oldWidget) =>
			desktop != oldWidget.desktop ||
			nativeWindows != oldWidget.nativeWindows ||
			adaptiveMode != oldWidget.adaptiveMode ||
			!identical(backHandlers, oldWidget.backHandlers) ||
			!identical(onEditingHostFailure, oldWidget.onEditingHostFailure);
}
