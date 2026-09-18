# 檔案選取公開遷移

現行 experimental 宣告式應用把選檔意圖放在既有工作區動作：`KlpPickFileAction(acceptedExtensions: const ['png'], onPicked: receivePath)`。仍從 `package:kallopis/kallopis_declarative.dart` 匯入，交给既有 `KlpWorkspaceBlock(action: ...)`；消費端不自行呼叫 picker 或注入 platform port。應用更新、導覽或卸載使原操作世代失效後，不交付其晚到結果。取消不回呼，平台與 callback 例外交給唯一宿主。

維護舊零宿主 utility 的使用者改從 `package:kallopis/kallopis_legacy_file_picker.dart` 匯入 `KlpLocalFilePicker`。原 const constructor、acceptedExtensions、onPicked 與 `await picker.pick()` 保留；取消正常完成，成功回呼一次，plugin/callback 例外沿原 Future 傳播。此入口是明確 legacy 相容面，不供新宣告式樹組裝；沒有 global fallback。後續刪除仍受 P9 保護。

其餘五個既有根 library 內容與所有 Stable foundation 型別保持；只替換 declarative 的 concrete picker export、增加 capability action export，並新增專用相容入口。
