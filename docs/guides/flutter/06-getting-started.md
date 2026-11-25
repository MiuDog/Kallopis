# 5. 元件缺口處理

Kallopis 沒有某個產品畫面時，產品直接建立 Flutter Widget，並沿用 Kallopis semantic theme。只有同一能力已證明跨產品重用，才提升為 Kallopis 公開元件。

禁止建立 declarative node、application host、adapter／bound model、私有 renderer、相容 shim、feature flag 或第二條產品接入路徑。
# Flutter 套件位置

Kallopis repository 根目錄維護共通規範；Flutter package 位於 `flutter/`。Consumer 的 path dependency 需由 `Kallopis` 改指向 `Kallopis/flutter`；package 名稱、公開 imports 與字型 package ownership 不變。以下指南仍適用於公開 Flutter API，Flutter 指令請從 `flutter/` 執行。

## API 查表


