# Kallopis Catalog — 元件型錄與編譯執行指南

本目錄為 **Kallopis 元件型錄應用程式（`kallopis_catalog`）**，提供 Design Tokens、主題切換（淺色／深色／超深色／透明）、排版、以及所有共用元件的即時互動展示與規格 Specimen。

---

## 🛠️ 環境前置要求

- **Flutter SDK**：`3.44.4`（Dart `3.12.2`），安裝路徑位於 `C:\development\flutter\bin`。
- **Windows 建置工具**：Visual Studio 2022（需安裝「使用 C++ 的桌面開發」工作負載）。
- **PowerShell 環境變數**：若 Flutter 尚未加入系統全域 PATH，執行任何指令前請先執行：
  ```powershell
  $env:Path = "C:\development\flutter\bin;" + $env:Path
  ```

---

## 🚀 完整編譯與執行 SOP

### 1. 本地開發除錯（Debug 模式）

在開發時直接啟動並支援 Hot Reload：

```powershell
# 進入 example 目錄
cd C:\Projects\Kallopis\example

# 載入 Flutter 環境並啟動 Windows 桌面版
$env:Path = "C:\development\flutter\bin;" + $env:Path
flutter run -d windows
```

---

### 2. 編譯正式發布版（Release `.exe` 產出）

編譯獨立的 Windows 64 位元 Release 執行檔完整流程：

```powershell
# 步驟 1：強制關閉可能正在背景執行的舊版 catalog，避免 Visual Studio Linker 出現 LNK1104 檔案鎖定錯誤
Get-Process -Name "kallopis_catalog" -ErrorAction SilentlyContinue | Stop-Process -Force

# 步驟 2：切換至 example 目錄
cd C:\Projects\Kallopis\example

# 步驟 3：載入 Flutter PATH 並執行 release 編譯
$env:Path = "C:\development\flutter\bin;" + $env:Path
flutter build windows --release
```

#### 📦 Release 產出位置
編譯完成後，執行檔與相關相依 dll 將輸出於：
```
C:\Projects\Kallopis\example\build\windows\x64\runner\Release\kallopis_catalog.exe
```

可以直接透過 PowerShell 啟動測試：
```powershell
.\build\windows\x64\runner\Release\kallopis_catalog.exe
```

---

### 3. 一鍵編譯 PowerShell 整合指令（推薦）

若要從專案根目錄一鍵完成「關閉舊 Process ➔ 測試驗證 ➔ 重新編譯 Release」：

```powershell
Get-Process -Name "kallopis_catalog" -ErrorAction SilentlyContinue | Stop-Process -Force; $env:Path = "C:\development\flutter\bin;" + $env:Path; cd example; flutter build windows --release
```

---

## 🧪 測試與視覺 Golden 快照

### 執行型錄自動化測試
```powershell
cd C:\Projects\Kallopis\example
$env:Path = "C:\development\flutter\bin;" + $env:Path
flutter test
```

### 更新視覺 Golden 快照（視覺樣式有預期更動時）
```powershell
cd C:\Projects\Kallopis\example
$env:Path = "C:\development\flutter\bin;" + $env:Path
flutter test --update-goldens
```

---

## ⚠️ 常見問題排查（Troubleshooting）

| 問題現象 | 原因 | 排除 SOP |
|---|---|---|
| `fatal error LNK1104: 無法開啟檔案 '...kallopis_catalog.exe'` | 前一次開啟的 `kallopis_catalog.exe` 尚未關閉，造成檔案被鎖定。 | 執行 `Get-Process -Name "kallopis_catalog" -ErrorAction SilentlyContinue \| Stop-Process -Force`。 |
| `flutter: command not found` | Flutter SDK 未在當前 PowerShell Session 的 PATH 中。 | 執行 `$env:Path = "C:\development\flutter\bin;" + $env:Path`。 |
| `Golden "goldens/...": Pixel test failed` | 元件視覺調整（如字體、Padding、圓角改變）導致與舊快照不符。 | 執行 `flutter test --update-goldens` 更新基準圖，並在 commit 說明變更原因。 |
