import 'package:flutter/material.dart';

import '../../../styling/legacy_theme/klp_theme.dart';
import '../../content/klp_text.dart';
import '../../../features/actions/button/klp_button_types.dart';
import '../controls/klp_control_size.dart';

/// 按鈕各位置的已解析風格；只引用目前主題，不建立第二份預設值。
@immutable
class KlpButtonStyle {
  final double height;
  final EdgeInsets insets;
  final double radius;
  final Border? border;
  final Color background;
  final Color foreground;
  final Color materialColor;
  final Color progressColor;
  final double contentGap;
  final KlpTextRole labelRole;
  final bool dashed;

  const KlpButtonStyle._({
    required this.height,
    required this.insets,
    required this.radius,
    required this.border,
    required this.background,
    required this.foreground,
    required this.materialColor,
    required this.progressColor,
    required this.contentGap,
    required this.labelRole,
    required this.dashed,
  });

  factory KlpButtonStyle.resolve({
    required KlpTheme klp,
    required KlpButtonTone tone,
    required KlpControlSize size,
    required bool disabled,
    required bool active,
    required bool selected,
  }) {
    // 依操作語意取得底色；停用狀態優先於選取與懸停。
    final tokens = klp.color;
    var background = tokens.surfaceInset;
    if (!disabled) {
      background = switch (tone) {
        KlpButtonTone.primary => klp.primary,
        KlpButtonTone.secondary => tokens.component,
        KlpButtonTone.ghost || KlpButtonTone.dashed => tokens.clear,
        KlpButtonTone.danger => tokens.danger.withValues(
          alpha: klp.surface.statusFillOpacity,
        ),
      };
    }

    // 選取 wash 優先於 hover／focus，前景依實際混色後背景解析。
    Color? stateWash;
    if (selected && !disabled) {
      final selectedColor = tone == KlpButtonTone.primary
          ? klp.onPrimary
          : tokens.interaction;
      stateWash = selectedColor.withValues(alpha: klp.surface.focusWashOpacity);
    } else if (active && !disabled) {
      stateWash = klp.selectionWash;
      if (tone == KlpButtonTone.primary) {
        stateWash = klp.onPrimary.withValues(
          alpha: klp.surface.selectionWashOpacity,
        );
      }
    }
    final effectiveBackground = stateWash == null
        ? background
        : Color.alphaBlend(stateWash, background);
    var foreground = tokens.textFaint;
    if (!disabled) {
      foreground = switch (tone) {
        KlpButtonTone.primary => klp.primaryForegroundFor(effectiveBackground),
        KlpButtonTone.danger => tokens.danger,
        KlpButtonTone.secondary ||
        KlpButtonTone.ghost ||
        KlpButtonTone.dashed => tokens.text,
      };
    }

    // 五段尺寸保留既有映射，MD 的水平內距仍經 component override 解析。
    final (height, paddingX, textRole) = switch (size) {
      KlpControlSize.xs => (
        klp.buttonHeightXSmall,
        klp.space.controlInset,
        KlpTextRole.caption,
      ),
      KlpControlSize.sm => (
        klp.buttonHeightSmall,
        klp.space.controlPaddingXSmall,
        KlpTextRole.caption,
      ),
      KlpControlSize.md => (
        klp.buttonHeight,
        klp.buttonInsets.left,
        KlpTextRole.body,
      ),
      KlpControlSize.lg => (
        klp.buttonHeightLarge,
        klp.space.controlPaddingXLarge,
        KlpTextRole.lead,
      ),
      KlpControlSize.xl => (
        klp.buttonHeightXLarge,
        klp.space.controlPaddingXXLarge,
        KlpTextRole.lead,
      ),
    };
    var labelRole = textRole;
    if (tone == KlpButtonTone.primary) {
      labelRole = switch (textRole) {
        KlpTextRole.caption => KlpTextRole.captionStrong,
        KlpTextRole.body => KlpTextRole.bodyStrong,
        _ => textRole,
      };
    }

    // 邊框與長按進度共用同一主題快照，交由既有互動元件繪製。
    Border? border;
    if (klp.buttonBorderWidth != klp.shape.none) {
      border = Border.all(color: tokens.border, width: klp.buttonBorderWidth);
    }
    final progressBase = tone == KlpButtonTone.primary
        ? klp.onPrimary
        : tokens.interactionSoft;
    return KlpButtonStyle._(
      height: height,
      insets: EdgeInsets.symmetric(horizontal: paddingX),
      radius: klp.buttonRadius,
      border: border,
      background: effectiveBackground,
      foreground: foreground,
      materialColor: tokens.clear,
      progressColor: progressBase.withValues(
        alpha: klp.surface.pressProgressOpacity,
      ),
      contentGap: klp.space.controlContentGap,
      labelRole: labelRole,
      dashed: tone == KlpButtonTone.dashed,
    );
  }
}
