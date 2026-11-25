# 通用有限尺寸計算

從 foundation 使用 KlpLinearItem／resolveKlpLinearLayout，給有限主軸尺寸、scope 的 semantic gutter、間距數量及 minimum／maximum／preferred／flex，結果提供不可變 extents、實際 gutter、unused 與 compressed。庫不儲存產品內容或布局。

先扣間距；空間不足時按 minimum 比例退化，極大間距最多占滿主軸；有空間時按 flex 分配並遵守 maximum，無可增長項目時保留 unused。完整規則見 [共通尺寸契約](../../architecture/workbench-linear-contract.md)。Flutter 一般 Row／Column 已使用此算法；Dock 與其他元件的完整風格保護仍依各自契約接入。

## API 查表

- [KlpLinearItem](../../reference/flutter/types/klp-linear-item.md)
- [resolveKlpLinearLayout](../../reference/flutter/utilities/resolve-klp-linear-layout.md)
