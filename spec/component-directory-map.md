# Kallopis 元件目錄分層

## 規則

- 同一功能元件與其 immutable 資料模型放在同一專用子目錄。
- 不同功能不得共用「看似通用」的根層實作檔；跨功能只透過 public barrel 或明確基礎層引用。
- `internal/` 只放該子目錄的實作細節，不放可被消費端直接使用的資料模型。
- 根層檔案只保留聚合 barrel；若檔案包含兩個以上不共用資料模型的 public widget，必須拆檔。

## 已完成

| 領域 | 子目錄 |
|---|---|
| Navigation | `breadcrumb/`、`controls/`、`explorer/`、`navigator/`、`preview_tree/`、`rail/`、`sidebar/`、`tabs/` |
| Data | `accordion/`、`advanced/`、`agenda/`、`avatar/`、`badge/`、`card/`、`code/`、`date_grid/`、`key_value/`、`list_tile/`、`message_thread/`、`preview_card/`、`progress/`、`sort_control/`、`stepper/`、`timeline/` |
| Editor | `action_bars/`、`artifact_workspace/`、`canvas_workspace/`、`command_menu/`、`entity_picker/`、`message_composer/`、`page_chrome/` |
| Shell | `composition/`、`docking/`、`panel/`、`sidebar/`、`stage/`、`status/`、`theme/`、`window/` |
| Controls | `button/`、`color/`、`input/`、`selection/`、`toggle/` |
| Feedback | `view_states/`、`workflow/` |
| Surface | `page_background/` |
| Components | `lib/src/foundation/surface/legacy_components/` 根層只放無產品語意、由基礎原語組成的通用元件 |

## 有意保留的複合視圖檔

- `data/advanced/klp_advanced_data.dart`：DataTable、Tree、JsonTree、FilePreview，
  共用 advanced data 視覺基礎，模型已移至 `models/`。
- `data/code/klp_code_viewer.dart`：CodeViewer、DiffViewer、Terminal，
  共用 code rendering 基礎，模型已移至 `models/`。

這兩個檔案的 public 元件屬同一資料呈現家族，保留在專用子目錄內；若未來任一視圖
需要獨立生命週期或模型，應再從該子目錄拆出，而不得回到領域根層。
