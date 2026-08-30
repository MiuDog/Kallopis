import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';

/// 舞台區：頂部 header、中央 content、底部選用的 status 列。
class KlpStageFrame extends StatelessWidget {
  const KlpStageFrame({
    super.key,
    required this.header,
    required this.content,
    this.status,
    this.padding,
  });

  final Widget header;
  final Widget content;
  final Widget? status;

  /// 內容與舞台區之間的內距。預設使用 Workbench 的語意緊湊間距。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = tokens.stageSurface;
    final surfaceTokens = tokens.onBackground(background);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
        child: KlpTokenOverride(
          colors: surfaceTokens,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: context.klp.space.chromeHeader,
                ),
                child: header,
              ),
              Expanded(
                child: Padding(
                  padding:
                      padding ??
                      EdgeInsets.all(
                        context.klp.geometry.layout.workbenchCompactSpacing,
                      ),
                  child: content,
                ),
              ),
              if (status != null)
                SizedBox(
                  height: context.klp.space.chromeStatusBar,
                  child: status!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
