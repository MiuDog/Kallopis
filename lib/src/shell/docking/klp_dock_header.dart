import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../controls/button/klp_icon_button.dart';
import '../../foundation/klp_icons.dart';
import '../../l10n/klp_localizations.dart';
import '../../overlay/klp_context_menu.dart';
import '../../overlay/klp_menu.dart';
import '../../theme/klp_theme.dart';
import 'klp_dock_panel.dart';
import '../panel/klp_panel_header.dart';

typedef KlpDockHeaderDragRegionBuilder = Widget Function(Widget child);

/// Dock Group 專用的緊湊 Header。
///
/// 左側區域可由 Layout 包成拖曳來源；右側 actions 是獨立 clickable 區域，
/// 因此操作按鈕不會誤觸 panel 拖曳。
class KlpDockHeader extends StatefulWidget {
  static const double extent = 32;

  const KlpDockHeader({
    super.key,
    required this.leading,
    this.actions = const [],
    this.dragRegionBuilder,
  });

  final Widget leading;
  final List<KlpDockHeaderAction> actions;
  final KlpDockHeaderDragRegionBuilder? dragRegionBuilder;

  @override
  State<KlpDockHeader> createState() => _KlpDockHeaderState();
}

class _KlpDockHeaderState extends State<KlpDockHeader> {
  final ScrollController _scrollController = ScrollController();
  final KlpContextMenuController _menuController = KlpContextMenuController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final delta = event.scrollDelta.dy != 0
        ? event.scrollDelta.dy
        : event.scrollDelta.dx;
    final nextOffset = (_scrollController.offset + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();

    _scrollController.jumpTo(nextOffset);
  }

  @override
  Widget build(BuildContext context) {
    final moreActionsLabel = KlpLocalizations.of(context).dockMoreActionsLabel;
    return SizedBox(
      height: KlpDockHeader.extent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final actionSlotExtent = context.klp.space.iconButton;
          final totalSlots = (constraints.maxWidth / actionSlotExtent).floor();
          final maxActionSlots = (totalSlots - 1).clamp(
            0,
            widget.actions.length,
          );
          final needsOverflow = widget.actions.length > maxActionSlots;
          final visibleCount = needsOverflow
              ? (maxActionSlots - 1).clamp(0, widget.actions.length)
              : widget.actions.length;
          final visibleActions = widget.actions
              .take(visibleCount)
              .toList(growable: false);
          final overflowActions = widget.actions
              .skip(visibleCount)
              .toList(growable: false);
          final leading = Listener(
            onPointerSignal: _handlePointerSignal,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: widget.leading,
            ),
          );
          return KlpPanelHeader(
            content: leading,
            dragRegionBuilder: widget.dragRegionBuilder,
            actions: [
              for (final action in visibleActions)
                KlpIconButton(
                  icon: action.icon,
                  label: action.label,
                  onPressed: action.enabled ? action.onPressed : null,
                  tone: KlpIconButtonTone.inline,
                ),
              if (overflowActions.isNotEmpty)
                Builder(
                  builder: (buttonContext) => KlpContextMenu(
                    controller: _menuController,
                    label: moreActionsLabel,
                    items: [
                      for (final action in overflowActions)
                        KlpMenuItemData(
                          icon: action.icon,
                          label: action.label,
                          enabled: action.enabled,
                          onPressed: action.onPressed,
                        ),
                    ],
                    child: KlpIconButton(
                      icon: KlpIcons.more,
                      label: moreActionsLabel,
                      tone: KlpIconButtonTone.inline,
                      onPressed: () {
                        final renderObject = buttonContext.findRenderObject();
                        if (renderObject is! RenderBox) return;

                        _menuController.openAt(
                          renderObject.localToGlobal(
                            Offset(0, renderObject.size.height),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
