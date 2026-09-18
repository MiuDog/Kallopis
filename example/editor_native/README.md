# Native editor Catalog

目前 Dart binding 建立 engine 時要求 ABI 1.29 的 Krepis DLL；須與目前 `bindings/kallopis`／Dart binding 一起重建。1.29 新增 task／toggle 狀態 query 與原子切換，1.28 新增段落／標題 checked 轉換，1.27 新增 checked ink capture。這項版本需求不代表拖曳、手寫或全部筆記 UI 已完成。

原生開啟流程必須提供 `commandLabels` 與 `modeLabels` 的完整標籤集合，見 [main.dart](lib/main.dart)。Catalog 已安裝同源 `KlpAnchoredCommands`、`KlpModeToolbar` 與 `KlpBlockControls`；固定工具列、定位選單、task checkbox 與 toggle chevron 由本庫 renderer 建立。

這是可選的 Windows 驗證入口。它從 Kallopis 套件資產載入 Noto Sans TC，並由本機 Krepis DLL 建立、排版及輸出 `KlpEditingContent`；未配置 Krepis checkout 與 DLL 時不能啟動。

目前已接入工作區尺寸重排、本庫解析風格、點擊定位、Flutter 增量文字輸入，以及由同一 core frame 提供的游標與跨行組字幾何。Windows build 與 Hidden 啟動結果不代表真實 Windows IME 互動已驗收。

Kallopis 持有焦點與平台輸入連線，產品仍只組裝 `KlpEditingContent`。正常退出會等待 `owner.close()`：先中斷輸入、取消未確認組字、保留已提交內容，再釋放來源與 engine。取消無法確認時，本入口拒絕退出，不把未知結果當成成功。

目前提供者支援套件 Noto Sans TC、字重 400、零字距且無額外 fallback；字型大小與行高須可精確表示為核心的 26.6 度量。不支援的風格明確拒絕，不會靜默替代。RTL 組字幾何目前也明確拒絕。完整字型變化、手寫及筆記功能尚未完成。

先複製 `pubspec_overrides.yaml.example` 為不納入版控的 `pubspec_overrides.yaml`，再把其中路徑改成目前 Krepis checkout 的 `bindings/kallopis`：

```yaml
dependency_overrides:
  krepis_kallopis:
    path: ../../../Krepis/bindings/kallopis
```

接著在本目錄執行：

```text
flutter pub get
flutter run -d windows --dart-define=KREPIS_DLL=<krepis_c.dll 的絕對路徑>
```

若要開啟已保存的 Krepis 文件，另傳 `--dart-define=KREPIS_DOCUMENT=<文件的絕對路徑>`。入口會先在新 owner 載入成功，再發布編輯來源；載入失敗直接回報。未提供此參數時，owner 在首次發布前以 Krepis parser 原子載入內建 Markdown，內容包含展開的 toggle、task 與一般段落，供狀態控制評估。

若要將新範例文件保存到指定位置，改傳 `--dart-define=KREPIS_SAVE_DESTINATION=<尚不存在的文件絕對路徑>`；首次明確保存時才建立檔案，既存目標由核心拒絕覆寫。這個參數與 `KREPIS_DOCUMENT` 互斥。保存後可用 `KREPIS_DOCUMENT` 重開同一檔案；兩者都未提供時維持暫存示例。

也可從 repository root 的 VS Code 啟動 **Catalog — 真實 Krepis 編輯內容 (Windows Debug)**，並在提示中輸入 DLL 絕對路徑。預設 Catalog 不依賴此套件。

## 實測紀錄

2026-09-12 ABI 1.29：區塊測試 `+14`、l10n discipline `+2`、前端架構邊界 `+155` 通過；使用 `Krepis-m0-checked-save/build/m0-checked-save/Debug/krepis_c.dll` 的 Windows Debug 建置成功。內建 Markdown 產物隱藏啟動後存活六秒，VM service 正常建立，再只終止該次 PID。獨立 owner 真 DLL 驗證另確認首次發布前得到 toggle、task、paragraph 三個區塊，純文字與 Markdown engine 均正常釋放，尾行為 `PASS: production owner opened text and Markdown documents, rendered CJK outlines and released real Krepis engines`。這些證據不代表視覺、Windows IME 或讀屏已完成實機驗收。

2026-09-11 ABI 1.28：使用本目錄未納入版控的 override 指向 `Krepis-m0-checked-save/bindings/kallopis`，並以 `build/k05-ink-isolation/Debug/krepis_c.dll` 執行 Windows debug build；尾行為 `Built build\windows\x64\runner\Debug\kallopis_editor_native.exe`，exit code 0。這次只證明 Catalog 與新增 checked text-kind API 可共同編譯，未啟動視窗，也不代表 Windows 真實 IME、格式控制 UI 或視覺呈現已驗收。

2026-09-11：可輸入版本 Windows debug build 成功；第一次 Hidden 啟動存活 8 秒，`CloseMainWindow` 在 10 秒內未結束程序，隨後已強制清理。後續查明該次取得的視窗 handle 為 0，`CloseMainWindow` 回傳 false，實際未送出關閉請求，因此不是 app 退出失敗。owner 真實 DLL 驗證尾行：`PASS: production owner opened, rendered CJK outlines and released the real Krepis engine`。

ABI 1.24 已加入核心跨行組字範圍；兩項 CTest（C ABI／FlowEditor）通過，Dart analyze 無問題，真實 DLL owner 驗證 PASS。Windows 產物為 `build/windows/x64/runner/Debug/kallopis_editor_native.exe`。修正後以非零 HWND `10094746` 呼叫 `CloseMainWindow` 回傳 true；日誌依序出現 `request received`、`owner settled`，程序以 exit code 0 結束且沒有殘留。這證明一般正常退出，不能代替組字中的關閉、Windows 真實 IME 或正式視覺驗收；RTL 組字幾何目前明確拒絕。
