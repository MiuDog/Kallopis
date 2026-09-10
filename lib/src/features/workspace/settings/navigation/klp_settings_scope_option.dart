part of '../klp_settings_navigation.dart';

/// Settings 頂部 scope 切換器的產品中立資料。
@immutable
class KlpSettingsScopeOption {
	const KlpSettingsScopeOption({required this.label, required this.icon});

	final String label;
	final KlpIconData icon;
}
