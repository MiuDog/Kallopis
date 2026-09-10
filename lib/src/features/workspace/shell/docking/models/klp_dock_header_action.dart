part of '../klp_dock_panel.dart';

/// Dock Header 右側的產品動作描述。
@immutable
class KlpDockHeaderAction {
	final KlpIconData icon;
	final String label;
	final VoidCallback onPressed;
	final bool enabled;

	const KlpDockHeaderAction({
		required this.icon,
		required this.label,
		required this.onPressed,
		this.enabled = true,
	});
}
