# Kallopis BlockNote renderer

此目錄產生正式封裝於 Kallopis package 的本機 BlockNote Web 資產。依賴版本由 `package-lock.json` 固定，不需要全域 Node 套件，也不依賴開發伺服器。

## 重建資產

```powershell
cd D:/Projects/Kallopis/tool/blocknote_editor
npm ci
npm run build
```

輸出位於 `D:/Projects/Kallopis/assets/blocknote_editor/`。Vite 將程式、樣式與字型合併進單一 HTML；範例圖片與授權文件維持獨立本機資產。

## 建置 Windows Catalog

`flutter_inappwebview` 的 Windows 建置需要 NuGet CLI。將官方 `nuget.exe` 放在專案忽略的 `build/tools/`，只對目前程序補 PATH：

```powershell
$env:PATH = "D:\Projects\Kallopis\build\tools;$env:PATH"
cd D:/Projects/Kallopis/example/editor_native
D:/flutter/bin/flutter.bat build windows --release --target=lib/block_note_main.dart --dart-define=BLOCKNOTE_DOCUMENT=D:/Projects/Kallopis/build/blocknote-acceptance.json
```

執行檔位於 `example/editor_native/build/windows/x64/runner/Release/kallopis_editor_native.exe`。`BLOCKNOTE_DOCUMENT` 是此次執行使用的文件 envelope 路徑；省略時使用 `%LOCALAPPDATA%/Kallopis/blocknote-catalog.json`。

BlockNote 及其 adapter 版本與授權通知見 `public/THIRD_PARTY_NOTICES.md` 和 `public/LICENSE-MPL-2.0.txt`，兩份文件會隨正式資產一併封裝。
