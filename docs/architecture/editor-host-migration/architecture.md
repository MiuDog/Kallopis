# Editor Host Ownership v1

狀態：IMPLEMENTED（2026-09-20）。

規格：[KLP-0023](../../../spec/decisions/KLP-0023-product-editor-host-ownership.md)。

## 目的與非目標

本階段把 BlockNote／Canva 的 Flutter host、bridge、資產及工具從 Kallopis 完整移交 Planist，同時維持 Krepis 資料權威與現有可觀察行為。

本階段不重設 editor UI、不更換 BlockNote／Canva 引擎、不修改 Krepis schema，也不建立通用 editor runtime。

## 目標結構

```text
Planist/frontend/lib/modules/flow/
	presentation/editor/
		pln_block_note_editor.dart
		pln_resolved_asset.dart

Planist/frontend/lib/modules/canva/
	presentation/editor/
		pln_canva_editor.dart

Planist/frontend/lib/modules/workspace/
	presentation/screens/pln_workspace_content.dart
		→ 只選擇並組裝上述 widgets

每個 module
	→ domain／application／presentation

Planist/tool/editors/
	block_note/
	canva/

Planist/frontend/assets/editors/
	block_note/
	canva/
```

產品能力集中於 `modules/<capability>`，責任層次置於模組內。Editor presentation 不依賴完整 Workspace controller；Workspace presentation 只透過建構參數與 callback 組裝。完整規則以 Planist `docs/planning/vertical-module-boundary.md` 為準。

## 責任圖

| Owner | 擁有 | 禁止擁有 |
| --- | --- | --- |
| Flow／Canva presentation | Editor lifecycle、bridge、產品 Widget 內部互動 | Workspace controller、navigation、repository、Kallopis private API |
| Workspace presentation | destination 選擇、session 查詢、controller projection 與 Widget 組裝 | JavaScript handlers、asset URI、WebView environment、資料權威 |
| 各 module application／domain | controller、model、repository、session factory 與業務 workflow | presentation 反向依賴、Flutter Widget |
| Krepis | session、文件／畫布資料、dirty、selection、undo、保存 | Flutter layout、產品錯誤畫面 |
| Kallopis | semantic theme、Menu、loading／error state 與其他共用視覺 | editor controller 型別、bridge、editor asset、產品流程 |

## 依賴方向

```text
workspace/presentation
	↓ typed constructor／callback
flow/presentation             canva/presentation
	↓                                 ↓
Krepis BlockNote contract      Krepis Canva contract
	↓                                 ↓
Planist packaged Web asset／bridge

presentation → Kallopis public theme／foundation
```

不得形成 `domain → application/presentation`、`application → presentation`、跨 module presentation import、`Kallopis → Krepis editor binding` 或 `Kallopis → Planist`。

## 目前階段 slices

三個 slices 必須在同一遷移分支完成；中間狀態不是可發布版本。

### EHO-1：建立 Flow／Canva 垂直模組與資產 owner

Outcome：Flow／Canva module 各自擁有 application、domain、editor presentation 與 packaged assets，但 Workspace 尚未切換 caller。

允許路徑：

- `Planist/frontend/lib/modules/flow/**`
- `Planist/frontend/lib/modules/canva/**`
- `Planist/frontend/assets/editors/**`
- `Planist/tool/editors/**`
- `Planist/frontend/pubspec.yaml`
- editor-only `Planist/third_party/**`

里程碑：

1. Flow／Canva module 與 editor presentation 建立；證據是局部 analyze，累計預估 14k–24k tokens／55–110 分鐘，超過 32k tokens 或 150 分鐘視為異常。
2. build source、資產、license 與 verifier 轉移並改用 Planist asset URI／handler；證據是兩組資產 build／verifier，累計預估 24k–40k tokens／90–180 分鐘，超過 52k tokens 或 240 分鐘視為異常。
3. Planist 直接擁有 WebView dependency 與 Windows override；證據是 dependency resolution 與 component analyze，累計預估 30k–48k tokens／120–220 分鐘，超過 64k tokens 或 300 分鐘視為異常。

估算依據：現有 700+ 行雙 editor host、兩個既有 Vite tool 與單一 Windows override；屬 cold-start estimate，假設不改 bridge protocol payload。

### EHO-2：建立 Workspace 垂直模組並切換產品組裝

Outcome：Workspace 的 domain、application、presentation 集中於同一 module，組裝 Flow／Canva editor；所有舊 `features` 能力同步歸入對應 module，所有 caller 不再使用 Kallopis editor API。

允許路徑：

- `Planist/frontend/lib/modules/**`
- `Planist/frontend/lib/features/**`
- 由獨立 Test Author 指定的 editor 測試檔
- Planist 三個受影響 module 的 `architecture.md`

里程碑：

1. Flow caller 與 asset result 改接；證據是 Flow editor smoke／lifecycle，累計預估 8k–14k tokens／30–60 分鐘，超過 20k tokens 或 90 分鐘視為異常。
2. Canva caller 改接；證據是 Canva editor smoke／lifecycle，累計預估 13k–22k tokens／50–100 分鐘，超過 30k tokens 或 140 分鐘視為異常。
3. production scan 證明 Workspace 無 WebView／bridge、舊頂層技術目錄消失、Planist 無 `Klp*Editor` caller；證據是局部 analyze、import graph 與 symbol scan，累計預估 22k–42k tokens／100–210 分鐘，超過 58k tokens 或 290 分鐘視為異常。

估算依據：現行 workspace 只有一個 editor 組裝入口；屬 cold-start estimate。

### EHO-3：移除 Kallopis owner 並重建 Reference

Outcome：Kallopis 不再依賴 Krepis editor binding 或 WebView，正式 Reference 忠實呈現收斂後 public API。

允許路徑：

- `lib/kallopis_experimental.dart`
- `lib/src/features/editing/widgets/klp_editors.dart`
- `pubspec.yaml`
- `assets/blocknote_editor/**`
- `assets/canva_editor/**`
- `tool/blocknote_editor/**`
- `tool/canva_editor/**`
- editor verifier files
- KLP-0020／0022／0023、產品指南、handoff、Reference manifest 與相關架構文件

里程碑：

1. 移除 Kallopis export、source、editor dependencies／assets／tools；證據是 public barrel analyze 與零符號／依賴掃描，累計預估 8k–14k tokens／30–60 分鐘，超過 20k tokens 或 90 分鐘視為異常。
2. 更新 current docs 並重新擷取 Reference；證據是 manifest 不含三個舊型別，累計預估 12k–20k tokens／45–90 分鐘，超過 28k tokens 或 130 分鐘視為異常。
3. 依序驗證 Planist、Kallopis 及 Reference，再進行人類網頁驗收；累計預估 16k–28k tokens／70–140 分鐘，超過 38k tokens 或 200 分鐘視為異常。

估算依據：本輪已完成的 TDS Reference 生成與 483 頁驗證；EHO-3 為相近工具流程，其他部分屬 cold-start estimate。

## 驗收證據

- 目錄檢查：兩個 editor 位於各自 `modules/<capability>/presentation/editor/`，不在 Workspace presentation。
- 邊界檢查：layout 無 `InAppWebView`、bridge handler、editor package asset URI。
- 行為檢查：既有 configure、open、message、snapshot、asset、reference、menu 與 failure 路徑保持。
- 權威檢查：沒有第二份正文／畫布模型或 session registry。
- Kallopis 清理：零 Krepis editor import、零 WebView import、零 editor asset 宣告、零舊 editor public symbol。
- Reference：生成、頁數一致性、surface import 與 forbidden symbol 驗證通過。
- 人類待驗：中文 IME、剪貼簿、讀屏、focus、hover、選單定位及 Windows WebView 手感。

## 受保護內容

- Krepis bindings、資料格式與 session semantics。
- Planist workspace registry、保存／離開保護與專案切換流程。
- Kallopis semantic token 與已接受的共用元件視覺。
- 使用者在兩個 repository 的既有未提交變更。

## 完成判斷

EHO-1～EHO-3 已完成。Planist 垂直 modules、editor assets、tools 與 WebView dependency 已成為唯一 owner；Kallopis 已移除舊公開型別、相依與資產，正式 Reference 不再列出產品 editor host。
