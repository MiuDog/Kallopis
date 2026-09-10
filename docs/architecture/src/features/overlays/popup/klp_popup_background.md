# klp_popup_background.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart)

## 範圍

核心是 `lib/src/features/overlays/popup/klp_popup_background.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_popup_background.dart"]
	n1["../klp_popup.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_popup.dart&#x27;;</code> | [lib/src/features/overlays/popup/klp_popup_background.dart:1](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPopupBackground"]
```

```mermaid
classDiagram
	class n0["KlpPopupBackground"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPopupBackground

ClassDeclaration · public · [lib/src/features/overlays/popup/klp_popup_background.dart:3](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L3)

<code>class KlpPopupBackground extends StatelessWidget</code>

來源註解摘要：Popup 的背景遮罩。點擊 panel 以外的可互動背景時呼叫 [onDismiss]。 若位於 [KlpPopupInteractionScope] 之下，scope 的頂部範圍只負責顯示遮罩， 不會接收 pointer，因此視窗標題列的拖動與雙擊事件優先。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/overlays/popup/klp_popup_background.dart:7](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPopupBackground</code> | public | <code>const KlpPopupBackground({ super.key, required this.child, required this.onDismiss, })</code> |  | [lib/src/features/overlays/popup/klp_popup_background.dart:8](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L8) |
| field <code>child</code> | public | <code>final KlpPopupPanel child</code> |  | [lib/src/features/overlays/popup/klp_popup_background.dart:14](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L14) |
| field <code>onDismiss</code> | public | <code>final VoidCallback onDismiss</code> |  | [lib/src/features/overlays/popup/klp_popup_background.dart:15](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L15) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/overlays/popup/klp_popup_background.dart:17](../../../../../../lib/src/features/overlays/popup/klp_popup_background.dart#L17) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
