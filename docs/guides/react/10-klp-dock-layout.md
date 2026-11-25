# React Dock 元件

`KlpDockLayout` 由公開套件入口提供，必須位於 `KlpThemeProvider` 內。產品持有唯一 `layout`，在 `onLayoutChanged` 中決定採用新值；元件不自行保存副本。`panels` 是完整清冊，每項提供 `id`、非空 `label`、React `content`，可選 `icon`、能力限制、`isPinned`／`isDirty`、`onCloseRequested` 與 `closeLabel`。Stage／頂列是產品內容，原生宿主 `style` 供外部寬高，有限配額及內部style由本庫負責。

```tsx
import { KlpDockLayout } from '@kallopis/react';

<KlpDockLayout
	layout={layout}
	panels={panels}
	stage={productStage}
	leftConstraints={{ minExtent: 80 }}
	rightConstraints={{ minExtent: 80 }}
	bottomConstraints={{ minExtent: 32 }}
	onLayoutChanged={setLayout}
	onCloseError={(error, panelId) => showCloseError(error, panelId)}
	areaLabels={{ left: '工具', right: '屬性', bottom: '輸出' }}
	style={{ width: '100%', height: 400 }}
/>
```

分頁 click、左右方向键、Home／End 會循環選取並聚焦；目前 active 的重複選取不通知。邊緣入口切換收合，非active／收合正文保留DOM，因此同位置的原生輸入不因尺寸、風格或重新呈現而丟值。`ref` 指向布局宿主；SSR先輸出零尺寸槽，client量測後配置。

`onCloseRequested` 回傳同步 boolean 或 Promise<boolean>；false保留布局，true才從最新布局移出，不刪清冊或產品正文。pending只停用該close；面板曾移除再開、批准callback替換或元件卸載後，舊批准無效。callback需保持identity；錯誤或非boolean回傳交`onCloseError`，未提供則宿主reportError／console.error。產品以`closeLabel`本地化關閉名稱；metadata不改關閉權限或保存格式。

拖曳分頁可在其他分頁前半／後半插入，標頭空白合併進群組；放在正文可分割，空間不足兩個邏輯minimum時拒絕。空停靠區可在Stage邊界帶建立；Stage中央與禁止能力的位置不接drop。隱藏非空區在外邊緣hover暫時展開，取消/未命中不保存，成功才提交且保留原extent。不同layout instance取消正在進行的操作；同layout的風格/尺寸重建保持preview。

拖動區域及群組把手會先呈現縮放提示，放開才一次通知；pointer cancel/Escape/卸載不提交。相鄰群組尺寸守恆，不足minimum不寫入退化render尺寸。`collapseThresholds`可選各區有限非負門檻（缺省0），低於門檻只收合，保留偏好extent；拖後同一次pointer click不再toggle，keyboard click保持可用。

分頁拖放採瀏覽器[原生HTML drag事件](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API)，縮放採[Pointer Events](https://developer.mozilla.org/en-US/docs/Web/API/Pointer_events)及capture/cancel生命周期；分頁的觸控拖放能力依宿主瀏覽器，沒有新增touch polyfill或跨instance/跨視窗移動。CSS transform不改保存及pointer的布局座標。

## API 查表

- [KlpDockLayout](../../reference/react/components/workspace/klp-dock-layout.md)
- [KlpThemeProvider](../../reference/react/styling/klp-theme-provider.md)
