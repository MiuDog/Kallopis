import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controls/klp_text_field.dart';
import '../editor/klp_command_menu.dart';
import '../feedback/klp_toast.dart';
import '../overlay/klp_menu.dart';
import '../surface/klp_stroke.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_icon.dart';
import 'klp_icons.dart';
import 'klp_inline_code.dart';

class KlpAvatar extends StatelessWidget {
  const KlpAvatar({
    super.key,
    required this.label,
    this.image,
    this.size,
    this.semanticLabel,
  });

  final String label;
  final ImageProvider? image;

  /// `null` 表示沿用 theme 的大型控制項高度。
  final double? size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      image: image != null,
      child: Container(
        width: size ?? context.klp.space.controlHeightLarge,
        height: size ?? context.klp.space.controlHeightLarge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.klpColors.surfaceMuted,
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(context.klp.shape.card),
        ),
        child: image == null
            ? KlpText(label, role: KlpTextRole.label)
            : const SizedBox.shrink(),
      ),
    );
  }
}

@immutable
class KlpAvatarData {
  const KlpAvatarData({required this.id, required this.label, this.image});

  final String id;
  final String label;
  final ImageProvider? image;
}

class KlpAvatarGroup extends StatelessWidget {
  const KlpAvatarGroup({
    super.key,
    required this.avatars,
    this.maximumVisible = 4,
  });

  final List<KlpAvatarData> avatars;
  final int maximumVisible;

  @override
  Widget build(BuildContext context) {
    final visible = avatars.take(maximumVisible).toList();
    final hiddenCount = avatars.length - visible.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final avatar in visible) ...[
          KlpAvatar(
            label: avatar.label,
            image: avatar.image,
            size: context.klp.space.avatarSmall,
          ),
          SizedBox(width: context.klp.space.tight),
        ],
        if (hiddenCount > 0)
          KlpAvatar(
            label: '+$hiddenCount',
            size: context.klp.space.avatarSmall,
          ),
      ],
    );
  }
}

/// 狀態指示樣式：圓點 (dot)、雙色分割圓點 (splitDot)、核取勾 (check)、叉號 (cross)、等待重試 (waiting)、空心圓 (circle)。
enum KlpStatusKind {
  /// 實心圓點。
  dot,

  /// 雙色分割圓點（如藍/青色運行中）。
  splitDot,

  /// 核取勾標記 (✓)。
  check,

  /// 叉號標記 (✕)。
  cross,

  /// 等待／旋轉標記 (↻)。
  waiting,

  /// 空心圓標記 (○)。
  circle,
}

/// 狀態指示標記與文字。
class KlpStatusIndicator extends StatelessWidget {
  const KlpStatusIndicator({
    super.key,
    required this.label,
    this.active = true,
    this.kind = KlpStatusKind.dot,
    this.color,
  });

  /// 狀態標籤文字。
  final String label;

  /// 是否處於啟用或活動狀態。
  final bool active;

  /// 指示圖示種類。
  final KlpStatusKind kind;

  /// 自訂覆蓋顏色。
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final defaultColor = switch (kind) {
      KlpStatusKind.splitDot => tokens.info,
      KlpStatusKind.check => tokens.success,
      KlpStatusKind.cross => tokens.danger,
      KlpStatusKind.waiting => tokens.warning,
      KlpStatusKind.circle => tokens.textMuted,
      KlpStatusKind.dot => active ? tokens.success : tokens.textFaint,
    };
    final effectiveColor = color ?? defaultColor;

    final Widget iconWidget = switch (kind) {
      KlpStatusKind.splitDot => KlpIcon(
        KlpIcons.splitCircle,
        size: context.klp.space.iconTiny,
        color: effectiveColor,
      ),
      KlpStatusKind.check => KlpIcon(
        KlpIcons.check,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.cross => KlpIcon(
        KlpIcons.x,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.waiting => KlpIcon(
        KlpIcons.refresh,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.circle => KlpIcon(
        KlpIcons.circle,
        size: context.klp.space.iconTiny,
        color: effectiveColor,
      ),
      KlpStatusKind.dot => Container(
        width: context.klp.space.indicatorDot,
        height: context.klp.space.indicatorDot,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(context.klp.shape.pill),
        ),
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(offset: const Offset(0, 1), child: iconWidget),
        SizedBox(width: context.klp.space.tight),
        KlpText(
          label.toUpperCase(),
          role: KlpTextRole.label,
          color: effectiveColor,
        ),
      ],
    );
  }
}

@immutable
class KlpRichTextSpan {
  const KlpRichTextSpan({required this.text, this.strong = false, this.color});

  final String text;
  final bool strong;
  final Color? color;
}

enum KlpRichTextKind {
  text,
  strong,
  emphasis,
  strike,
  code,
  link,
  mention,
  lineBreak,
}

@immutable
class KlpRichTextNode {
  const KlpRichTextNode({
    this.kind = KlpRichTextKind.text,
    this.text,
    this.href,
    this.label,
    this.missing = false,
    this.unsafe = false,
    this.children = const [],
  });

  final KlpRichTextKind kind;
  final String? text;
  final String? href;
  final String? label;
  final bool missing;
  final bool unsafe;
  final List<KlpRichTextNode> children;
}

class KlpRichText extends StatelessWidget {
  const KlpRichText({
    super.key,
    this.spans = const [],
    this.nodes = const [],
    this.selectable = false,
    this.onOpenLink,
    this.onOpenMention,
  });

  final List<KlpRichTextSpan> spans;
  final List<KlpRichTextNode> nodes;
  final bool selectable;
  final ValueChanged<String>? onOpenLink;
  final ValueChanged<String>? onOpenMention;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    final content = TextSpan(
      children: nodes.isEmpty
          ? [
              for (final span in spans)
                TextSpan(
                  text: span.text,
                  style: TextStyle(
                    color: KlpTextStyles.colorFor(
                      tokens,
                      role: KlpTextRole.body,
                      requestedColor: span.color,
                    ),
                    fontWeight: span.strong
                        ? context.klp.type.medium
                        : context.klp.type.regular,
                  ),
                ),
            ]
          : [for (final node in nodes) _spanFor(context, node)],
    );

    final style = TextStyle(
      color: KlpTextStyles.colorFor(tokens, role: KlpTextRole.body),
      fontSize: context.klp.type.body,
      height: context.klp.type.bodyLeading,
      fontFamily: context.klp.type.uiFamily,
      fontFamilyFallback: context.klp.type.fallbackFor(
        context.klp.type.uiFamily,
      ),
    );

    if (selectable) return SelectableText.rich(content, style: style);

    return Text.rich(content, style: style);
  }

  InlineSpan _spanFor(BuildContext context, KlpRichTextNode node) {
    final tokens = context.klpColors;
    final children = node.children.isEmpty
        ? null
        : [for (final child in node.children) _spanFor(context, child)];

    if (node.kind == KlpRichTextKind.lineBreak) {
      return const TextSpan(text: '\n');
    }

    if (node.kind == KlpRichTextKind.code) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: KlpInlineCode(
          node.text ?? '',
          color: node.unsafe ? tokens.danger : null,
        ),
      );
    }

    if (node.kind == KlpRichTextKind.mention) {
      final label = node.label ?? node.text ?? '';

      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onOpenMention == null ? null : () => onOpenMention!(label),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: context.klp.space.tight),
            decoration: BoxDecoration(
              color: node.missing
                  ? tokens.danger.withValues(
                      alpha: context.klp.surface.statusFillOpacity,
                    )
                  : tokens.surfaceInset,
              borderRadius: BorderRadius.circular(context.klp.shape.control),
            ),
            child: KlpText(
              '@$label${node.missing ? ' (missing)' : ''}',
              role: KlpTextRole.code,
              color: node.missing ? tokens.danger : tokens.text,
            ),
          ),
        ),
      );
    }

    final isLink = node.kind == KlpRichTextKind.link;
    final href = node.href ?? '';
    return TextSpan(
      text: node.text,
      children: children,
      recognizer: isLink && onOpenLink != null
          ? (TapGestureRecognizer()..onTap = () => onOpenLink!(href))
          : null,
      style: TextStyle(
        color: KlpTextStyles.colorFor(
          tokens,
          role: KlpTextRole.body,
          tone: isLink ? KlpTextTone.primary : KlpTextTone.automatic,
          requestedColor: node.unsafe ? tokens.danger : null,
        ),
        fontWeight: node.kind == KlpRichTextKind.strong
            ? context.klp.type.medium
            : context.klp.type.regular,
        fontStyle: node.kind == KlpRichTextKind.emphasis
            ? FontStyle.italic
            : FontStyle.normal,
        decoration: node.kind == KlpRichTextKind.strike
            ? TextDecoration.lineThrough
            : isLink
            ? TextDecoration.underline
            : null,
        decorationStyle: node.unsafe ? TextDecorationStyle.wavy : null,
      ),
    );
  }
}

class KlpSegmentedProgress extends StatelessWidget {
  const KlpSegmentedProgress({
    super.key,
    required this.value,
    required this.segments,
  });

  final double value;
  final int segments;

  @override
  Widget build(BuildContext context) {
    final completed = (value.clamp(0, 1) * segments).ceil();

    return Row(
      children: [
        for (var index = 0; index < segments; index++) ...[
          Expanded(
            child: Container(
              height: context.klp.space.compact,
              decoration: BoxDecoration(
                color: index < completed
                    ? context.klpColors.info
                    : context.klpColors.surfaceInset,
                borderRadius: BorderRadius.circular(context.klp.shape.control),
              ),
            ),
          ),
          if (index < segments - 1) SizedBox(width: context.klp.space.tight),
        ],
      ],
    );
  }
}

class KlpBlock extends StatelessWidget {
  const KlpBlock({
    super.key,
    required this.child,
    this.selected = false,
    this.padding,
  });

  final Widget child;
  final bool selected;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      border: selected ? Border.all(color: context.klpColors.textMuted) : null,
      radius: context.klp.shape.control,
      padding: padding ?? EdgeInsets.all(context.klp.space.base),
      child: child,
    );
  }
}

class KlpBlockCanvas extends StatelessWidget {
  const KlpBlockCanvas({
    super.key,
    required this.children,
    this.constrained = false,
  });

  final List<Widget> children;
  final bool constrained;

  @override
  Widget build(BuildContext context) {
    final canvas = KlpSurface(
      tone: KlpSurfaceTone.inset,
      child: Stack(children: children),
    );

    return constrained ? canvas : InteractiveViewer(child: canvas);
  }
}

class KlpPopover extends StatelessWidget {
  const KlpPopover({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: padding ?? EdgeInsets.all(context.klp.space.compact),
      child: child,
    );
  }
}

class KlpDropTarget extends StatelessWidget {
  const KlpDropTarget({super.key, required this.child, required this.active});

  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final content = KlpSurface(
      tone: active ? KlpSurfaceTone.muted : KlpSurfaceTone.transparent,
      child: child,
    );

    return active
        ? KlpStrokeFrame(role: KlpStrokeRole.latent, child: content)
        : content;
  }
}

class KlpDragPreview extends StatelessWidget {
  const KlpDragPreview({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.82,
      child: KlpSurface(
        tone: KlpSurfaceTone.component,
        padding: EdgeInsets.all(context.klp.space.compact),
        child: child,
      ),
    );
  }
}

class KlpDropIndicator extends StatelessWidget {
  const KlpDropIndicator({super.key, this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? context.klp.shape.stroke : double.infinity,
      height: vertical ? double.infinity : context.klp.shape.stroke,
      decoration: BoxDecoration(
        color: context.klpColors.interaction,
        borderRadius: BorderRadius.circular(context.klp.shape.pill),
      ),
    );
  }
}

class KlpSortControl extends StatelessWidget {
  const KlpSortControl({
    super.key,
    required this.label,
    required this.ascending,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool ascending;
  final VoidCallback? onPressed;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(label, role: KlpTextRole.caption),
          if (icon != null) ...[
            SizedBox(width: context.klp.space.tight),
            KlpIcon(icon!, size: context.klp.space.iconSmall),
          ],
        ],
      ),
    );
  }
}

class KlpThemeToggle extends StatelessWidget {
  const KlpThemeToggle({
    super.key,
    required this.label,
    required this.dark,
    required this.onChanged,
  });

  final String label;
  final bool dark;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!dark),
      child: KlpSurface(
        tone: dark ? KlpSurfaceTone.muted : KlpSurfaceTone.inset,
        padding: EdgeInsets.all(context.klp.space.compact),
        child: KlpText(label, role: KlpTextRole.caption),
      ),
    );
  }
}

typedef KlpSearchField = KlpTextField;
typedef KlpToastRegion = KlpToastStack;
typedef KlpContextMenu = KlpMenu;
typedef KlpCommandPalette = KlpCommandMenu;
