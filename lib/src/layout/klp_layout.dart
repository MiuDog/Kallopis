import 'package:flutter/widgets.dart';

import '../surface/klp_dashed_border.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';

/// 區域容器。包裝標題、主要內容與頁尾。
class KlpRegion extends StatelessWidget {
  const KlpRegion({
    super.key,
    required this.content,
    this.header,
    this.footer,
    this.tone = KlpSurfaceTone.base,
    this.padding,
  });

  final Widget? header;
  final Widget content;
  final Widget? footer;
  final KlpSurfaceTone tone;

  /// `null` 表示沿用 theme 的面板內距。內容不應該貼著面板邊緣——
  /// 傳 [EdgeInsets.zero] 才是刻意讓內容自己貼邊（例如內部自帶捲動區）。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: tone,
      radius: klp.shape.panel,
      padding: padding ?? EdgeInsets.all(klp.space.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          Expanded(child: content),
          ?footer,
        ],
      ),
    );
  }
}

/// 分割版面原語。支援左/中/右或左右分割，以及虛線分隔線。
class KlpSplitLayout extends StatelessWidget {
  const KlpSplitLayout({
    super.key,
    required this.leading,
    required this.trailing,
    this.center,
    this.leadingWidth,
    this.trailingWidth,
    this.gap,
    this.showDashedDivider = false,
  });

  final Widget leading;
  final Widget trailing;
  final Widget? center;
  final double? leadingWidth;
  final double? trailingWidth;
  final double? gap;
  final bool showDashedDivider;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final effectiveGap = gap ?? klp.space.base;
    final effectiveLeadingWidth =
        leadingWidth ?? klp.geometry.layout.primaryPaneWidth;

    Widget divider() => showDashedDivider
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: effectiveGap / 2),
            child: const KlpDashedDivider(vertical: true),
          )
        : SizedBox(width: effectiveGap);

    if (center != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: effectiveLeadingWidth, child: leading),
          divider(),
          Expanded(child: center!),
          divider(),
          SizedBox(
            width: trailingWidth ?? effectiveLeadingWidth,
            child: trailing,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: effectiveLeadingWidth, child: leading),
        divider(),
        Expanded(child: trailing),
      ],
    );
  }
}

/// 寬度可調節面板容器。
class KlpResizablePane extends StatelessWidget {
  const KlpResizablePane({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}

/// 拖曳調整寬度把手。
class KlpResizeHandle extends StatelessWidget {
  const KlpResizeHandle({
    super.key,
    required this.onDelta,
    this.onDragStart,
    this.onDragEnd,
    this.semanticLabel,
    this.width,
    this.enabled = true,
  });

  final ValueChanged<double> onDelta;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final String? semanticLabel;
  final double? width;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Semantics(
      label: semanticLabel,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: enabled ? (_) => onDragStart?.call() : null,
          onHorizontalDragUpdate: enabled
              ? (details) => onDelta(details.delta.dx)
              : null,
          onHorizontalDragEnd: enabled ? (_) => onDragEnd?.call() : null,
          onHorizontalDragCancel: enabled ? onDragEnd : null,
          child: SizedBox(
            width: width ?? klp.space.compact,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.klpColors.border,
                  borderRadius: BorderRadius.circular(klp.shape.stroke),
                ),
                child: SizedBox(
                  width: klp.space.hairline,
                  height: klp.space.loose - klp.space.tight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 具備主題捲軸樣式的單向捲動容器。
class KlpScrollViewport extends StatelessWidget {
  const KlpScrollViewport({
    super.key,
    required this.child,
    this.controller,
    this.padding,
  });

  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: padding,
      child: child,
    );
  }
}

/// 長清單虛擬化捲動檢視。
class KlpVirtualList extends StatelessWidget {
  const KlpVirtualList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

/// 格狀虛擬化捲動檢視。
class KlpVirtualGrid extends StatelessWidget {
  const KlpVirtualGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minimumItemWidth = 240,
    this.crossAxisCount,
    this.spacing,
    this.childAspectRatio = 1.0,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double minimumItemWidth;
  final int? crossAxisCount;
  final double? spacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count =
            crossAxisCount ??
            (constraints.maxWidth / minimumItemWidth).floor().clamp(
              1,
              itemCount == 0 ? 1 : itemCount,
            );

        return GridView.builder(
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: spacing ?? context.klp.space.base,
            crossAxisSpacing: spacing ?? context.klp.space.base,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

/// 浮層容器掛載點。
class KlpOverlayHost extends StatelessWidget {
  const KlpOverlayHost({super.key, required this.child, this.overlay});

  final Widget child;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}
