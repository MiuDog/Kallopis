import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kallopis/kallopis.dart';
import '../catalog_components.dart';

enum _StatusVisualVariant { specification, freshSuccess, rejectedDanger }

enum _AnchorState { fresh, drifted, missing, unverified }

enum _ProposalState { pending, approved, rejected, revisionRequested }

class StatusVisualIterationCatalog extends StatelessWidget {
  const StatusVisualIterationCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogCanvas(
      children: [
        const KlpInlineNotice(
          title: 'D1 只比較狀態視覺編碼',
          message:
              'A 是規格版；B 只把 fresh 改成 success 實心圓；C 只把 rejected 改成 danger。'
              '每版都同時顯示 Light、Dark、Ultra Dark，並使用 26:2:1:1 的真實 anchor 比例。',
        ),
        for (final appearance in _CatalogAppearance.values)
          CatalogSample(
            label: appearance.label,
            description: '${appearance.label} 下直接比較 A／B／C。',
            child: _AppearanceComparison(appearance: appearance),
          ),
      ],
    );
  }
}

class _AppearanceComparison extends StatelessWidget {
  const _AppearanceComparison({required this.appearance});

  final _CatalogAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final variant in _StatusVisualVariant.values) ...[
            SizedBox(
              width: 306,
              child: Theme(
                data: buildKlpThemeVariant(appearance.themeVariant),
                child: Builder(
                  builder: (context) => _AppearancePanel(
                    appearance: appearance,
                    variant: variant,
                  ),
                ),
              ),
            ),
            if (variant != _StatusVisualVariant.values.last)
              const SizedBox(width: KlpSpace.md),
          ],
        ],
      ),
    );
  }
}

class _AppearancePanel extends StatelessWidget {
  const _AppearancePanel({required this.appearance, required this.variant});

  final _CatalogAppearance appearance;
  final _StatusVisualVariant variant;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.klpColors.app,
      child: Padding(
        padding: const EdgeInsets.all(KlpSpace.sm),
        child: KlpSurface(
          padding: const EdgeInsets.all(KlpSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlpPanelHeader(title: variant.label, label: appearance.code),
              const SizedBox(height: KlpSpace.sm),
              KlpText(
                variant.description,
                role: KlpTextRole.body,
                tone: KlpTextTone.muted,
              ),
              const SizedBox(height: KlpSpace.lg),
              _IndicatorContextComparison(variant: variant),
              const SizedBox(height: KlpSpace.xl),
              _AlignmentSampleList(variant: variant),
              const SizedBox(height: KlpSpace.xl),
              _ProposalSampleList(variant: variant),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndicatorContextComparison extends StatelessWidget {
  const _IndicatorContextComparison({required this.variant});

  final _StatusVisualVariant variant;

  static const _contexts = <(String, double)>[
    ('LIST ROW', 12),
    ('INSPECTOR', 14),
    ('MAP NODE', 18),
    ('BADGE', 20),
    ('TABLE CELL', 14),
  ];

  @override
  Widget build(BuildContext context) {
    return KlpSection(
      title: 'Indicator contexts',
      label: '5 SIZES',
      child: Column(
        children: [
          for (final entry in _contexts)
            Padding(
              padding: const EdgeInsets.only(bottom: KlpSpace.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 84,
                    child: KlpText(
                      entry.$1,
                      role: KlpTextRole.label,
                      tone: KlpTextTone.faint,
                    ),
                  ),
                  for (final state in _AnchorState.values) ...[
                    _AnchorStateIndicator(
                      state: state,
                      variant: variant,
                      size: entry.$2,
                    ),
                    const SizedBox(width: KlpSpace.sm),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AlignmentSampleList extends StatelessWidget {
  const _AlignmentSampleList({required this.variant});

  final _StatusVisualVariant variant;

  @override
  Widget build(BuildContext context) {
    return KlpSection(
      title: 'Anchor scan test',
      label: '26 : 2 : 1 : 1',
      child: Column(
        children: [
          for (var index = 0; index < 30; index++)
            _AlignmentRow(
              index: index,
              state: _anchorStateAt(index),
              variant: variant,
            ),
        ],
      ),
    );
  }
}

class _AlignmentRow extends StatelessWidget {
  const _AlignmentRow({
    required this.index,
    required this.state,
    required this.variant,
  });

  final int index;
  final _AnchorState state;
  final _StatusVisualVariant variant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          SizedBox(
            width: KlpSize.icon,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _AnchorStateIndicator(
                state: state,
                variant: variant,
                size: KlpSize.iconSmall,
              ),
            ),
          ),
          const SizedBox(width: KlpSpace.xs),
          Expanded(
            child: KlpText(
              'Intent ${(index + 1).toString().padLeft(2, '0')}',
              role: KlpTextRole.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: KlpText(
              'repo · node-${index + 1}',
              role: KlpTextRole.code,
              tone: KlpTextTone.faint,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (state != _AnchorState.fresh) ...[
            const SizedBox(width: KlpSpace.sm),
            SizedBox(
              width: 72,
              child: KlpText(
                state.label,
                role: KlpTextRole.label,
                tone: KlpTextTone.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProposalSampleList extends StatelessWidget {
  const _ProposalSampleList({required this.variant});

  final _StatusVisualVariant variant;

  static const _states = <_ProposalState>[
    _ProposalState.pending,
    _ProposalState.approved,
    _ProposalState.pending,
    _ProposalState.rejected,
    _ProposalState.revisionRequested,
    _ProposalState.approved,
    _ProposalState.pending,
    _ProposalState.revisionRequested,
    _ProposalState.rejected,
    _ProposalState.approved,
    _ProposalState.pending,
    _ProposalState.pending,
  ];

  @override
  Widget build(BuildContext context) {
    return KlpSection(
      title: 'Proposal decisions',
      label: '12 ITEMS',
      child: Column(
        children: [
          for (var index = 0; index < _states.length; index++)
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  SizedBox(
                    width: KlpSize.icon,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _ProposalStateIndicator(
                        state: _states[index],
                        variant: variant,
                        size: KlpSize.iconSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: KlpSpace.xs),
                  Expanded(
                    child: KlpText(
                      'Proposal ${(index + 1).toString().padLeft(2, '0')}',
                      role: KlpTextRole.body,
                    ),
                  ),
                  SizedBox(
                    width: 126,
                    child: KlpText(
                      _states[index].label,
                      role: KlpTextRole.label,
                      tone: _states[index] == _ProposalState.rejected
                          ? KlpTextTone.faint
                          : KlpTextTone.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AnchorStateIndicator extends StatelessWidget {
  const _AnchorStateIndicator({
    required this.state,
    required this.variant,
    required this.size,
  });

  final _AnchorState state;
  final _StatusVisualVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return switch (state) {
      _AnchorState.fresh =>
        variant == _StatusVisualVariant.freshSuccess
            ? _SolidCircle(size: size, color: tokens.success)
            : SizedBox.square(dimension: size),
      _AnchorState.drifted => _HalfCircle(size: size, color: tokens.warning),
      _AnchorState.missing => KlpIcon(
        KlpIcons.x,
        size: size,
        color: tokens.danger,
        semanticLabel: state.label,
      ),
      _AnchorState.unverified => CustomPaint(
        size: Size.square(size),
        painter: _DashedCirclePainter(color: tokens.textFaint),
      ),
    };
  }
}

class _ProposalStateIndicator extends StatelessWidget {
  const _ProposalStateIndicator({
    required this.state,
    required this.variant,
    required this.size,
  });

  final _ProposalState state;
  final _StatusVisualVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return switch (state) {
      _ProposalState.pending => SizedBox.square(dimension: size),
      _ProposalState.approved => KlpIcon(
        KlpIcons.check,
        size: size,
        color: tokens.success,
        semanticLabel: state.label,
      ),
      _ProposalState.rejected => KlpIcon(
        KlpIcons.minus,
        size: size,
        color: variant == _StatusVisualVariant.rejectedDanger
            ? tokens.danger
            : tokens.textFaint,
        semanticLabel: state.label,
      ),
      _ProposalState.revisionRequested => _HalfCircle(
        size: size,
        color: tokens.warning,
      ),
    };
  }
}

class _SolidCircle extends StatelessWidget {
  const _SolidCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _AnchorState.fresh.label,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: SizedBox.square(dimension: size),
      ),
    );
  }
}

class _HalfCircle extends StatelessWidget {
  const _HalfCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _HalfCirclePainter(color: color),
    );
  }
}

class _HalfCirclePainter extends CustomPainter {
  const _HalfCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = KlpLine.hairline;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(rect.center, size.shortestSide / 2 - 0.5, stroke);
    canvas.drawArc(rect.deflate(0.5), -math.pi / 2, math.pi, true, fill);
  }

  @override
  bool shouldRepaint(covariant _HalfCirclePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2 - KlpLine.hairline;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = KlpLine.hairline
      ..strokeCap = StrokeCap.round;
    const segments = 8;
    const sweep = math.pi / 8;

    for (var index = 0; index < segments; index++) {
      final start = index * math.pi / 4;
      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

_AnchorState _anchorStateAt(int index) {
  return switch (index) {
    4 || 23 => _AnchorState.drifted,
    17 => _AnchorState.missing,
    28 => _AnchorState.unverified,
    _ => _AnchorState.fresh,
  };
}

enum _CatalogAppearance {
  light('Light', 'LIGHT', KlpThemeVariant.light),
  dark('Dark', 'DARK', KlpThemeVariant.dark),
  ultraDark('Ultra Dark', 'ULTRA DARK', KlpThemeVariant.ultraDark);

  const _CatalogAppearance(this.label, this.code, this.themeVariant);

  final String label;
  final String code;
  final KlpThemeVariant themeVariant;
}

extension on _StatusVisualVariant {
  String get label => switch (this) {
    _StatusVisualVariant.specification => 'A · Specification',
    _StatusVisualVariant.freshSuccess => 'B · Fresh uses success',
    _StatusVisualVariant.rejectedDanger => 'C · Rejected uses danger',
  };

  String get description => switch (this) {
    _StatusVisualVariant.specification =>
      'fresh 不繪製，rejected 使用 textFaint；只有需要處理的 anchor 使用狀態色。',
    _StatusVisualVariant.freshSuccess =>
      '只把 fresh 改為 success 實心圓，用 26 列 fresh 觀察滿版綠色的噪音。',
    _StatusVisualVariant.rejectedDanger =>
      '只把 rejected 改為 danger，觀察紅色是否把正常拒絕暗示為錯誤。',
  };
}

extension on _AnchorState {
  String get label => switch (this) {
    _AnchorState.fresh => 'fresh',
    _AnchorState.drifted => 'drifted',
    _AnchorState.missing => 'missing',
    _AnchorState.unverified => 'unverified',
  };
}

extension on _ProposalState {
  String get label => switch (this) {
    _ProposalState.pending => 'pending',
    _ProposalState.approved => 'approved',
    _ProposalState.rejected => 'rejected',
    _ProposalState.revisionRequested => 'revision requested',
  };
}
