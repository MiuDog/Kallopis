part of '../klp_navigator_models.dart';

/// Navigator 可注入資料的共同型別。
///
/// 對外只有 [KlpNavigatorCategory]、[KlpNavigatorElement] 與
/// [KlpNavigatorComponent] 三種具體模型。
@immutable
sealed class KlpNavigatorItem {
  const KlpNavigatorItem({required this.id});

  final String id;
}
