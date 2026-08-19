import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_palette.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 單一步驟相對於 [KlpStepper.currentIndex] 的狀態。
///
/// 由 [KlpStepper] 依步驟位置自動推導，呼叫端不需要（也不應該）自行指定——
/// 三態永遠只由「目前在第幾步」這一個事實決定。
enum KlpStepStatus { completed, current, upcoming }

/// 步驟流程中的一步。
@immutable
class KlpStepData {
  const KlpStepData({required this.label, this.description});

  final String label;
  final String? description;
}

/// 步驟流程指示。依 [currentIndex] 把 [steps] 分成已完成／進行中／未開始三態。
///
/// 純顯示元件——不持有互動狀態，也不處理點擊；切換到下一步是呼叫端更新
/// [currentIndex] 後重建的結果。[direction] 決定排列方向。
class KlpStepper extends StatelessWidget {
  const KlpStepper({
    super.key,
    required this.steps,
    required this.currentIndex,
    this.direction = Axis.horizontal,
  });

  final List<KlpStepData> steps;
  final int currentIndex;
  final Axis direction;

  KlpStepStatus _statusOf(int index) {
    if (index < currentIndex) return KlpStepStatus.completed;
    if (index == currentIndex) return KlpStepStatus.current;
    return KlpStepStatus.upcoming;
  }

  @override
  Widget build(BuildContext context) {
    assert(steps.isNotEmpty, 'KlpStepper 至少需要一個步驟');
    assert(
      currentIndex >= 0 && currentIndex < steps.length,
      'currentIndex 必須落在 steps 範圍內',
    );

    return direction == Axis.horizontal
        ? _buildHorizontal(context)
        : _buildVertical(context);
  }

  Widget _buildHorizontal(BuildContext context) {
    final klp = context.klp;
    final markerSize = klp.space.avatarSmall;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KlpStepMarker(status: _statusOf(i), index: i, size: markerSize),
              SizedBox(height: klp.space.tight),
              SizedBox(
                width: markerSize * 2,
                child: _KlpStepLabel(step: steps[i], status: _statusOf(i)),
              ),
            ],
          ),
          if (i < steps.length - 1)
            Expanded(
              child: SizedBox(
                height: markerSize,
                child: Center(
                  child: _KlpStepConnector(
                    completed: _statusOf(i) == KlpStepStatus.completed,
                    axis: Axis.horizontal,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildVertical(BuildContext context) {
    final klp = context.klp;
    final markerSize = klp.space.avatarSmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _KlpStepMarker(
                      status: _statusOf(i),
                      index: i,
                      size: markerSize,
                    ),
                    if (i < steps.length - 1)
                      Expanded(
                        child: _KlpStepConnector(
                          completed: _statusOf(i) == KlpStepStatus.completed,
                          axis: Axis.vertical,
                        ),
                      ),
                  ],
                ),
                SizedBox(width: klp.space.compact),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: klp.space.comfortable),
                    child: _KlpStepLabel(step: steps[i], status: _statusOf(i)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _KlpStepMarker extends StatelessWidget {
  const _KlpStepMarker({
    required this.status,
    required this.index,
    required this.size,
  });

  final KlpStepStatus status;
  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    final Color background;
    final Color foreground;
    final Color borderColor;
    final double borderWidth;
    switch (status) {
      case KlpStepStatus.completed:
        background = tokens.text;
        foreground = KlpThemeContrast.foregroundFor(tokens.text);
        borderColor = tokens.text;
        borderWidth = klp.shape.stroke;
      case KlpStepStatus.current:
        background = KlpPalette.transparent;
        foreground = tokens.text;
        borderColor = tokens.text;
        borderWidth = klp.shape.stroke;
      case KlpStepStatus.upcoming:
        background = KlpPalette.transparent;
        foreground = tokens.textFaint;
        borderColor = tokens.guide;
        borderWidth = klp.shape.hairline;
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: status == KlpStepStatus.completed
          ? KlpIcon(
              KlpIcons.check,
              size: klp.space.iconSmall,
              color: foreground,
            )
          : KlpText('${index + 1}', role: KlpTextRole.label, color: foreground),
    );
  }
}

class _KlpStepConnector extends StatelessWidget {
  const _KlpStepConnector({required this.completed, required this.axis});

  final bool completed;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final color = completed ? tokens.text : tokens.divider;

    return axis == Axis.horizontal
        ? SizedBox(
            width: double.infinity,
            height: klp.shape.stroke,
            child: ColoredBox(color: color),
          )
        : SizedBox(
            width: klp.shape.stroke,
            height: double.infinity,
            child: ColoredBox(color: color),
          );
  }
}

class _KlpStepLabel extends StatelessWidget {
  const _KlpStepLabel({required this.step, required this.status});

  final KlpStepData step;
  final KlpStepStatus status;

  @override
  Widget build(BuildContext context) {
    final emphasized = status != KlpStepStatus.upcoming;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        KlpText(
          step.label,
          role: KlpTextRole.bodyStrong,
          tone: emphasized ? KlpTextTone.primary : KlpTextTone.faint,
        ),
        if (step.description != null) ...[
          SizedBox(height: context.klp.space.tight),
          KlpText(
            step.description!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        ],
      ],
    );
  }
}
