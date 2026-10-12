part of '../klp_settings_layout.dart';

/// Settings modal 的桌面框架；尺寸、置中與透明 Dialog chrome 全由 Kallopis 管理。
class KlpSettingsDialog extends StatelessWidget {
  const KlpSettingsDialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final screen = MediaQuery.sizeOf(context);
    final inset = klp.space.section;
    final width = math.min(
      klp.geometry.layout.settingsDialogMaximumWidth,
      math.max(0.0, screen.width - inset * 2),
    );
    final height = math.min(
      klp.geometry.layout.settingsDialogMaximumHeight,
      math.max(0.0, screen.height - inset * 2),
    );

    return KlpModalFrame(
      insets: KlpBoxInsets.uniform(inset),
      child: KlpBox(
        key: const ValueKey('klp-settings-dialog-frame'),
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
