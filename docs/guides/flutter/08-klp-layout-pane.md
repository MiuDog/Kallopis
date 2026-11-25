# 一般布局 bounds 與 divider

LayoutRow／LayoutColumn／LayoutSpacer／KlpLayoutPane／KlpAppFrame 接受 KlpLayoutBounds(minimum、maximum、preferred)，Column 可選 start／end alignment。正 flex 未指定 preferred 時保留 Expanded 語意；零 flex 量測自然尺寸。主軸無上限時依有限自然尺寸回退，內容需可量測出有限值。

KlpLayoutDivider 是沒有手勢的顯式 semantic gutter，前後不另加自動 gap；LayoutResizeHandle 仍保留既有 onResize 全域位置回呼。產品自行決定尺寸變更與保存。Root inset 每軸最多可用尺寸的一半；間距不足由 solver 限縮，內容每槽裁切，布局不改 caller 順序或內容身分。

## API 查表

- [KlpAppFrame](../../reference/flutter/components/layout/klp-app-frame.md)
- [KlpLayoutBounds](../../reference/flutter/types/klp-layout-bounds.md)
- [KlpLayoutDivider](../../reference/flutter/components/layout/klp-layout-divider.md)
- [KlpLayoutPane](../../reference/flutter/components/layout/klp-layout-pane.md)
