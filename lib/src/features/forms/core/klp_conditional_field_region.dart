import '../internal/klp_form_dependencies.dart';

part 'primitives/klp_conditional_field_animation.dart';

/// 依條件顯示／隱藏一段欄位，並用 Kallopis 尺寸動畫補間高度變化，避免表單
/// 其他欄位因為突然增減內容而跳動。
///
/// [visible] 為 false 時 [child] 會被整個換成零尺寸盒，因此
/// child 的 widget 狀態不會保留——若 child 內有輸入控制項且需要在重新顯示時
/// 保住使用者輸入，請自行在 child 上加 [GlobalKey] 或改用其他方式保存資料。
class KlpConditionalFieldRegion extends StatelessWidget {
  const KlpConditionalFieldRegion({
    super.key,
    required this.visible,
    required this.child,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _KlpConditionalFieldAnimation(visible: visible, child: child);
  }
}
