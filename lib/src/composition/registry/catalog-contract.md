# 封閉目錄的建構與驗證邊界

本文件對應 `COMP-V1-02`；權威為 [composition 架構](../architecture.md) 與 [CC-V1-r1 共通契約](../../../../spec/module-architecture-v1.md#closed-catalog-completion-contract--cc-v1-r1)。目錄內容由本庫宣告與轉接器決定，本文件不另列一份元件清單。

## 唯一建構流程

1. application 的零參數 `klpApplicationAdapters()` 明確組裝完整內建轉接器，包含結構節點及內部項目。使用端不能附加、覆寫或遮蔽身分。
2. runtime 從本次轉接器的 `contract` 建立 `KlpRegistry`，並使用 composition 的 `captureKlpTree` 擷取／驗證一棵樹。runtime 不探索功能、不讀取清冊 JSON。
3. composition 驗證定義、相依圖、節點型別與受限插槽，交付不可變結構快照。runtime 在全樹準備成功後才安裝資源；rendering 不重新讀取宣告節點 getter。

`KlpDefinition` 與 `KlpRegistry` 的套件內建構子必須保留。本庫轉接器需要建立定義，獨立測試需要建立有限的契約或故障案例。它們沒有從 `kallopis_declarative.dart` 匯出；直接匯入 `lib/src` 不會使該路徑成為受支援使用端 API。

使用端可以實作資格介面，但未列入本庫目錄的身分仍不成立。測試 adapter 僅供隔離的內部契約／交易測試，不得經 application 或公開 barrel 注入。composition 不匯入 runtime adapter、features 或 application，也不自行組裝功能目錄。

## 驗證與錯誤責任

| 階段 | composition 責任 | 證據／錯誤 |
| --- | --- | --- |
| 定義建立 | 語意擁有者與定義 ID 相同；插槽屬於該定義且名稱不重複 | `semantic_owner_mismatch`、`slot_owner_mismatch`、`duplicate_slot` |
| registry 建立 | ID 非空、定義不重複、相依存在且無循環；請求 styling 驗證語意圖 | `empty_id`、`duplicate_definition`、`unknown_definition`、`dependency_cycle`；語意求值權威仍在 styling |
| 樹擷取 | 每個結構 getter 只讀取一次；拒絕未知身分、重複放置或不符宣告型別 | `unknown_definition`、`duplicate_placement`、`node_type_mismatch` 及既有擷取契約診斷 |
| 插槽驗證 | child 資格、owner、型別、數量與指派均符合本庫定義；保留驗證後順序 | 既有 slot／composite 契約診斷；後續階段只讀已封存快照 |

上述違約透過 `KlpContractError` 回報，並在資源安裝前失敗。runtime 掌管安裝／交易／回滾與已提交失敗；rendering 掌管平台實現錯誤，composition 不建立資源或租約。

## 配對完成條件

- features 清冊與 application 結構清冊的身分聯集精確等於實際轉接器展開結果；在轉成集合前拒絕重複，亦拒絕缺漏、額外項目或錯誤權責。
- 移除 runtime 舊 `components`、context compiler、component adapter 與 foundation 舊 component definition/compiler；application 不再傳空舊參數。必要的 composition 建構子保留。
- 既有內建應用程式可提交，未知身分在建立資源前失敗；使用端負向編譯測試的控制組／匯入正常，錯誤落在禁止的撰寫入口。
- 單次擷取、插槽、交易、資源重用、回滾、已提交失敗及租約等保留行為，由獨立 Test Author 的局部檢查提供證據。

本文件完成只代表 composition 建構責任已固定。整組完成由 [配對計畫](../../../../docs/architecture/closed-catalog-plan/README.md) 的共同證據判定；不單憑本文件將 runtime、foundation 或 composition 的配對切片標為完成。
