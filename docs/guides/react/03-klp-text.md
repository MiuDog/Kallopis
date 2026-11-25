# 語意與 API 對應

| 通用配方 | React API | 合法用途與限制 |
| --- | --- | --- |
| text-body／caption／label／lead／h1～h4／code | `KlpText role`，`tone` | `as` 選擇原生文字標籤；角色決定字級、字型及字重 |
| surface／card | `KlpSurface tone`、`KlpCard header/footer` | header → content → footer 的次序由元件維護；產品決定內容 |
| badge-base／neutral／status | `KlpBadge tone` | neutral／success／warning／danger／info；標記不當作操作按鈕 |
| button-base／primary／secondary／ghost／size-* | `KlpButton tone/size/selected` | 使用原生 button；disabled 不發送點擊，產品持有選取狀態 |
| icon-button／inline／window | `KlpIconButton label/tone` | label 必填；內容由產品提供圖示，視窗行為由宿主提供 |
| field-base／error／disabled | `KlpTextField label/error` | label 必填；`value/onChange` 為產品控制的原生 input 契約 |
| frame／sidebar／auxiliary | `KlpFrame role/header/footer` | 固定 header → body → footer；角色限定表面，產品決定版面 |
| workspace-layout | `KlpWorkspace` | 提供共同 frame 間距；以公開 Frame 或原生 React 布局組合 |
| 一般布局 | `KlpAppLayout`、`KlpLayoutRow`、`KlpLayoutColumn`、`KlpLayoutPane`、`KlpLayoutSpacer`、`KlpLayoutDivider` | 有限尺寸、bounds、scoped gutter 與內容裁切；與 Dock 分離 |
| explorer-folder-row／row／hover／selected | `KlpFileExplorer` | 唯一且非空的 section/item ID；平坦投影，產品持有 expandedIds／selectedId 與 callbacks；hover／selected 同色 |

核心元件皆需 Provider。主題為 `light`、`dark`、`ultraDark`、`transparent`，缺失 Provider 或未知主題／語意／配方明確失敗。巢狀 Provider 具有獨立 scope。透明模式依宿主背景呈現，瀏覽器不提供原生視窗透明能力。

## API 查表

- [KlpAppLayout](../../reference/react/components/workspace/klp-app-layout.md)
- [KlpBadge](../../reference/react/components/content/klp-badge.md)
- [KlpButton](../../reference/react/components/actions/klp-button.md)
- [KlpCard](../../reference/react/components/layout/klp-card.md)
- [KlpFileExplorer](../../reference/react/components/workspace/klp-file-explorer.md)
- [KlpFrame](../../reference/react/components/layout/klp-frame.md)
- [KlpIconButton](../../reference/react/components/actions/klp-icon-button.md)
- [KlpLayoutColumn](../../reference/react/components/layout/klp-layout-column.md)
- [KlpLayoutDivider](../../reference/react/components/layout/klp-layout-divider.md)
- [KlpLayoutPane](../../reference/react/components/layout/klp-layout-pane.md)
- [KlpLayoutRow](../../reference/react/components/layout/klp-layout-row.md)
- [KlpLayoutSpacer](../../reference/react/components/layout/klp-layout-spacer.md)
- [KlpSurface](../../reference/react/components/layout/klp-surface.md)
- [KlpText](../../reference/react/components/content/klp-text.md)
- [KlpTextField](../../reference/react/components/inputs/klp-text-field.md)
- [KlpWorkspace](../../reference/react/components/workspace/klp-workspace.md)
