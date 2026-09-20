# KLP-0023：產品編輯器宿主由 Planist 擁有

狀態：Implemented（2026-09-20）。

擁有模組：Planist Flow／Canva `presentation`；Workspace `presentation` 負責組裝，Kallopis public surface 負責完成移除。

目標版本：Editor Host Ownership v1。

## 決策

BlockNote 與 Canva 是 Planist 的產品能力，不是跨產品 Design System 元件。Flutter WebView 宿主、bridge、Web 資產、資產建置工具及只服務這兩個宿主的平台相依全部移交 Planist。

Krepis 繼續擁有文件、session、保存、selection 與 undo／redo 契約；Kallopis 只提供宿主內使用的共用 theme、Menu、載入與錯誤狀態等產品無關元件。

```text
Planist workspace/presentation
	→ Flow／Canva presentation editor
	→ Krepis session controller
	→ Planist WebView host／bridge／packaged asset
	→ BlockNote 或 Canva runtime

Flow／Canva presentation
	→ Kallopis public theme／foundation components
```

## 目錄與組裝邊界

產品元件必須位於能力模組自己的 `presentation`，不得放入 Workspace 或頂層技術分類：

```text
frontend/lib/features/
frontend/lib/modules/
	flow/
		presentation/editor/
			pln_block_note_editor.dart
			pln_resolved_asset.dart
	canva/
		presentation/editor/
			pln_canva_editor.dart
	workspace/
		presentation/screens/
			pln_workspace_content.dart
```

Workspace presentation 只選擇目的頁、取得既有 session，並把產品 callback 傳入 Flow／Canva editor。它不得建立 WebView environment、註冊 JavaScript handler、解碼 bridge message、解析 editor asset 或管理 editor lifecycle。各 module 的 application／domain 不得依賴 presentation。

BlockNote 與 Canva Widget 彼此獨立。現階段不抽出共用 WebView framework；只有出現第三個實際 caller 或兩者穩定共享且可獨立驗證的產品內能力時，才另行規劃共用 helper。

## 公開與私有介面

- `PlnBlockNoteEditor` 接受 Krepis BlockNote session controller 與 Workspace presentation 提供的 opened、asset、reference、failure callbacks。
- `PlnResolvedAsset` 是 Planist editor Widget 的 typed asset 回傳值。
- `PlnCanvaEditor` 接受 Krepis Canva session controller 與 Planist failure callback。
- 上述型別只在 Planist source 內使用，不加入 Kallopis public barrel。
- bridge handler 名稱與 package asset URI 改為 Planist ownership；不得留下以 `KallopisBlockNote`、`KallopisCanva` 或 `packages/kallopis/assets/...` 為現行協定的資產。

## 資產與相依所有權

下列內容必須與 component 同批移交：

- `tool/blocknote_editor/`、`tool/canva_editor/` 及相關 verifier 移至 Planist 的 editor tooling 路徑。
- `assets/blocknote_editor/`、`assets/canva_editor/` 移至 Planist Flutter assets。
- BlockNote 的 MPL license 與 third-party notices 隨 Planist 發行資產保留。
- `flutter_inappwebview` 與只服務 editor 的 Windows override 由 Planist 直接宣告及擁有。
- Kallopis 移除 `krepis_block_note`、`krepis_canva`、editor assets 與 editor-only WebView dependency。

## 不變條件

- 不搬移或複製 Krepis 的正文、畫布、session、dirty、selection、undo 或 persistence 權威。
- 不改變 editor 的可觀察資料與事件契約；本遷移不是功能或視覺重設。
- Planist component 只使用 Kallopis public theme／foundation API，不引用 `package:kallopis/src/...`。
- 遷移期間可以依提交順序暫存兩份實作，但不得發布、合併或建立 deprecated shim；完成點只能有 Planist owner。
- Kallopis Reference 必須從實際 public barrels 產生，不得以網站 filter 隱藏仍公開的 editor API。

## 被否決方案

### 保留 Kallopis editor host，僅由 Planist 傳入 controller

否決。宿主仍直接知道 Krepis 型別、產品 callback、Web 資產與 bridge lifecycle，會使 Design System 持續承擔單一產品整合責任。

### 把 editor 程式直接搬進 `workspace/layout`

否決。畫面選擇與 WebView lifecycle 有不同變更原因，也會讓布局層再次成為產品功能實作的集中點。

### 先從 Reference 隱藏 API，稍後再搬程式

否決。文件會與真實 public surface 分歧，無法作為 consumer 契約。

### 立即建立共用 editor runtime framework

否決。目前只有兩個產品專用宿主，尚無跨產品 caller 證據；抽象化會重建 KLP-0022 已停止的中央 runtime。

## 發布閘門

只有下列條件全部成立，Editor Host Ownership v1 才能標記 Implemented：

- Planist 的兩個 editor Widget 位於 Flow／Canva module 各自的 `presentation/editor/` 子目錄。
- Workspace presentation 不含 WebView、bridge 或 asset host 實作；application／domain 不含 Flutter Widget。
- Planist 直接封裝並載入自己的 editor assets，相關 deterministic verifier 通過。
- Planist 使用現有 Krepis controller 的最高層級 editor smoke／lifecycle 驗證通過。
- Kallopis public barrels、source、pubspec、assets、tooling 與 current docs 不再擁有 Note／Canva host。
- Kallopis API Reference 重新產生並驗證，不包含 `KlpBlockNoteEditor`、`KlpCanvaEditor` 或 `KlpResolvedAsset`。
- Kallopis 與 Planist 的直接受影響 analyze 通過；IME、讀屏與互動手感保留人類驗收。
