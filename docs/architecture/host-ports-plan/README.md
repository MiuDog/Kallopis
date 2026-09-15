# HOST-PORTS-V1-r1 環境與檔案選取配對

APP-V1-05／FEAT-V1-06 complete。見[驗證](verification.md)與[執行證據](execution.json)。

HOST-PORTS-V1-r1 接受 APP-V1-05／FEAT-V1-06 的 E 環境與 P 檔案選取配對。Capabilities 持有純環境解析及既有 KlpAppPlatform／KlpAdaptiveMode 唯一宣告，Stable foundation 原 facade、型別與 current(Size?) 行為保留；application 唯一既有 host 採樣並安裝，不增加 observer、store 或預設。P 接替已接受的 concrete picker 宣告式面：公開 L1 KlpPickFileAction，port/result 套件內部；application 唯一 plugin adapter，既有 action handler 用原 frame/lease/epoch/entry 在 await 前後檢驗。有效 selected 才回呼一次，cancel/stale/failed 為 false，平台或 callback error 原物件／stack 由 host 一次回報。舊零 host picker 搬 application/legacy 並由專用 legacy root 保留 const/欄位/pick Future 成功取消與原 error 傳播；不作現行宿主 fallback。公開 roots 6→7，僅 declarative 一增一刪及新 legacy，feature exports 67→66，24 components/28 IDs/順序保持。原 R1/APP06 root/hash/closure/catalog 基準依 path-map 精確增減由獨立作者更新，不 blanket resnapshot 或放寬原守衛。E 單獨不完成 APP05；E/P 與完整證據通過才 APP05/FEAT06 complete。

[精確 API、純解析與生命週期決策](path-map.json)、[獨立測試責任](test-packets.json)、[公開遷移](public-migration.md)。完整細則採外置已查核 HOST-PORTS-V1-r1 提案的環境採樣時機與 query precedence，並於 path-map 固定。

E 三個單模組 packet；P capabilities/application/features 三個單模組 packet及 Steward root整合。每個 packet 必須乾淨 base_revision／architecture SHA／精確 writes，跑實際 scope checker。E/P 分別 independent Test Author，所有 protected測試只能依精確 approved delta 調整。

冷啟動估计：E BUILD8k–15k／50–110min；P8k–14k／50–100min；作者各7k–16k／45–100min。M1 source/API/scope，M2 frozen tests／整合；超過22k或150min回報具體異常。環境與 P 都完結後才標兩切片 complete；最後還需全50ID證據稽核及執行既有CI適用閘門，不宣稱原生dialog感官通過。
