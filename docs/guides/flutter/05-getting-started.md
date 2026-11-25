# 4. 使用高階實驗元件

尚未穩定、但已證明跨產品重用的直接 Flutter 元件可從 `kallopis_experimental.dart` 匯入。產品專用 editor host、WebView bridge、packaged asset 與 session 接線不屬於 Kallopis；它們留在產品自己的 capability module，並可在內部使用 Kallopis theme 與公開共用元件。

例如 Planist 的 BlockNote 與 Canva host 分別由 Flow／Canva presentation 擁有，Workspace 只取得既有 session 並組裝 editor。正文、selection、undo 與 persistence 仍由 Krepis／provider 掌管。

## API 查表


