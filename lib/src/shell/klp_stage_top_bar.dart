import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 位於 Workbench window header 中央 Stage 區域的檔案分頁與動作列。
///
/// 此列不屬於 Stage body。產品只注入檔案分頁與動作，不自行決定對齊。
class KlpStageTopBar extends StatelessWidget {
  const KlpStageTopBar({super.key, required this.tab, this.actions = const []});

  final Widget tab;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;
    final actionHeight = math.max(space.chromeTab, space.controlHeightXSmall);

    return Stack(
      children: [
        PositionedDirectional(start: 0, top: 0, bottom: 0, child: tab),
        if (actions.isNotEmpty)
          PositionedDirectional(
            end: 0,
            top: 0,
            height: actionHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < actions.length; index++) ...[
                  if (index > 0) SizedBox(width: space.tight),
                  actions[index],
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// 顯示目前 Stage 項目的單一檔案分頁。
///
/// 此元件只擁有分頁的視覺語言；檔名與目前項目的資料來源由產品提供。
class KlpStageTab extends StatelessWidget {
  const KlpStageTab({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = tokens.stageSurface;
    final radius = context.klp.buttonRadius;
		final connectionRadius = context.klp.shape.panel;

    return Material(
      color: context.klp.color.clear,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
			borderRadius: BorderRadiusDirectional.only(
				topStart: Radius.circular(radius),
				topEnd: Radius.circular(radius),
				bottomEnd: Radius.circular(connectionRadius),
			),
        ),
        child: KlpTokenOverride(
          colors: tokens.onBackground(background),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.klp.space.compact,
            ),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: SizedBox(
                height: context.klp.space.chromeTab,
                child: Center(
                  child: KlpText(
                    label,
                    role: KlpTextRole.code,
                    decoration: TextDecoration.none,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
