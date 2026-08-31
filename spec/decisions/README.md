# Kallopis 決策文件

## 索引

| 編號 | 題目 | 狀態 |
|---|---|---|
| [KLP-0001](KLP-0001-scope-token-architecture-and-extraction-method.md) | 範圍、token 架構，與「複製搬移」這個例外 | Accepted |
| [KLP-0002](KLP-0002-json-theme-and-geometry-tokens.md) | JSON theme 與 geometry semantic token | Accepted |
| [KLP-0003](KLP-0003-note-semantics-owned-by-notist.md) | 筆記語意元件由 Notist 擁有 | Accepted |
| [KLP-0004](KLP-0004-presentation-decisions-owned-by-kallopis.md) | 產品提供語意，呈現決策由 Kallopis 擁有 | Accepted |

## 每份決策的必要內容

1. **決策與適用邊界**：說清楚這條規則管到哪裡，以及哪些情況不適用。
2. **推導依據**：為什麼是這個方案而不是別的。**寫下被否決的方案與否決理由**，
   否則下一個 session 會重新爭論同一件事。
3. **代價**：這個決策放棄了什麼。沒有代價的決策通常代表沒想清楚。
4. **閘門**：這份決策關閉哪一道原本開著的閘門，以及**由什麼機械判準執行**。
   只靠自律的規則不算閘門。
5. **已知欠債**：接受時仍然存在的問題，以及列管方式。

## 狀態詞彙

- `Proposed`：已寫下但尚未採用。
- `Accepted`：已採用且程式碼已符合。**程式碼還沒符合就不是 Accepted。**
- `Rejected`：曾提出並否決。**保留這類文件**——否決的理由與採納的理由一樣值錢。
- `Superseded by KLP-nnnn`：被後續決策取代。

Planist 的規格制度只能增加承諾、不能減少承諾，導致 71 份決策中 `Rejected` 為 0、
16 份標著未完成的 rollout gate。本 repo 從第一天避免這件事：**寫新決策前先問「哪道閘門
會關」**，答不出來就不要寫。

## 與 Krepis 的關係

Kallopis 與 Krepis 平行，互不依賴。但兩者共用兩條上位規則，衝突時以 Krepis 的為準：

- `FND-0001 §7`：庫名不使用 `-ist`，`-ist` 保留給產品。
- `FND-0001 §4` 的判準精神：**Notist 這種刻意平凡的筆記 app 需不需要？**
  Kallopis 的五條抽層規則是它的加嚴版本，不是取代。
