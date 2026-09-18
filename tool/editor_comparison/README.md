# 編輯器比較原型

兩個原型各自獨立，不依賴 Kallopis 產品程式。「載入範例」與「載入長文」不會寫入存檔；只有「儲存」會覆寫上次本機存檔，「重開」會放棄目前未儲存修改並回復存檔。

## BlockNote

```powershell
cd D:\Projects\Kallopis\tool\editor_comparison\blocknote
npm install
npm run dev -- --host 127.0.0.1 --port 4181
```

瀏覽 `http://127.0.0.1:4181/`。實際解析版本固定於 `package-lock.json`；核心 BlockNote 套件為 0.54.2。

## AppFlowy Editor

```powershell
cd D:\Projects\Kallopis\tool\editor_comparison\appflowy_editor
D:\flutter\bin\flutter.bat pub get
D:\flutter\bin\flutter.bat run -d web-server --web-hostname 127.0.0.1 --web-port 4182
```

瀏覽 `http://127.0.0.1:4182/`。`pubspec.lock` 固定實際依賴。pub.dev 最新 6.2.0 無法在本機 Flutter 3.44.2 編譯，因此原型固定已修正該相容性的官方主分支 commit `01eccc6ee36bd07698bd80915289fe7070478cd2`，未 fork 或修改上游程式。

圖片範例在 Web 上以當前網站的絕對 URL 讀取打包內的本地 PNG，因為上游 image block 會將相對路徑當作本機檔案。本輪只建置與驗證 Web，Windows native 尚未建置或驗證，不能由此原型推論 native 的圖片或輸入品質。
