# 通用錨定 Popup

狀態：READY

擁有模組：`features/workspace/anchored_popup`

架構基線：[KLP-0022](decisions/KLP-0022-thin-design-system-boundary.md)

## 目標

提供直接 Flutter 的受控錨定 popup，以及可在 popup、Explorer 或其他工作區元件重用的
輸入／確認命令流程。Consumer 擁有資料、open、產品操作及結果狀態；Kallopis 擁有
overlay 定位、焦點、鍵盤、可及性與現行 semantic theme 呈現。

## Current v1 requirements

| ID | 優先級 | 需求 | 可觀察驗收 |
| --- | --- | --- | --- |
| AP-01 | P1 | `KlpAnchoredPopup` 的 `open` 是唯一權威；trigger、外點、Escape 與失去錨點只回報帶原因的變更請求。 | 未收到 consumer 回填前不自行改寫 open；每次操作只回報一次。 |
| AP-02 | P1 | Trigger 使用直接 Flutter builder，Kallopis 注入 toggle callback 與 expanded 狀態；不接受座標、style 或第二套 renderer。 | Consumer 可用既有 Kallopis action 元件建立 trigger，popup 由其實際 bounds 定位。 |
| AP-03 | P1 | Panel 依序呈現可選 title、items、actions、feedback，且至少存在一種非 title 內容。 | 無任意 schema／node；更新輸入即可在保持 open 時更新內容。 |
| AP-04 | P1 | Item 具有穩定 `String id`、label、可選 subtitle／icon、current／enabled、主要事件及 commands。 | 重複 ID、空 label／subtitle 被拒絕；disabled item 不執行。 |
| AP-05 | P1 | `KlpWorkspaceCommand` 支援可選輸入、可選確認、async invoke 與 completed／canceled／failed 結果。 | 取消不 invoke；完整確認後只 invoke 一次；結果 callback 不宣稱產品已提交。 |
| AP-06 | P1 | Popup 支援 loading／ready／error／result；error／result 必須有非空 message。 | feedback 是 live region；內容 action 不自動關閉 popup。 |
| AP-07 | P1 | 開啟時焦點進入 panel，Tab 留在 panel；關閉後回 trigger；child route 隨 popup 關閉。 | pointer、Enter／Space、Escape、Tab 與 route teardown 可核對。 |
| AP-08 | P1 | Panel 方向感知地錨定 trigger 下方起始側，空間不足翻到上方，並限制於 viewport。 | trigger 移動時重定位；無效錨點不留下可互動 overlay。 |
| AP-09 | P1 | 所有尺寸、色彩、字型、icon、surface、shadow 與互動狀態取自 Kallopis 現行語意。 | API 不接受 style／像素；切換 theme 仍完整解析。 |

## 公開資料與事件

- `KlpAnchoredPopupTriggerBuilder(BuildContext, VoidCallback, bool)`：consumer 只決定使用哪個
  既有 Widget 呈現 trigger；第二、三參數分別是 toggle 與 expanded。
- `KlpAnchoredPopupItem`：產品無關的平面列資料與事件。
- `KlpAnchoredPopup`：直接 Flutter `StatefulWidget`；不擁有產品 open 或資料。
- `KlpWorkspaceCommand`／`KlpWorkspaceCommandResult`：命令顯示資料、consumer callback 與
  呈現流程結果。
- `showKlpWorkspaceCommand`：需要在 popup 外重用同一命令流程時的公開入口。

## 邊界

- 不建立 `KlpNode`、slot、adapter、bound model、compiler 或 private renderer。
- 不擁有 navigation、Explorer selection、文件狀態、storage、undo 或產品 workflow。
- Trigger builder 只取得 toggle／expanded；Kallopis 不推測 consumer Widget 的業務事件。
- 命令 label、輸入 label、確認文案、提交及取消文案由 consumer 提供；Kallopis 不硬編產品語言。
- 未來 hover open、任意 placement、動畫選項、多層 popup 不在 v1。

## Readiness

所有 P1 行為由既有已接受能力與 KLP-0022 的直接 Flutter 邊界決定；沒有未決的資料權威、
公開相容性或視覺自訂問題。DEFINE READY。
