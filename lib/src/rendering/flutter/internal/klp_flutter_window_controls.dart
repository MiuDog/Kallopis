import 'package:flutter/material.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_action.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_controls.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_controls_geometry.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_controls_style.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme_data.dart';
import 'klp_flutter_values.dart';

/// 原生 Windows 視窗操作，沿用 runner 通道並同步最大化狀態。
final class KlpFlutterWindowControls extends StatefulWidget {
	final KlpBoundControlStyle style;
	const KlpFlutterWindowControls({required this.style, super.key});
	@override
	State<KlpFlutterWindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<KlpFlutterWindowControls> with WidgetsBindingObserver {
	bool _maximized = false;
	int _generation = 0;
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_refresh();
	}
	Future<void> _refresh() async {
		final generation = ++_generation;
		final value = await KlpWindowAction.checkIsMaximized();
		if (mounted && generation == _generation && value != _maximized) setState(() => _maximized = value);
	}
	Future<void> _toggle() async {
		await KlpWindowAction.toggleMaximize();
		if (mounted) await _refresh();
	}
	@override
	void didChangeMetrics() { _refresh(); }
	@override
	void didChangeAppLifecycleState(AppLifecycleState state) {
		if (state == AppLifecycleState.resumed) _refresh();
	}
	@override
	void dispose() {
		_generation++;
		WidgetsBinding.instance.removeObserver(this);
		super.dispose();
	}
	@override
	Widget build(BuildContext context) {
		final foreground = klpFlutterColor(widget.style.text.color);
		final background = klpFlutterColor(widget.style.background);
		final dark = background.computeLuminance() < foreground.computeLuminance();
		final colors = (dark ? KlpThemeData.dark : KlpThemeData.light).copyWith(
			text: foreground,
			textMuted: foreground,
			component: background,
		);
		// 使用者指定沿用舊版視窗控制；橋接僅存在於庫內，不公開舊 theme。
		return Localizations.override(
			context: context,
			delegates: const [DefaultMaterialLocalizations.delegate],
			child: Theme(
				data: ThemeData(
					brightness: dark ? Brightness.dark : Brightness.light,
					extensions: [colors],
					fontFamily: widget.style.text.fontFamily.family,
				),
				child: KlpWindowControls(
					style: KlpWindowControlsStyle.windows,
					geometry: KlpWindowControlsGeometry(extent: widget.style.density.windowControl),
					isMaximized: _maximized,
					onMinimize: KlpWindowAction.minimize,
					onToggleMaximize: _toggle,
					onClose: KlpWindowAction.close,
				),
			),
		);
	}
}
