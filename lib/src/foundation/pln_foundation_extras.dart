import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controls/pln_text_field.dart';
import '../editor/pln_command_menu.dart';
import '../feedback/pln_toast.dart';
import '../overlay/pln_menu.dart';
import '../surface/pln_stroke.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'pln_icon.dart';
import 'pln_metrics.dart';

class PlnAvatar extends StatelessWidget {
  const PlnAvatar({
    super.key,
    required this.label,
    this.image,
    this.size = PlnSize.controlLarge,
    this.semanticLabel,
  });

  final String label;
  final ImageProvider? image;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      image: image != null,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.plnTheme.surfaceMuted,
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(PlnRadius.card),
        ),
        child: image == null
            ? PlnText(label, role: PlnTextRole.label)
            : const SizedBox.shrink(),
      ),
    );
  }
}

@immutable
class PlnAvatarData {
  const PlnAvatarData({required this.id, required this.label, this.image});

  final String id;
  final String label;
  final ImageProvider? image;
}

class PlnAvatarGroup extends StatelessWidget {
  const PlnAvatarGroup({
    super.key,
    required this.avatars,
    this.maximumVisible = 4,
  });

  final List<PlnAvatarData> avatars;
  final int maximumVisible;

  @override
  Widget build(BuildContext context) {
    final visible = avatars.take(maximumVisible).toList();
    final hiddenCount = avatars.length - visible.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final avatar in visible) ...[
          PlnAvatar(label: avatar.label, image: avatar.image, size: 28),
          const SizedBox(width: PlnSpace.xs),
        ],
        if (hiddenCount > 0) PlnAvatar(label: '+$hiddenCount', size: 28),
      ],
    );
  }
}

class PlnStatusIndicator extends StatelessWidget {
  const PlnStatusIndicator({
    super.key,
    required this.label,
    required this.active,
    this.color,
  });

  final String label;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ??
        (active ? context.plnTheme.success : context.plnTheme.textFaint);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: BorderRadius.circular(PlnRadius.full),
          ),
        ),
        const SizedBox(width: PlnSpace.xs),
        PlnText(label, role: PlnTextRole.label, color: effectiveColor),
      ],
    );
  }
}

@immutable
class PlnRichTextSpan {
  const PlnRichTextSpan({required this.text, this.strong = false, this.color});

  final String text;
  final bool strong;
  final Color? color;
}

enum PlnRichTextKind {
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
class PlnRichTextNode {
  const PlnRichTextNode({
    this.kind = PlnRichTextKind.text,
    this.text,
    this.href,
    this.label,
    this.missing = false,
    this.unsafe = false,
    this.children = const [],
  });

  final PlnRichTextKind kind;
  final String? text;
  final String? href;
  final String? label;
  final bool missing;
  final bool unsafe;
  final List<PlnRichTextNode> children;
}

class PlnRichText extends StatelessWidget {
  const PlnRichText({
    super.key,
    this.spans = const [],
    this.nodes = const [],
    this.selectable = false,
    this.onOpenLink,
    this.onOpenMention,
  });

  final List<PlnRichTextSpan> spans;
  final List<PlnRichTextNode> nodes;
  final bool selectable;
  final ValueChanged<String>? onOpenLink;
  final ValueChanged<String>? onOpenMention;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    final content = TextSpan(
      children: nodes.isEmpty
          ? [
              for (final span in spans)
                TextSpan(
                  text: span.text,
                  style: TextStyle(
                    color: PlnTextStyles.colorFor(
                      tokens,
                      role: PlnTextRole.body,
                      requestedColor: span.color,
                    ),
                    fontWeight: span.strong
                        ? PlnTypography.semibold
                        : PlnTypography.regular,
                  ),
                ),
            ]
          : [for (final node in nodes) _spanFor(context, node)],
    );

    final style = TextStyle(
      color: PlnTextStyles.colorFor(tokens, role: PlnTextRole.body),
      fontSize: PlnTypography.body,
      height: PlnTypography.bodyLineHeight,
      fontFamily: PlnTypography.uiFamily,
      fontFamilyFallback: PlnTypography.uiFallback,
    );

    if (selectable) return SelectableText.rich(content, style: style);

    return Text.rich(content, style: style);
  }

  InlineSpan _spanFor(BuildContext context, PlnRichTextNode node) {
    final tokens = context.plnTheme;
    final children = node.children.isEmpty
        ? null
        : [for (final child in node.children) _spanFor(context, child)];

    if (node.kind == PlnRichTextKind.lineBreak) {
      return const TextSpan(text: '\n');
    }

    if (node.kind == PlnRichTextKind.mention) {
      final label = node.label ?? node.text ?? '';

      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onOpenMention == null ? null : () => onOpenMention!(label),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: PlnSpace.xs),
            decoration: BoxDecoration(
              color: node.missing
                  ? tokens.danger.withValues(alpha: 0.16)
                  : tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(PlnRadius.sm),
            ),
            child: PlnText(
              '@$label${node.missing ? ' (missing)' : ''}',
              role: PlnTextRole.code,
              color: node.missing ? tokens.danger : tokens.text,
            ),
          ),
        ),
      );
    }

    final isLink = node.kind == PlnRichTextKind.link;
    final href = node.href ?? '';
    return TextSpan(
      text: node.text,
      children: children,
      recognizer: isLink && onOpenLink != null
          ? (TapGestureRecognizer()..onTap = () => onOpenLink!(href))
          : null,
      style: TextStyle(
        color: PlnTextStyles.colorFor(
          tokens,
          role: PlnTextRole.body,
          tone: isLink ? PlnTextTone.primary : PlnTextTone.automatic,
          requestedColor: node.unsafe ? tokens.danger : null,
        ),
        fontWeight: node.kind == PlnRichTextKind.strong
            ? PlnTypography.semibold
            : PlnTypography.regular,
        fontStyle: node.kind == PlnRichTextKind.emphasis
            ? FontStyle.italic
            : FontStyle.normal,
        fontFamily: node.kind == PlnRichTextKind.code
            ? PlnTypography.monoFamily
            : null,
        backgroundColor: node.kind == PlnRichTextKind.code
            ? tokens.surfaceMuted
            : null,
        decoration: node.kind == PlnRichTextKind.strike
            ? TextDecoration.lineThrough
            : isLink
            ? TextDecoration.underline
            : null,
        decorationStyle: node.unsafe ? TextDecorationStyle.wavy : null,
      ),
    );
  }
}

class PlnSegmentedProgress extends StatelessWidget {
  const PlnSegmentedProgress({
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
              height: PlnSpace.sm,
              decoration: BoxDecoration(
                color: index < completed
                    ? context.plnTheme.info
                    : context.plnTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(PlnRadius.control),
              ),
            ),
          ),
          if (index < segments - 1) const SizedBox(width: PlnSpace.xs),
        ],
      ],
    );
  }
}

class PlnBlock extends StatelessWidget {
  const PlnBlock({
    super.key,
    required this.child,
    this.selected = false,
    this.padding = const EdgeInsets.all(PlnSpace.md),
  });

  final Widget child;
  final bool selected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = PlnSurface(
      tone: selected ? PlnSurfaceTone.muted : PlnSurfaceTone.component,
      radius: PlnRadius.sm,
      padding: padding,
      child: child,
    );

    return content;
  }
}

class PlnBlockCanvas extends StatelessWidget {
  const PlnBlockCanvas({
    super.key,
    required this.children,
    this.constrained = false,
  });

  final List<Widget> children;
  final bool constrained;

  @override
  Widget build(BuildContext context) {
    final canvas = PlnSurface(
      tone: PlnSurfaceTone.inset,
      child: Stack(children: children),
    );

    return constrained ? canvas : InteractiveViewer(child: canvas);
  }
}

class PlnPopover extends StatelessWidget {
  const PlnPopover({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: padding ?? const EdgeInsets.all(PlnSpace.sm),
      child: child,
    );
  }
}

class PlnDropTarget extends StatelessWidget {
  const PlnDropTarget({super.key, required this.child, required this.active});

  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final content = PlnSurface(
      tone: active ? PlnSurfaceTone.muted : PlnSurfaceTone.transparent,
      child: child,
    );

    return active
        ? PlnStrokeFrame(role: PlnStrokeRole.latent, child: content)
        : content;
  }
}

class PlnDragPreview extends StatelessWidget {
  const PlnDragPreview({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.82,
      child: PlnSurface(
        tone: PlnSurfaceTone.component,
        padding: const EdgeInsets.all(PlnSpace.sm),
        child: child,
      ),
    );
  }
}

class PlnDropIndicator extends StatelessWidget {
  const PlnDropIndicator({super.key, this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? PlnLine.width : double.infinity,
      height: vertical ? double.infinity : PlnLine.width,
      decoration: BoxDecoration(
        color: context.plnTheme.interaction,
        borderRadius: BorderRadius.circular(PlnRadius.full),
      ),
    );
  }
}

class PlnSortControl extends StatelessWidget {
  const PlnSortControl({
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
          PlnText(label, role: PlnTextRole.caption),
          if (icon != null) ...[
            const SizedBox(width: PlnSpace.xs),
            PlnIcon(icon!, size: PlnSize.iconSmall),
          ],
        ],
      ),
    );
  }
}

class PlnThemeToggle extends StatelessWidget {
  const PlnThemeToggle({
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
      child: PlnSurface(
        tone: dark ? PlnSurfaceTone.muted : PlnSurfaceTone.inset,
        padding: const EdgeInsets.all(PlnSpace.sm),
        child: PlnText(label, role: PlnTextRole.caption),
      ),
    );
  }
}

typedef PlnSearchField = PlnTextField;
typedef PlnToastRegion = PlnToastStack;
typedef PlnContextMenu = PlnMenu;
typedef PlnCommandPalette = PlnCommandMenu;
