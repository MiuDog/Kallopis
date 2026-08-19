import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_panel_header.dart';

/// 應用程式最外層：鋪滿 app 底色，並在頂端保留自訂視窗標題列的位置。
///
/// 它同時提供整個子樹所需的 `Material` 祖先。少了它，`MaterialApp` 會在每一段文字下方
/// 畫黃色雙底線——那是 Flutter 對「文字沒有 Material 祖先」的除錯提示。**由庫負責提供，
/// 因為消費者沒有理由知道 Kallopis 的哪些元件需要它。**
class KlpAppScreen extends StatelessWidget {
  const KlpAppScreen({super.key, required this.child, this.windowHeader});

  final Widget? windowHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = tokens.app;
    final surfaceTokens = tokens.onBackground(background);

    return Material(
      // transparency 只提供 Material 的能力，不畫底色也不加陰影——底色由下方的
      // ColoredBox 依 token 決定。
      type: MaterialType.transparency,
      child: ColoredBox(
        color: background,
        child: Theme(
          data: Theme.of(context).copyWith(
            extensions: [
              ...Theme.of(
                context,
              ).extensions.values.where((ext) => ext is! KlpThemeData),
              surfaceTokens,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ?windowHeader,
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class KlpAppWindowHeader extends StatelessWidget {
  const KlpAppWindowHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.klp.space.chromeHeader,
      child: KlpPanelHeader(
        title: title,
        titleRole: KlpTextRole.code,
        leading: leading,
        actions: actions,
      ),
    );
  }
}

enum KlpContentState { loading, ready, empty, error, permission }

/// 依可用寬度決定面板顯示與否的協調器。斷點來自版面常數，不隨風格改變。
class KlpResponsivePaneCoordinator extends StatelessWidget {
  const KlpResponsivePaneCoordinator({
    super.key,
    required this.wide,
    required this.compact,
    this.breakpoint = 960,
  });

  final Widget wide;
  final Widget compact;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth >= breakpoint ? wide : compact;
      },
    );
  }
}

class KlpPaneCollapseControl extends StatefulWidget {
  const KlpPaneCollapseControl({
    super.key,
    this.icon,
    this.label = '切換面板',
    required this.collapsed,
    required this.onToggle,
  });

  final String? icon;
  final String label;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  State<KlpPaneCollapseControl> createState() => _KlpPaneCollapseControlState();
}

class _KlpPaneCollapseControlState extends State<KlpPaneCollapseControl> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final effectiveIcon = widget.icon ?? KlpIcons.panelLeft;

    Widget button = SizedBox.square(
      dimension: klp.space.controlHeightSmall,
      child: Center(
        child: KlpIcon(
          effectiveIcon,
          size: klp.space.iconSmall,
          color: widget.collapsed ? tokens.textFaint : tokens.textMuted,
        ),
      ),
    );

    if (_hovered) {
      button = KlpDashedBorder(radius: klp.shape.control, child: button);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onToggle,
        child: Semantics(
          button: true,
          label: widget.label,
          expanded: !widget.collapsed,
          child: button,
        ),
      ),
    );
  }
}
