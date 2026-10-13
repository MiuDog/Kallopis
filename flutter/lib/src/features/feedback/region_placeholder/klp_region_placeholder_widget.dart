part of '../klp_region_placeholder.dart';

class KlpRegionPlaceholder extends StatelessWidget {
  const KlpRegionPlaceholder({
    super.key,
    required this.label,
    required this.kindLabel,
    this.detail,
    this.hatched = true,
    this.constraints,
    this.tone = KlpRegionPlaceholderTone.neutral,
    this.actionLabel,
    this.onAction,
  }) : assert(
         actionLabel == null || onAction != null,
         'A visible Placeholder action must be invokable.',
       );

  final String label;
  final String kindLabel;
  final String? detail;
  final bool hatched;
  final KlpBoxConstraints? constraints;
  final KlpRegionPlaceholderTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final geometry = context.klp.geometry.data;
    final semanticLabel = [label, kindLabel, ?detail].join('. ');
    final effectiveConstraints =
        constraints ??
        KlpBoxConstraints(minHeight: geometry.placeholderMinimumHeight);

    return KlpSemanticRegion(
      label: semanticLabel,
      explicitChildNodes: true,
      child: _KlpPlaceholderFrame(
        radius: context.klp.shape.card,
        borderColor: tokens.border,
        borderWidth: context.klp.shape.hairline,
        fillColor: hatched ? tokens.component : tokens.surfaceInset,
        hatchColor: tokens.surfaceInset,
        hatched: hatched,
        hatchBand: geometry.placeholderHatchBand,
        hatchGap: geometry.placeholderHatchGap,
        child: KlpConstrainedBox(
          constraints: effectiveConstraints,
          child: KlpBox(
            insets: KlpBoxInsets.directional(
              start: context.klp.space.containerPadding,
              top: geometry.placeholderContentPaddingY,
              end: context.klp.space.containerPadding,
              bottom: geometry.placeholderContentPaddingY,
            ),
            child: KlpCenter(
              child: KlpColumn(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KlpExcludeSemantics(
                    child: KlpRow(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _KlpPlaceholderMarkerGlyph(
                          pending: tone == KlpRegionPlaceholderTone.pending,
                        ),
                        const KlpGap.widthSize(KlpSpaceSize.contentInline),
                        KlpFlexible(
                          child: KlpText(
                            '${label.toUpperCase()} · ${kindLabel.toUpperCase()}',
                            role: KlpTextRole.label,
                            tone: KlpTextTone.faint,
                            textAlign: TextAlign.center,
                            tracking: KlpTextTracking.placeholder,
                            applyOpticalShift: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (detail != null) ...[
                    const KlpGap.heightSize(KlpSpaceSize.tight),
                    KlpExcludeSemantics(
                      child: KlpConstrainedBox(
                        constraints: KlpBoxConstraints(
                          maxWidth: geometry.placeholderDetailMaximumWidth,
                        ),
                        child: KlpText(
                          detail!,
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  if (actionLabel != null) ...[
                    const KlpGap.heightSize(KlpSpaceSize.placeholderAction),
                    _PlaceholderAction(
                      label: actionLabel!,
                      onPressed: onAction,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
