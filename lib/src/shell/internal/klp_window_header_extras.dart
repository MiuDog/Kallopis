import 'package:flutter/widgets.dart';

enum _WindowHeaderSlot { identity, extras }

/// 建立可保留自然寬度，並在空間不足時依方向裁切的標題列區域。
Widget buildKlpWindowHeaderRegion({
  required List<Widget> children,
  required AlignmentGeometry alignment,
}) {
  return ClipRect(
    child: Align(
      alignment: alignment,
      widthFactor: 1,
      child: OverflowBox(
        alignment: alignment,
        maxWidth: double.infinity,
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    ),
  );
}

/// 先配置右側次要內容，再把剩餘空間完整交給標題識別區。
Widget buildKlpWindowHeaderContent({required Widget identity, Widget? extras}) {
  return CustomMultiChildLayout(
    delegate: _WindowHeaderContentDelegate(),
    children: [
      LayoutId(id: _WindowHeaderSlot.identity, child: identity),
      if (extras != null) LayoutId(id: _WindowHeaderSlot.extras, child: extras),
    ],
  );
}

class _WindowHeaderContentDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    var extrasWidth = 0.0;
    if (hasChild(_WindowHeaderSlot.extras)) {
      final extrasSize = layoutChild(
        _WindowHeaderSlot.extras,
        BoxConstraints.loose(size),
      );
      extrasWidth = extrasSize.width;
      positionChild(
        _WindowHeaderSlot.extras,
        Offset(size.width - extrasWidth, (size.height - extrasSize.height) / 2),
      );
    }

    final identityWidth = (size.width - extrasWidth).clamp(0.0, size.width);
    layoutChild(
      _WindowHeaderSlot.identity,
      BoxConstraints.tight(Size(identityWidth, size.height)),
    );
    positionChild(_WindowHeaderSlot.identity, Offset.zero);
  }

  @override
  bool shouldRelayout(_WindowHeaderContentDelegate oldDelegate) => false;
}
