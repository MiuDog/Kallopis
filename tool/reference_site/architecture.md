# Reference Site Adapter 架構

Status: PLAN COMPLETE — `PE-B3B` assembly example 收斂與 `PE-B4` 網站確定性驗證已完成；人類可理解性接受仍待執行。

## Purpose and non-goals

本 module 將 repository Markdown、元件 inventory 與少量已證明的 consumer assembly example 轉成 GitHub Pages reference site。它不定義 Dart API、能力成熟度、產品模板或新的元件契約；能力狀態只讀取 `docs/ai` 與公開宣告證據。

目前目標是移除網站元件頁仍展示的舊 consumer 寫法。此 slice 不修改 generator、layout、CSS、網站路由、Flutter 實作或可再生 `build/reference-site/**`。

## Owned paths and interfaces

| 路徑 | 責任 | PE-B3B 處置 |
| --- | --- | --- |
| `tool/reference_site/assembly_examples.json` | 元件頁額外顯示的 consumer 組裝片段。 | 唯一可寫來源 |
| `tool/reference_site/generate.mjs` | 讀取 Markdown、inventory 與 examples，產生靜態網站。 | 唯讀 |
| `tool/reference_site/verify.mjs` | 驗證來源覆蓋、輸出連結、錨點與 example target。 | 唯讀 |
| `tool/reference_site/package.json`、`package-lock.json` | 固定 reference-site 執行環境。 | 唯讀 |
| `build/reference-site/**` | 可再生輸出，不是手寫權威。 | PE-B4 才產生與檢查 |

`assembly_examples.json` 的公共資料形狀保持 `{ componentName: { import, code } }`。key 必須存在於網站 inventory；`import` 必須是 `package:kallopis/kallopis_declarative.dart`；`code` 必須真的組裝該 key 所指元件。

## Dependency direction and invariants

```text
KLP-0021＋docs/ai 能力狀態＋公開 declarative API＋component inventory
	→ assembly example 判讀
	→ reference-site generator
	→ build/reference-site
```

- example 只能使用目前公開 declarative 入口，不得 import `lib/src` 或 `kallopis_foundation.dart`。
- example 不得包含 internal `KlpRail`、Flutter Widget／`BuildContext`、renderer、painter、style authoring 或局部視覺值。
- 沒有可證明的新版組裝時，刪除 example，讓網站顯示「尚未收錄」；不得以舊 class 填滿元件頁。
- JSON 不是能力清冊或執行 registry；移除片段不改變固定 254 項 migration coverage。
- generator 與 verifier 的故障屬另一個 debugging slice，不在 PE-B3B 順手修改。

## Current slice `PE-B3B`

產出：將 `assembly_examples.json` 收斂到能由現行公開契約及型別分析證明的 application、screen、adaptive 與 app layout 範例。

允許寫入：`tool/reference_site/assembly_examples.json`。

確定性驗收：

1. JSON 可解析，key 只包含 inventory 已知 component，且 code 含目標 component 名稱。
2. 所有 import 只有 `package:kallopis/kallopis_declarative.dart`。
3. 不含 `KlpRail`、`kallopis_foundation.dart`、Widget、`BuildContext`、private `src`、style 或 painter authoring。
4. 使用到的公開型別能以目前 package configuration 通過 Dart analyzer。
5. Task Packet scope gate 只看見 `assembly_examples.json`。

Cold-start estimate：4k–8k tokens／20–40 分鐘。假設沿用目前模型、本機 Node／Dart 與不變的 generator；超過 12k tokens 或 60 分鐘時停止並回報公開 API 或 generator 契約衝突。

## Protected paths and test state

本 slice 對 `architecture.md`、`generate.mjs`、`verify.mjs`、package files、`docs/**`、`spec/**`、`lib/**`、`test/**`、`example/**` 與 `build/**` 唯讀。

`PE-B3B` 已確認 JSON shape、4 個 inventory target、唯一 declarative import、禁用內容 0 命中、公開型別 analyzer 與 module scope gate。`PE-B4` 已通過 Markdown tests 5／5、網站 generate 與 verify：產生 4060 個 HTML 頁並檢查來源覆蓋、表格、內部連結與錨點；本輪四個新增 reference 頁各為 0 個來源問題。桌面／窄寬人類接受仍為 human-pending。
