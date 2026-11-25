# Dock 受控操作

公開 applyKlpDockAction(layout, policies, action) 回傳不可變 layout／changed。KlpDockAction 提供 select、move、open、merge、close、visibility、resizeArea、resizeGroup；move 使用 tab destination 重排／移入既有群組，使用 group destination 分割成新群組。open 使用相同 destination，但要求面板尚未放置。index 是移除來源之後的最終插入位置，非法值不 clamp。

```ts
import { applyKlpDockAction, type KlpDockAction } from '@kallopis/react';

const action: KlpDockAction = {
	type: 'move',
	panelId: 'inspector',
	destination: { kind: 'group', area: 'right', groupId: 'inspector-group', index: 0, extent: 240 },
};
const result = applyKlpDockAction(layout, policies, action);
if (result.changed) setLayout(result.layout);
```

新 groupId 必須不與操作前的任何群組重複。移動／合併保留分頁順序並驗證 area 能力；來源空群組刪除，原 active 移走則取第一個剩餘項目。目標 area 展開，但 select 只改 active。close 的 approved boolean 必由產品關閉 callback 決定；false 是不改資料的合法 no-op，true 只移除布局，不刪 registry，仍可 open。dirty／pinned metadata 不放入保存資料。

visibility 保存收合／展開；resizeArea／resizeGroup 只更新有限偏好尺寸，實際 viewport 與 handle 配額由 Dock UI 解算後提交。取消拖曳不提交操作，hover 不改布局。非法目前布局、缺清冊、停靠能力或 action 以 TypeError 整份拒絕，原 state 不改；詳見 [操作契約](../../architecture/workbench-dock-contract.md#受控操作-wb-dock-ops-r1)。純資料入口不代表 Dock UI 已完成。

## API 查表

- [applyKlpDockAction](../../reference/react/utilities/apply-klp-dock-action.md)
- [KlpDockAction](../../reference/react/types/klp-dock-action.md)
