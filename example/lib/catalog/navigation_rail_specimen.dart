import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

class NavigationRailSpecimen extends StatefulWidget {
  const NavigationRailSpecimen({super.key});

  @override
  State<NavigationRailSpecimen> createState() => _NavigationRailSpecimenState();
}

class _NavigationRailSpecimenState extends State<NavigationRailSpecimen> {
  String _selectedId = 'components';
  final List<_RailSpecimenItem> _topItems = [
    const _RailSpecimenItem('files', '檔案', KlpIcons.folder),
    const _RailSpecimenItem('components', '元件', KlpIcons.box),
  ];
  final List<_RailSpecimenItem> _centerItems = [
    const _RailSpecimenItem('search', '搜尋', KlpIcons.search),
    const _RailSpecimenItem('calendar', '日曆', KlpIcons.calendar),
    const _RailSpecimenItem('tasks', '任務', KlpIcons.checkSquare),
    const _RailSpecimenItem('inbox', '收件匣', KlpIcons.inbox),
    const _RailSpecimenItem('bookmarks', '書籤', KlpIcons.bookmark),
    const _RailSpecimenItem('archive', '封存', KlpIcons.archive),
    const _RailSpecimenItem('team', '團隊', KlpIcons.users),
    const _RailSpecimenItem('automation', '自動化', KlpIcons.diagramProject),
  ];
  final List<_RailSpecimenItem> _bottomItems = [
    const _RailSpecimenItem('status', '狀態', KlpIcons.infoSquare),
    const _RailSpecimenItem('settings', '設定', KlpIcons.settings),
  ];

  void _select(String id) {
    setState(() => _selectedId = id);
  }

  void _reorder(List<_RailSpecimenItem> items, int oldIndex, int newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  KlpRailItemGroup _buildGroup(
    String id,
    List<_RailSpecimenItem> items, [
    bool isReorderable = true,
  ]) {
    return KlpRailItemGroup(
      id: id,
      items: [for (final item in items) _buildEntry(item)],
      onReorder: (oldIndex, newIndex) => _reorder(items, oldIndex, newIndex),
      isReorderable: isReorderable,
    );
  }

  KlpRailEntry _buildEntry(_RailSpecimenItem item) {
    if (item.id == 'settings') {
      return KlpRailMenuEntry(
        id: item.id,
        icon: item.icon,
        label: item.label,
        items: [
          KlpMenuItemData(label: '偏好設定', onPressed: () {}),
          KlpMenuItemData(label: '鍵盤快捷鍵', onPressed: () {}),
        ],
      );
    }

    return KlpRailButtonEntry(
      id: item.id,
      icon: item.icon,
      label: item.label,
      selected: item.id == _selectedId,
      onPressed: () => _select(item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.klp.space.chromeRail,
      height: 420,
      child: KlpNavigationRailFrame(
        child: KlpNavigationRail(
          top: _buildGroup('top', _topItems, false),
          center: _buildGroup('center', _centerItems),
          bottom: _buildGroup('bottom', _bottomItems),
        ),
      ),
    );
  }
}

@immutable
class _RailSpecimenItem {
  final String id;
  final String label;
  final KlpIconData icon;

  const _RailSpecimenItem(this.id, this.label, this.icon);
}
