# 視覺元件統一維護與 Catalog 驗收

狀態：Accepted，配合 KLP-0022 唯一 Flutter 架構。

## 責任

- Kallopis 統一維護公開共用元件的內部視覺、互動、鍵盤、無障礙與平台適應。
- 產品直接以 Flutter 組合畫面，擁有產品專用 Widget、布局、功能順序、資料與事件協調。
- 產品專用 Widget 使用 `context.klp` semantic token，不複製 Kallopis 公開元件的內部樣式。
- 只有已證明跨產品重用的能力，才提升為 Kallopis 公開元件。

## 不變條件

- icon、按鈕列、Explorer、Frame 等已接受外觀不回退。
- hover 與 selected 使用相同顏色是刻意設計；hover 不改變產品選取資料。
- Kallopis 不新增 Planist 專用模板、業務功能順序或商業流程。
- Consumer 不引用 `lib/src`，不建立第二份 theme，不重建 declarative、renderer 或 compatibility 路徑。
- Krepis／provider 保有正文、selection、undo 與 persistence 權威。

## Catalog 驗收

Catalog 使用真實公開 Flutter 元件，展示其正常、hover、focus、pressed、selected、disabled、長文字、空資料與窄空間等適用狀態。程式檢查只判斷確定性的結構、幾何與事件證據；視覺品質、互動手感與易用性由人類接受。

候選外觀必須標示用途與差異，接受後才可成為正式預設。Catalog 是元件展示與人工接受面，不是 runtime、能力 registry 或固定遷移清冊。
