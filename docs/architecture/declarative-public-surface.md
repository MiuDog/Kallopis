# 宣告式公開面清冊

狀態：2026-09-14，架構 v1 目前真相。

`package:kallopis/kallopis_declarative.dart` 是新 consumer 的唯一元件來源。公開面按 `lib/src/architecture.md` 的 L0–L7 排列；一個匯出只能有一個擁有模組與一個責任層級。Dart 能直接匯入 `lib/src` 不代表該路徑是受支援 API。

## 層級與公開類別

| 層級 | 擁有模組 | 宣告式入口公開內容 | 不公開內容 |
| --- | --- | --- | --- |
| L0 | `kernel` | 契約錯誤、節點與 placement 識別 | 模組實作細節 |
| L1 | `capabilities`、`styling` | 狀態、資料、`KlpAction`、導覽值、固定 primitive schema 與庫擁有 preset | action handler／activation、semantic schema／key／token、style reference、resolver |
| L2 | `composition` | 庫擁有節點的共同資格、adaptive strategy、受限 slot／children／screen body | definition、registry、validation／validated tree、catalog authoring |
| L3 | `foundation` | 組裝現有節點需要的平台、自適應、識別 scope 與 axis 值 | template、text semantics、prepared/bound records、component compiler |
| L4 | `runtime` | 無 consumer 匯出 | adapter、compiler、installation、resource、transaction |
| L5 | `features` | 已登錄 editing、workspace/layout 節點及其資料／語意事件；受限 Krepis session 資料契約 | feature adapter、semantic definition、prepared record、rail authoring資格、renderer callback |
| L6 | `rendering` | 無 consumer 匯出 | Flutter renderer、host Widget、實現分支 |
| L7 | `application` | `KlpApplication`、`KlpScreen` 與由 application library part 提供的 router／啟動入口 | session、host、環境安裝、adapter catalog |

## 組裝與擴充規則

- Consumer 只能建立此入口已公開的具體節點，並在節點建構子提供的具名插槽中組裝其他已公開節點。
- `KlpNode`、`KlpSlot<C>` 等資格只描述庫擁有節點之間的結構限制；實作資格不會把 consumer 型別加入 catalog。
- 樣式輸入只有完整 `KlpPrimitiveSet`。Semantic key、schema、reference 與 template 都由 Kallopis 元件擁有者在庫內定義。
- Consumer 可以傳入 `KlpAction`，但 action 的 activation、handler、placement lease 與派送生命週期由 application/runtime 擁有。
- 新元件必須經過擁有模組的架構切片，建立唯一 identity、受限插槽、庫擁有 adapter 與 renderer 分支；不能以公開 registry、definition 或自訂 rail item 動態加入。

## 目前刻意不公開的舊實驗面

下列類別仍可能存在於套件內部測試或實作，但不得從宣告式入口重新匯出：

- `KlpComponentDefinition`、`KlpDefinition`、`KlpRegistry` 與 `KlpValidated*`。
- `KlpActionActivation`、`KlpActionHandler`。
- `KlpTemplate`、`KlpTextSemantics`。
- `KlpStyleRef`、`KlpSemanticKey`、`KlpSemanticSchema`、`KlpSemanticToken`。
- `KlpRail`、`KlpRailItem`；目前沒有已公開且可實際組裝的庫擁有 rail item，工作區導覽動作使用 `KlpWorkspaceBlock`。

封閉邊界以 consumer 編譯契約保護；庫內測試應明確匯入其所測模組，不得依賴宣告式入口洩漏內部型別。

## 已接受的 HOST-PORTS-V1-r1 遷移

L1 新 `KlpPickFileAction` 只提供資料與回呼，不公開 port 或自行派送。舊 `KlpLocalFilePicker` 移出現行 declarative，改由 application 所屬專用 `kallopis_legacy_file_picker.dart` 保留零 host 相容；Stable roots 不變。E/P 實作驗證待完成，詳見 [遷移契約](host-ports-plan/public-migration.md)。
