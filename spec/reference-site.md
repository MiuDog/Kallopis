# Reference Site 契約

## Outcome

Kallopis repository 提供可由 GitHub Pages 發布的靜態 reference site，讓 consumer 可從首頁與 Get Started 導覽至每個公開元件及 API 頁。

## In scope

- 以 `docs/ai/`、`docs/architecture/`、`docs/architecture/src/` 與 `spec/component-inventory.md` 產生網站。
- 所有 component inventory 的 public `Klp*` 型別建立獨立 component page。
- 所有 architecture-atlas source Markdown 建立獨立 API page。
- 非葉組合型別和宣告式容器型別顯示 Dart 組裝範例。
- GitHub Pages workflow 只由 `main` 或手動 dispatch 部署。

## Out of scope

- 修改 Kallopis runtime、public API 或既有 atlas generator。
- 自動開啟 GitHub repository 的 Pages 設定或發佈到外部服務。

## Data contract

- `tool/reference_site/assembly_examples.json` 是容器範例的唯一來源；key 是型別名稱，value 包含 public import 與 Dart code。
- 產生器輸出 `site-manifest.json`，列出 component、API 與 guide 頁路徑。
- `build/reference-site/` 是可拋棄的產物，不提交版本控制。

## Acceptance criteria

1. `node tool/reference_site/generate.mjs` 產生首頁、Get Started、component、API、guide 與搜尋索引。
2. `node tool/reference_site/verify.mjs` 在每個 inventory component 有獨立頁、每個 atlas source document 有 API 頁、每個必要容器有例子時退出碼為 0。
3. component、API 與 guide 頁都有左側分類 navigator 與可使用的 API 清單入口。
4. GitHub Pages workflow 的 deploy job 不在 pull request 事件執行。
