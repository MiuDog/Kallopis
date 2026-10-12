# Kallopis 設計語意對照表（供其他專案與AI使用）

來源擷取日期：2026-10-05；來源：Kallopis 0.8.0 工作樹／預設風格 1.0.0。2026-10-11 使用者指定採用此內容為通用視覺規範。本章定義表格記號與解析基準；其他章節見 [規範索引](KALLOPIS-DESIGN-MAP.md)。本規範不建立產品功能模板。

## 表格記號

| 記號 | 意義 |
|---|---|
| `p(名稱)` | 第一部分primitive名稱→實際值map。 |
| `s(ID)` | 第二部分semantic用途或完整配方。 |
| 繼承配方 | 先複製「繼承」欄指定配方，再覆寫本列參數；未列參數保留。 |
| 繼承父層 | 使用父容器／文字環境的值；不是全域預設。 |
| 繼承目前元件 | 保留目前variant和size，僅套用本列狀態。 |
| none | 明確不畫／不套用，不能改成繼承。 |
| 不適用 | 此用途不需要該參數。 |
| 產品決定／內容決定／父布局分配 | 未規定固定值，使用目標產品或布局，不由AI猜成公共token。 |
| alpha(color,opacity) | 保留RGB，替換alpha；不是乘上原本alpha。 |
| opaque(color) | 保留RGB，alpha設為1。 |
| over(front,back) | 使用alpha compositing疊色，對應Color.alphaBlend。 |
| add/sub/mul/div/max | 數值運算，保留長度與倍率的單位。 |
| byBrightness(light,dark) | surface相對亮度<0.5時取dark，否則light。 |
| primaryForeground(background) | 8-bit sRGB luma=0.299R+0.587G+0.114B；<160取theme.colors.onDarkBackground，否則onLightBackground。 |
| backgroundForeground(background) | 透明時繼承父層；非透明背景相對亮度<0.15取onDarkBackground／mutedOnDarkBackground，否則onLightBackground／mutedOnLightBackground；faint取faintOnBackground。 |

預設light/rest；button未指定size時為sm，compact=true時為xs；field預設md。button-base以md列出共用可覆寫值，解析元件時必須再套用正確size。色碼統一**#AARRGGBB**（alpha在前）；CSS需轉為#RRGGBBAA。不透明色可使用#RRGGBB。length為logical px／CSS px，duration為ms，ratio/opacity無單位，weight為字重整數，curve為cubic-bezier四點。父容器若有backgroundForeground覆寫，子樹的theme.colors.text/textMuted需使用覆寫後的值；不得一律從根主題拿文字色。

