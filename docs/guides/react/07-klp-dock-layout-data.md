# Dock 布局資料保存

公開 encodeKlpDockLayout／restoreKlpDockLayout 使用與 Flutter 相同的 [schemaVersion1 JSON](../../architecture/workbench-dock-contract.md)。KlpDockLayoutData 是 readonly left／right／bottom；每個 area 有 axis、isVisible、extent、groups，每個 group 有 id、panelIds、activePanelId、mainAxisExtent。Stage／產品內容、風格與業務狀態不包含在保存資料。

```ts
import { encodeKlpDockLayout, restoreKlpDockLayout, type KlpDockPanelPolicy } from '@kallopis/react';

const saved = encodeKlpDockLayout(layout);
const policies: readonly KlpDockPanelPolicy[] = panels.map(panel => ({
	id: panel.id,
	allowSide: panel.allowSide,
	allowBottom: panel.allowBottom,
}));
try {
	const result = restoreKlpDockLayout(saved, policies);
	// 產品自行呈現 missingPanelIds／availablePanelIds 並決定採用。
	setLayout(result.layout);
} catch (error) {
	if (error instanceof TypeError) setLoadError(error.message);
	else throw error;
}
```

載入先完整驗證，再對 registry；缺少面板按保存順序移除並回報、空 group 刪除，active 消失則取第一個。availablePanelIds 按 registry 順序列出新增及原本未放置面板，庫不自動填入布局。未提供 allowSide／allowBottom 表示允許；未知欄位、重複 identity、非法 active／數值及已存在面板 capability 衝突都以 TypeError 整份拒絕，原資料與 caller 清冊不改。

結果所有物件及列表深層 frozen；encode 驗證並複製 caller，不凍結或修改原資料。庫不執行 storage；產品決定保存位置及以預設 layout reset。這組純資料 API 完成保存邊界，React Dock 呈現、分頁及拖放元件仍由 Workbench stage 接續。

## API 查表

- [KlpDockLayoutData](../../reference/react/types/klp-dock-layout-data.md)
- [KlpDockPanelPolicy](../../reference/react/types/klp-dock-panel-policy.md)
