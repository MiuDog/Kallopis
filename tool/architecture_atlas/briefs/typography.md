## 分析入口

`typography/` 以 KlpTextRole、KlpTextTone、字型角色與色階，將 theme 字型／色彩轉成文字呈現；KlpText 是單段文字入口。KlpRichText 接受 spans 或 nodes，依節點種類產生 TextSpan／WidgetSpan，並以 callback 回報連結及 mention 點擊。此目錄無巢狀子目錄，資料節點描述的是這組顯示元件的輸入格式。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 角色如何轉換字體樣式？ | KlpTextStyles／KlpTextStyleDefinition.toTextStyle — `lib/src/foundation/content/klp_text.dart:101`、`lib/src/foundation/content/klp_text.dart:79` |
| 單段文字在哪建構？ | KlpText.build — `lib/src/foundation/content/klp_text.dart:313` |
| 富文字節點種類？ | KlpRichTextKind／KlpRichTextNode — `lib/src/foundation/content/klp_rich_text.dart:22`、`lib/src/foundation/content/klp_rich_text.dart:41` |
| 混排節點如何展開？ | KlpRichText._spanFor — `lib/src/foundation/content/klp_rich_text.dart:123` |

重要關係：

- `KlpText.build` → role definition → `toTextStyle`：依目前 theme typography 解析，而非固定 TextStyle（`lib/src/foundation/content/klp_text.dart:313`）。
- `KlpRichText._spanFor` → 自身遞迴處理 children；code 分支建立 `KlpInlineCode` 的 WidgetSpan（`lib/src/foundation/content/klp_rich_text.dart:123`、`lib/src/foundation/content/klp_rich_text.dart:134`）。
- `KlpRichText` → 消費者 callback：mention 觸發 onOpenMention；link 的 TapGestureRecognizer 觸發 onOpenLink（`lib/src/foundation/content/klp_rich_text.dart:150`、`lib/src/foundation/content/klp_rich_text.dart:177`）。

import 不代表解析或互動順序；遞迴與 callback 關係需對照實際方法。
