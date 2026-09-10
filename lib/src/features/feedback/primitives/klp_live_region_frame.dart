part of '../klp_live_region.dart';

/// 將 live-region 的 Flutter 語意節點限制在 feedback 基礎原語邊界。
class _KlpLiveRegionFrame extends StatelessWidget {
  const _KlpLiveRegionFrame({required this.message, required this.child});

  final String? message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: message != null,
      liveRegion: true,
      label: message,
      child: child,
    );
  }
}
