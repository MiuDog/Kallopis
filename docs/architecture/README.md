# Kallopis 架構分析入口

從 [lib/src 圖集總索引](src/README.md) 開始，先選目錄，再進入檔案／元件細節與原始碼證據。
圖集涵蓋巢狀與 internal 目錄；它記錄目前程式結構，不取代設計契約或使用者核准的規格。

## 閱讀路徑

1. **找責任邊界**：各主要目錄的「分析入口」說明核心符號及應從哪個檔案開始。
2. **看依賴**：目錄與檔案頁的 Mermaid 圖分辨 import、export、part 與類別關係。
3. **查細節**：宣告與成員表列出 public／private、型別、建構子、欄位與方法，連回原始碼行號。
4. **驗證推論**：import 不代表執行順序；事件、資料權責與狀態轉移仍需閱讀對應程式與測試。

## 常用起點

| 分析問題 | 圖集入口 |
|---|---|
| App 啟動與主題注入 | [app](src/app/README.md) |
| Primitive、semantic 與預設風格 | [tokens](src/tokens/README.md)、[theme](src/theme/README.md)、[styles](src/styles/README.md) |
| 按鈕與內部風格表 | [controls](src/controls/README.md)、[controls/internal](src/controls/internal/README.md) |
| 表單與相容匯出 | [form](src/form/README.md) |
| 導覽、側欄與工作台 | [navigation](src/navigation/README.md)、[shell](src/shell/README.md)、[ist](src/ist/README.md) |
| 表面、背景 recipe 與 painter | [surface](src/surface/README.md) |
| 全部目錄與元件 | [完整索引](src/README.md) |

## 保持圖與程式一致

圖集由 [架構圖集生成器](../../tool/architecture_atlas/README.md) 產生。
原始碼改動後，先執行 freshness 檢查；有差異時重新生成並核對人工摘要。
請修改生成器或 `tool/architecture_atlas/briefs/`，不要直接修改自動產生的頁面。

```powershell
python tool/architecture_atlas/generate.py --dart D:/flutter/bin/dart.bat --check
```

在 VS Code 開啟 Markdown 後使用 `Markdown: Open Preview to the Side`。
Mermaid 需要編輯器的預覽支援；本次全量語法與渲染結果另見 [圖集驗證紀錄](atlas-validation.md)。

## 其他架構資料

- [Token 與元件風格解析](token-style-resolution.md)：本次按鈕風格抽離的具體責任。
- [既有元件文件目錄](components)：補充既有元件的組合說明，引用前仍應核對來源。
- [設計知識與契約](../../.agents/skills/kallopis-design-contract/references/design-knowledge/README.md)：設計權威與定型狀態。
