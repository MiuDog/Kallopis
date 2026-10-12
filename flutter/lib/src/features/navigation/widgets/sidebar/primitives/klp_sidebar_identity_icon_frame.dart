part of '../klp_sidebar_identity_header.dart';

/// Workspace identity 圖示框的 Flutter 視覺 primitive 邊界。
class _KlpSidebarIdentityIconFrame extends StatelessWidget {
  const _KlpSidebarIdentityIconFrame({required this.icon});

  final KlpIconData icon;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.accentSoft,
      radius: klp.shape.control,
      padding: EdgeInsets.zero,
      child: SizedBox.square(
        dimension: klp.space.avatarSmall,
        child: Center(child: KlpIcon(icon, size: klp.space.iconGlyph)),
      ),
    );
  }
}
