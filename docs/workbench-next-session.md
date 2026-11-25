# Workbench 新 session 交接（2026-10-13）

本檔是本次交接的優先入口。舊 `docs/workbench-handoff.md` 的進度數字已過時，不可據其重做已完成工作。本次只整理交接，沒有實作新的風格修改、push 或標記完整目標完成。

## 使用者已授權的完整目標

- 框架無關的視覺語意、token、元件合法組合；Flutter／React 位於第一層目錄，同步交付。
- 通用 Workbench：拖放停靠、分割、縮放、分頁、布局保存還原、工具列／選單、命令面板、快捷鍵註冊、chord、作用域及衝突處理。正文／程式碼／3D／終端核心由產品或上游擁有。
- docs 所有可渲染元件頁面有真正可互動的專屬展示；用本庫元件復刻 VS Code／Blockbench／Blender 使用場景，整合到網站。
- 可替換風格檔，元件中立，盡量公開風格參數，修改風格不得破壞布局語意。
- 必要驗證、更新 docs，最終提交並 push 到既有 GitHub。
- 最新優先要求：降低按鈕底色與周圍表面的對比，保留文字可讀性；版面區塊之間的「總間距」統一 8px，由布局單一擁有。不是將所有字級、內距、高度改成 8。

不要重問這些已接受事項。完整目標尚未完成；尚未 push。

## 工作樹與保護規則

- 實作唯一接續工作樹：`C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis`。
- 2026-10-13 交接時 HEAD：`e94546875d449cca8743d88f6707cebcf8109d3f`，detached HEAD；已檢查只有一個 untracked：`styles/test/compact-default-style.test.mjs`。
- 主目錄：`D:/Projects/Kallopis`，分支 `codex/productivity-reference-ecosystem`，HEAD `e9e8724e880a4848a38bc735f787749ca5c82951`；大量既有未提交變更要保留，禁止 reset、clean、無差別 stage。避免把全量 status 印出，只讀摘要與精確路徑。
- 主目錄同步紀錄 `build/workbench-last-sync.json` 的 sourceRevision：`458c01aafb2e6cf8c63584518768e70d38b20496`。後續 advanced form 與最新風格計劃尚未同步。
- GitHub：`https://github.com/technis-toolbox/Kallopis.git`。最終完整整合後才 push；如建立 PR，必須 attach artifact。
- 使用 `D:/Projects/Kallopis/build/guarded-workbench-sync.mjs`，先讀腳本介面，逐檔比較旧／新來源、保護主目錄 index。衝突停下，不覆蓋他人內容。
- 所有程式縮排用 tab，顯示寬度 2，繁體中文註解；不跑 Dart format。
- 先讀 AGENTS.md；依 intent 只讀相關 skill。BUILD 必須有 READY architecture 與 fresh Task Packet，精確 write paths；tests／architecture 預設唯讀。必要新測試由隔離 Test Author，不能改弱測試取得 Green。

## 第一個可直接執行的步驟：柔和按鈕與總間距 8px

已接受 root plan：isolated `architecture.md` 的 `COMPACT-DEFAULT-STYLE-1`，修訂 `COMPACT-DEFAULT-STYLE-r1`，owner commit `e9454687`。`styles/architecture.md`、`flutter/architecture.md`、`react/architecture.md` 已有跨模組契約。

獨立 Test Author 已完成但尚未 commit：

- 檔案：`styles/test/compact-default-style.test.mjs`。
- SHA256：`58ED0A47D661F7DD2886EF2EBFD4A842387E4EAA3FFD4B2DFDF0A85379F2A5C8`，本次交接再次確認相同。
- packet：主目錄 `build/task-packets/compact-default-style-test-1.json`。
- 已報告行為 Red：`node --test styles/test/compact-default-style.test.mjs`，8 tests／0 pass／8 fail／0 skip；四模式分別測按鈕填色對比 <2.5 與布局 gap 8／dockMargin 0。現值 light 對比約 15.61，dark／transparent 約 12.76；itemGap 12、groupGap 16、navigationSectionGap 6、base 16、dockMargin 4。
- Parent 下一步：讀測試、重新執行同一 Red、確認 exact-one-file scope／hash，精確 commit 該測試。不得重寫或降低要求。
- 然後以測試 commit 為 base 建立新的 implementation Task Packet。尚未建立此 BUILD packet，也尚未修改任何風格值。

實作方案：正式資料權威仍為 `docs/design-tokens/semantics.md`，不改舊 JSON／CSS／ZIP 匯出快照，也不修改 primitives 影響其他語意。

- `theme.colors.brand` 四模式：light → `p(parchment250)`，dark／transparent → `p(parchment700)`，ultraDark → `p(ink700)`；文字使用既有 primaryForeground 算法；accent／interaction／status 保持原語意。
- `theme.spacing.itemGap`、`groupGap`、`navigationSectionGap`、`base` 四模式 → `p(space200)`。
- `theme.geometry.layout.dockMargin` 四模式 → `p(space0)`，避免既有 8px handle + 兩側各 4px margin = 16px。
- space2／contentStackGap／chromeGap／resizeHandleExtent 已是 8，保持。
- Flutter／React specimens 與 GUI 的「寬鬆風格」目前 override contentStackGap 24／actionGap 12，改成只 override `theme.components.buttonPaddingX` → `p(space600)`，保留風格差異且不改總 gap。

**先處理一個未確認風險**：檢查 Flutter `buildKlpTheme()` 在不傳 stylePack 時是否仍走 legacy preset。若確認預設主題繞過生成 pack，必須由架構 owner 更新契約與精確寫入範圍，再實作；不能只改 examples 就宣稱所有預設按鈕都已更新，也不能建立第二份預設值權威。用 rg 找 builder，勿猜檔名。

目前 root plan 授權的 13 個 BUILD 路徑：

1. `docs/design-tokens/semantics.md`
2. `styles/kallopis-v1.json`
3. `flutter/lib/src/styling/style_pack/generated.dart`
4. `flutter/lib/src/styling/style_pack/source-manifest.json`
5. `react/src/generated.ts`
6. `react/src/tokens.css`
7. `react/src/source-manifest.json`
8. `react/src/style-pack-data.ts`
9. `react/src/style-pack-manifest.json`
10. `flutter/example/lib/component_specimens.dart`
11. `flutter/example/lib/gui_scenarios.dart`
12. `react/example/specimens.tsx`
13. `react/example/scenarios.tsx`

M1：正式值／生成資料／freshness／共同測試。M2：雙框架檢查、build、實際瀏覽器按鈕與總 gap 8、換風格時資料保留。M3：docs、guarded sync。視覺品質與手感仍由人類接受，不能靠計算宣稱感官完成。

## 已完成與待驗證的最新進度

Flutter 已真正完成專屬互動與原生瀏覽器驗證：**176／273**；尚缺 **97**。React **23** 個公開可渲染元件已具专屬展示。網站全量 manifest 為 **561** canonical declarations／17 modules／3 surfaces；這個數字不等於所有 Flutter 展示已完成。

最近完成：

- Layout utility 10：Adaptive、DeviceAdaptive、EnvironmentScope、Masonry、VirtualGrid、VirtualList、ResizablePane、ResizeHandle、SlidingDrawer、SplitLayout。Masonry 空 children 的 clamp 例外已修復；受保護 2 checks Green，原生空／還原確認。
- Form composition 9：Form、FormActions、ErrorSummary、Section、FieldGroup、Compound、Conditional、Repeater、KeyValue。callbacks／停用／空內容／還原與草稿保留已原生驗證。
- FormSection 鍵盤修復：改用既有 KlpActionRegion，Tab／Enter／Space 可切換，單一 accessible label，null callback 為靜態標題。受保護 4 checks Green，實際 native keyboard 與草稿保留通過。完成同步 revision `458c01aa`。
- 命令註冊、toolbar／menu／palette／popup、快捷鍵 pure core 與 host、兩框架 consumer 已有各自檢查與原生紀錄；不要把 core 通過誤算完整 Workbench stage 關閉。
- 3 個 GUI 場景 × 2 框架已有實作，仍需最終完整風格／互動／網站整合稽核。

**Advanced forms 14：只完成 source、analyze、release web build；native 尚未執行，不計入 176。**

- Owner `7c2f7793`；source `57a40b9a`；checkpoint `c6ed8071`。
- 來源 `flutter/example/lib/advanced_form_specimens.dart` 與 host `component_specimens.dart`；packet 主目錄 `build/task-packets/flutter-advanced-form-specimens-1.json`。
- 名單：KlpApprovalStepsField、KlpCalendar、KlpCodeEditorField、KlpCodeField、KlpColorRoleField、KlpCombobox、KlpDateField、KlpDateRangeField、KlpFileDropzoneField、KlpFileField、KlpOklchColorEditor、KlpOklchColorPicker、KlpReferencePicker、KlpStatusRoleSwatches。
- public analyze No issues；release web build 55.2s 成功。bundle 仍在 isolated `flutter/example/build/web`，尚未複製至 preview／main。
- 最新按鈕／gap 工作完成後接著 native 14。檔案選擇為明示宿主 fixture callback，不能聲稱真实磁碟選檔或 upload/drop engine。CodeEditorField 是靜態 code/actions 與宿主控制，不是自研编辑器核心。DateRange 的入口只是宿主 callback，不聲稱內建 range popup。DateField 的文字 callback 與 calendar callback 要分別觀察，不可泛稱全部停用。
- 若需要改 source，發 fresh resume packet；不能拿舊 base 跨越新 style commits 後仍宣稱 exact scope 通過。

## 其餘必須完成的工作

- 補齊並原生驗證剩餘 Flutter 元件（14 通過後才是 190／273，剩 83）。
- Flutter docs manifest ↔ 專屬 registry ↔ iframe 的 fail-closed coverage gate；禁止用 coverage metadata 補數。
- React 實際 Dock 拖放／resize 仍待確認，曾嘗試 HTML drag 未移动；雙框架 continuous preview／cancel、鍵盤可達性與 IME 稽核。
- 風格中立、所有參數、極端尺寸／style layout 語意保護，確認預設權威接入。
- 實際窄瀏覽器／docs 驗證；目前 IAB viewport set 在 tab 13／15 **沒有生效**，仍 1280×720。局部 320 constraint 不等於 browser viewport。不要把名字含 narrow 的舊 PNG 誤當窄證據。
- 更新正式 API manifest（core 註解／公開 source 最後整合後）、雙站生成驗證、原 CI／release gates、精確提交／最終 push／實際 Linux CI。

## 常用命令與證據位置

以下在 isolated repo root 執行（Flutter build 例外）。生成輸出需比對實際 scope；runtime copy 若出現非預期差異，停下查因，不擴大 packet。

```text
node styles/scripts/migrate.mjs
node styles/scripts/migrate.mjs --check
node flutter/tool/generate_style_pack.mjs
node react/scripts/generate-tokens.mjs
node react/scripts/generate-style-pack.mjs
node --test styles/test/compact-default-style.test.mjs
node .agents/skills/incremental-implementation/scripts/check-task-scope.mjs --packet D:/Projects/Kallopis/build/task-packets/<fresh-packet>.json --repo .
node tool/reference_site/generate.mjs --react --react-scenes --flutter-scenes
node tool/reference_site/verify.mjs --react --react-scenes --flutter-scenes
```

React package `npm run build`；example `npm run build:example`，按 package scripts 的 cwd 使用。

Flutter example cwd：`C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis/flutter/example`。

```text
D:/flutter/bin/flutter.bat build web --release --no-tree-shake-icons --base-href /Kallopis/examples/flutter/
```

web bundle 複製至 isolated `build/reference-site/examples/flutter`，既有 prefix preview port 5203、`build/prefix-preview/Kallopis` junction 指向 reference-site；先檢查 server 是否還活著，不依賴旧 PID。主目錄 bundle 在 guarded sync 後才更新。

主目錄 ignored 證據：`build/flutter-layout-utility-native.json`、`build/flutter-form-composition-native.json`、`build/flutter-form-section-keyboard-native.json` 及對應 PNG。JSON 可能含歷史 Red，要看 final/fixed 記錄。

CUA 新 session 重新取得 browser／tabs，不可假定舊 JS bindings 存在；承接 computer task 時先 `await cua.rewriteDocumentation()`。所有互動用真實 UI API，DOM evaluate 只讀，禁止合成事件／DOM 寫入。原有 IAB specimen tab 13 曾在 `http://127.0.0.1:5203/Kallopis/examples/flutter/index.html?specimen=KlpFormSection`，實際新 session 要重新列舉。

## Goal 狀態

本次讀取舊 thread goal：objective 是上述完整目標，status **blocked**，tokensUsed 8583284，timeUsedSeconds 69326。這是舊 thread 的工具狀態，並不表示目前沒有可做工作；最新風格 slice 可直接繼續。交接不修改它，也不聲稱完整目標完成。新 session 請依使用者的續作／goal 指示建立自己的目標，不嘗試跨 thread 修改旧 goal。
