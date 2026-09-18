# 新 session 交接

2026-09-12。使用者已同意採用 BlockNote，正在接入 Flutter Catalog 的本地編輯與宿主保存流程。舊清單 ABI 1.34 成果保留，並非當前開發方向。

## 當前方向：採用 BlockNote

2026-09-13 畫布分期：使用者確認第一版不要求 Concepts 等級的筆刷、壓感與精準編輯，後續版本會加入。第一版先接成熟畫布引擎的基本繪圖能力；進階需求保留，不作第一版驗收門檻，也不因此延後其他已確認畫布功能。畫布引擎尚未選型，詳見 [總入口分期](architecture/note-components-plan.md)。

2026-09-13 使用者已澄清方向：**Planist → Krepis 統一筆記接口 → BlockNote 正文引擎**；Kallopis 負責呈現與 WebView。自研正文核心及其專用 binding／呈現路徑標註 **暫時棄用**，保留程式、測試、舊資料與回退，不再作新正文功能預設方向。Krepis 統一接口與可重用身份／保存能力保留；手寫／Spatial 不在本次棄用範圍。依 [KLP-0020 補充決策](../spec/decisions/KLP-0020-blocknote-editor-adoption.md) 執行。

2026-09-13 最新核對：另一任務已完成 Krepis BlockNote 接口抽取，現行路徑為 Planist → `krepis_block_note` → Kallopis WebView／BlockNote。文件封套、session、保存／關閉契約的實作在 `D:/Projects/Krepis/bindings/block_note`，Kallopis 原 controller 檔僅 re-export；Planist 已使用 `KrepisBlockNoteSessionController`。本任務沿用該成果，未重新建立第二份接口，也未修改被本任務禁止寫入的 `D:/Projects/Krepis`。允許工作的 `Krepis-m0-checked-save` 尚未同步該新套件，後续勿誤以為兩樹已一致。

本輪確認 Planist `runtime_files_test.dart` 7 項通過，含正式 bootstrap 保存後重新啟動從磁碟讀回。先前保留的 `workspace_flow_persistence_test.dart` 由測試作者補正 extension import、現行 messageIdStart 協定與 Windows 路徑比較後，兩項完整回歸通過：dirty／保存中禁止切走或關閉、保存後切回最新內容、再次編輯保存、舊訊息拒絕、替換失敗保留原文並清暫存。測試未降低要求；最終 SHA256 `358EBF19B54D8E736780A0B3FA3B8FD189845D50A763CD34F9B731E2FFDCA236`。證據：`build/planist-krepis-blocknote-verification.log`（runtime 7 項通過，當時舊測試入口失敗）及 `build/planist-flow-persistence-verification.log`（修正測試接線後 2 項通過）。目前統一接口與保存／切頁接入已可用；本輪沒有重新建置或操作原生 Planist 視窗，不以這些測試宣告 OS IME、系統剪貼簿或完整第一版已驗收。

Kallopis 已獨立修正保存後重開快照與單調橋接序號，5 項 session 測試及定向分析通過，正式 assets 已重建。測試作者補兩個動畫幀的選取／渲染同步等待後，完整 headless 流程通過，含重開後再次編輯；未放寬斷言，不代表 OS IME 已驗證。

使用者已同意正式採用 BlockNote，依 [KLP-0020](../spec/decisions/KLP-0020-blocknote-editor-adoption.md) 推進。首輪 Catalog 接入與宿主保存已實作，正式 release 已重建；隔離測試及真 WebView 快照往返見下節。入口與重建命令見 [BlockNote README](../tool/blocknote_editor/README.md)。本輪已補隔離環境的清單鍵盤／貼上、Flutter 退出請求與載入錯誤恢復。原生 OS IME、焦點及系統剪貼簿仍待允許的驗收環境；Planist 統一接口已核對並通過保存／切頁回歸，不恢復擴充自研正文核心。既有原型與 [比較結果](architecture/editor-library-comparison.md) 保留；舊文件尚未轉換。下方 ABI 1.34 為保留成果，不能誤當當前開發方向。

## BlockNote 本輪隔離驗證

使用者要求改用沙盒測試後，採本機無頭瀏覽器、專用暫存文件及隱藏原生診斷程序，不操作前景桌面；不是 Windows Sandbox 虛擬機。

- 保存／橋接 controller：5 項必要測試通過；`build/blocknote-session-tests.log`。
- 正式本地資產：中文輸入、清單 Enter／Tab、undo／redo、跨區塊貼上、表格／自包含圖片、快照與新頁重開通過；`build/blocknote-assets-headless.log`。單檔 HTML 另以 `file://` 確認橋接建立；`build/blocknote-headless/file-url-diagnostic.json`。畫面證據 `build/blocknote-headless/reopened.png`。
- 真 Windows 檔案 adapter：專用暫存目錄寫入、替換、重讀與唯讀目的檔保存失敗保留原文通過；`build/blocknote-file-store-tests.log`。不等於斷電耐久性驗證。
- Windows 編譯通過，首次原生視窗空白；背景診斷確認 renderer 尺寸、WebView2 及本地檔案載入成功，但舊 bundle 呼叫橋接時入口不存在。改單檔資產與有界初始化後，真 WebView2 已完成 `ready → open → snapshot.response → saved`；`build/blocknote-native-snapshot.stdout.log`。此證據含臨時診斷旗標，不等於 OS IME、前景鍵盤／貼上或原生關閉重開驗收。

- Catalog Flutter 退出請求：dirty 與保存中取消退出，確認保存後允許退出；`build/blocknote-exit-tests.log`。這是 binding 的實際生命週期 dispatch，尚非 Windows 視窗管理員的關閉操作。
- 載入恢復：首次失敗可重試，重複重試去重，首次成功後禁止重送初始文件。背景 widget 渲染／點擊確認錯誤回饋保留原編輯器狀態、不 dispose、不遮住保存入口；`build/blocknote-load-surface-tests.log` 與 `build/blocknote-widget/` 截圖。
- 本輪新版 Windows release 已重建成功；曾被共享工作樹另一工作區元件的編譯錯誤阻擋，對方修復後建置通過，未覆蓋該檔。平台改用宿主 capabilities；既有架構邊界 155 項通過。
- 公開 consumer 用法見 [BlockNote 編輯器](ai/blocknote-editor.md)。Planist 已由 `pln_bootstrap.dart` 建立 Krepis session，Flow 插槽與 `PlnWorkspaceController.beforeLeaveDocument` 承接編輯及離開保護。

保護測試由 Astra 維護：`test/klp_block_note_session_test.dart`、`tool/verify_blocknote_assets.cjs`、`example/editor_native/test/block_note_file_store_test.dart`；實作者不得改測試要求取得通過。

## Planist 第一版工作區組裝

核准的 HTML 第一版已轉為宣告式工作區元件，並組裝於 `D:/Projects/planist/frontend`。共用 API 見 [工作區元件](ai/workspace-components.md)，產品元件樹、執行方法與驗證現況見 `D:/Projects/planist/docs/planning/workspace-component-tree.md`。此項是畫面與受控互動組裝；尚未把 BlockNote 正文保存流程接入 Planist，不取代上方編輯核心交接。

## 工作樹與按需閱讀

只讀 AGENTS、本頁，再選目前功能的一份契約。流程以 AGENTS 連結的 lean-development skill 為唯一來源；不要再載入舊對話或全部計畫。

- Kallopis：`D:/Projects/Kallopis`，共享 dirty 工作樹，清理前約 939 筆變更。
- Krepis：**只用** `D:/Projects/Krepis-m0-checked-save`，清理前約 61 筆變更。不得改 `D:/Projects/Krepis`／Designist。
- 不 reset、清除、全量 stage 或覆蓋他人架構改動。先核對指定檔案的當前內容。
- 品牌保留 Kallopis／Klp；沒有改名任務。

## 目標與已確認決策

完整範圍：[筆記總入口](architecture/note-components-plan.md)，包括 Notion／Concepts／Miro 蒸餾與 Kallopis／Krepis 實作；Planist 第一消費者、可操作 Flutter Catalog、AI 使用文件。

控制密度 A、Noto Sans TC、控制行高 18；一般工具列固定頂端，區塊操作跟隨選取；取消未確認組字、保留已提交內容。consumer 只組裝受限節點與資料，不提供原生 Widget 或局部風格。具體已確認視覺按需查設計知識。

## 真正停下的位置

- ABI 1.32 的 range／清單交易、投影、Flutter 清單選單與把手焦點 Tab／Shift+Tab 已接線；精確前綴原子轉清單與真實 before snapshot undo 已實作。
- ABI 1.33 StyleV2（96 bytes）及 marker info（88 bytes）已接 C++／Dart／provider；核心共用 render、hit、caret、composition、selection、block visual／drag geometry，Kallopis 按 command range 映射 listMarker。
- 本輪真實 provider 測試暴露並修正：尚未安裝 list style 或 viewport 外沒有 marker 時，Dart 應將 NOT_FOUND(3) 視為無同幀 marker，而非同步失敗。先前對使用者稱狀態 3 為 INVALID_STATE 不正確；本次診斷已更正。已有 marker 的 range 長度與重疊拒絕保留。
- 使用者已關閉 Smart App Control，本機 registry 核對為 0；不再以原 Windows 4551 封鎖當作目前阻擋。Dart 實際入口為 `D:/flutter/bin/dart.bat`；原生測試需將 build/m0-checked-save/Debug 加入該程序 PATH 尋找 DLL。

## 驗證與下一步

目前 ABI 1.34 清單連續編輯已完成產品接線：正文 Tab／Shift+Tab、Enter split、空項 Enter outdent／paragraph、項首 Backspace merge；核心與 history 保留文字、marks、attributes。Flutter Enter 只接 performAction(newline)，避免 keydown 雙送；Ctrl／Alt／Meta、非文字模式、interruption、active composition 與非折疊選取有 guard。

限制：僅 collapsed text caret；跨區塊／區塊選取拒絕；縮排需要合法前項；merge 與 ink reanchor 不合法時原子拒絕。split 的 ink 保留原 primary，新 secondary 無 ink。explicit restart 的資料問題未解。

Astra 在既有真 DLL provider 入口加入必要測試，Sol 完成產品；`bindings/kallopis/tool/provider_command_checks.dart` SHA256 `25964E39FEF5A261ADFD426A60B83E0E5D33D3F4B1D950AFE064656046068BAF` 實作後未變。

本輪重建與執行均 exit 0，證據在 `D:/Projects/Krepis-m0-checked-save/build/`，各附同名 `.exitcode`：

- `list-edit-final-build.log`：DLL、Flow 與 C ABI target 重建；仍有 C4389 signed／unsigned 編譯警告。
- `list-edit-final-provider.log`：真 DLL 流程含 marks、分項／合併、縮排／退出、undo／redo、stale、composition；另有 CJK outlines PASS。
- `list-edit-final-flow.log`、`list-edit-final-abi.log`：all checks passed。
- `list-edit-final-kallopis-analyze.log`：No issues found。

舊路徑原訂驗收見 [清單切片計畫](architecture/list-blocks-contract-plan.md)，目前暫停，不作為 BlockNote 接入的前置工作。現有 renderer 已接操作，但無既有 editing widget/input harness；本輪沒有新建框架，performAction／修飾鍵／composition guards 尚未 Flutter runtime 驗證，手機段首 Backspace 亦無實機證據。marker 裁切、重排／undo 後畫面、拖曳、Windows IME 與讀屏仍不能標通過。未完成這些條件前，不宣告整條切片或完整清單交付。

## 後續範圍

完整筆記、手寫平台接線、Spatial、Planist、Catalog 與 AI 文件範圍保留，按 [總入口](architecture/note-components-plan.md) 一次收斂一條流程；不例行重跑已通過主體。Deep Research 可用於未確認行為的來源蒸餾，已確認契約直接沿用，不每項重做研究。

## 文件與背景

前次上下文清理沒有改產品程式、測試、CI 或 Git 歷史；本次續作已修改上述產品與必要測試，未提交或全量 stage。舊進度／測試日誌的專案外备份位置见 [清理紀錄](context-cleanup.md)；只有追查特定歷史才開啟。工具所列歷史 agent 名稱不是存活證據，不沿用舊代理等待狀態。
