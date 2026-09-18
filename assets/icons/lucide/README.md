# Lucide 工作區圖示

來源：https://github.com/lucide-icons/lucide/tree/a79b2d131dab2bf20cb224bd0937b439a9c4fa99/icons

固定 revision：`a79b2d131dab2bf20cb224bd0937b439a9c4fa99`。本目錄只散佈工作區使用的 24 個 SVG，保留上游 `LICENSE`（ISC 與其列出的 Feather 衍生圖示 MIT 聲明）。

唯一圖形調整：根 SVG 的 stroke-width 由 2 改為 1.5，以對齊已確認 HTML 的線條比例；viewBox、路徑、圓端與轉角保持上游內容。此值定義圖示資產的筆畫，不在 renderer 另設預設風格。

Flutter 透過 `KlpFlutterLucideIcon` 使用 package-owned asset，顏色與顯示尺寸來自呼叫端已解析的語意。圖示不在執行時連網。旧 UIcons 字型仍供未遷移的相容元件使用。
