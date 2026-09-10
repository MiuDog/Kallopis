part of '../structure/klp_application.dart';

/// 唯一啟動入口：消費端注入應用資料來源，本庫建立與持有渲染宿主。
void runKlpApp(KlpState<KlpApplication> source) {
  runApp(_KlpApplicationHost(source: source));
}
