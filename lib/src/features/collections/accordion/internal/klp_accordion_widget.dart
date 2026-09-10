part of '../klp_accordion.dart';

/// 可摺疊的內容區清單。
///
/// [multiple] 為 `false`（預設）時同一時間只能展開一項，再點其他標題會先收合原本
/// 展開的那項；為 `true` 時各項互不影響。展開狀態是暫存的 UI 狀態而非產品資料，
/// 因此元件自行持有——需要預先展開特定項目或觀察變化時用 [initialExpandedIds] 與
/// [onExpandedChanged]。
class KlpAccordion extends StatefulWidget {
  const KlpAccordion({
    super.key,
    required this.items,
    this.multiple = false,
    this.initialExpandedIds = const <String>{},
    this.onExpandedChanged,
  });

  final List<KlpAccordionItemData> items;
  final bool multiple;
  final Set<String> initialExpandedIds;
  final ValueChanged<Set<String>>? onExpandedChanged;

  @override
  State<KlpAccordion> createState() => _KlpAccordionState();
}
