# Kallopis 0.8.0 圖示資產來源候選清單

本清單供 release reviewer 逐項補齊來源，不能當成授權核准。`SHA-256` 是目前入庫檔案的
內容指紋；只有官方頁下載內容與此指紋或 SVG path 完全相同，才能把該頁授權套用到該檔案。

## 稽核結果

- 圖示共 52 份。
- 1 份在檔案內明示 `Source: SVG Repo, Menu Hamburger, CC0`，但仍缺唯一的官方資產頁 URL。
- 2 份目前內容可回溯到本 repo 的內部製作：`grip-vertical` 在首次提交時即聲明為 Planist
  geometric icon；`maximize-02` 在 `14e5b1f` 被完整改寫成 repo 內製的圓角矩形。
- 25 份只有 SVG Repo Mixer 的平台標記，沒有官方資產頁 URL 或 license。
- 24 份只有檔名帶 `svgrepo-com`，SVG metadata 沒有來源或 license。
- 外部來源的 50 份都沒有可直接回溯的官方資產頁 URL；扣除本地 CC0 聲明後，49 份授權未查證。

官方搜尋曾找到同名候選頁，例如 `refresh-cw-01` 的
`https://www.svgrepo.com/svg/471819/refresh-cw-01` 與 `search-sm` 的
`https://www.svgrepo.com/svg/471864/search-sm`。官方下載端點受安全檢查阻擋，無法取得 SVG 與
本地 path fingerprint 比對，因此這些頁面目前不列為已匹配來源。同名或同 collection 不能替代逐檔比對。

SVG Repo 官方 licensing 頁指出網站有預設 SVG Repo License，但也明確保留「單一圖示頁另行標示」的
例外。因此，在不知道每個本地檔案對應哪個單一圖示頁時，不能只靠 collection 或平台標記套用預設授權：
`https://www.svgrepo.com/page/licensing`。

## 本機追查範圍

以 `rg` 唯讀搜尋 `C:\Projects` 下的 Markdown、JSON、YAML、CSV、log、HTML、其他文字紀錄與
Planist Git history，排除 `.git`、build、`.dart_tool`、`node_modules` 及二進位成品：

- 單頁 URL pattern：`svgrepo.com/svg/<id>/`、`download/<id>/`、`show/<id>/`。
- 來源／授權 pattern：`ui_oval`、`ui-oval-interface-icons`、`SVG Repo` 搭配 `CC0`／license／授權。
- Planist history：首次 baseline `076b097b`、桌面視覺 ADR `7ebf4363`、menu icon `f5cd8feb`。

結果只有本清單自行記錄的兩個網路搜尋候選 URL；Planist 與其他 `C:\Projects` 紀錄沒有保存任何
52 份資產的單頁 URL 或額外 license。Planist ADR 只保存 collection 選擇，不能完成逐檔匹配。

## 逐檔清單

| 資產（`assets/icons/ui_oval/`） | SHA-256 | 本地證據 | 官方頁匹配 |
| --- | --- | --- | --- |
| alert-square-svgrepo-com.svg | `b9aa98ec9e69b94c1ab338f55b8ccca94301fe33f9907b070a501f7fa2e35373` | 僅檔名 | 未解 |
| archive-svgrepo-com.svg | `f6ae8a90a7de5b71068a2a9c0cc945ec8c237a8d9952677fa056876b1d40dcc5` | SVG Repo 平台標記 | 未解 |
| arrows-collapse-svgrepo-com.svg | `9df696d27ec682e12647bb34b718831d7d644d7e88e079c2805a3cfe36e844fb` | SVG Repo 平台標記 | 未解 |
| bookmark-svgrepo-com.svg | `f50097fd9c4b553d45816a92c56740673a742bb420667da1f9c0ed6fc0207014` | SVG Repo 平台標記 | 未解 |
| box-svgrepo-com.svg | `94e4891443c8e17323488c04a38df7d911f920e4eb7dc161b00393e2daa24280` | SVG Repo 平台標記 | 未解 |
| calendar-svgrepo-com.svg | `7edb80bdc829a58b5c4c62df870f44b7f587a835353beed9c8b220f198a30c7f` | SVG Repo 平台標記 | 未解 |
| check-square-svgrepo-com.svg | `52efd5fa424c97dc6b85eb10cab3c2dd2ce9fe6f17cc96502a219707388189fe` | 僅檔名 | 未解 |
| check-svgrepo-com.svg | `d30500d0a2765e1e6db6f688369c186fea28f7d57d4bba83e3acd806263b1179` | 僅檔名 | 未解 |
| chevron-down-svgrepo-com.svg | `a059daf3600167822e699a076d5946199155bae1316c7cdda726fe99d8b03234` | 僅檔名 | 未解 |
| circle-svgrepo-com.svg | `8e9466dbb2dc3bd7ffa046b84c57a650cf3c454891acc185cf85c5f66a339def` | 僅檔名 | 未解 |
| clipboard-svgrepo-com.svg | `822906014076177958683a0bfdfdcc4a26db2bb79f6715e32d34227c2f0080dc` | SVG Repo 平台標記 | 未解 |
| clock-svgrepo-com.svg | `f312f970462aa1b8fb569d2707860cde115d57990c11c47bbe131117a2be0514` | 僅檔名 | 未解 |
| collapse-svgrepo-com.svg | `dbf66dab56f7f2095e96abe02484f99b9b9cfc1ac320f23b54b8af02b0dc219a` | SVG Repo 平台標記 | 未解 |
| container-svgrepo-com.svg | `4852ceaf43091b5678aa292ca47fbb881b5234c5182546b949c66011b9f88f6c` | SVG Repo 平台標記 | 未解 |
| cpu-chip-01-svgrepo-com.svg | `01e4bce1d5445e0ee21c60844bd398243b368b5e17bef3e704306a9ef61cf335` | SVG Repo 平台標記 | 未解 |
| distribute-spacing-vertical-svgrepo-com.svg | `969447bbc080a8610d3231296ee71d34c278ff86d40f2129790db64f74e22255` | SVG Repo 平台標記 | 未解 |
| edit-05-svgrepo-com.svg | `bb93bdd74cf7d327238a81701e2b0193d6730d5f6919b9ed0cc5b09571890ca4` | SVG Repo 平台標記 | 未解 |
| eye-svgrepo-com.svg | `4c2cf9227792708b7c0045f2f4e7410e2e209659340f15c8d385ce7012e7a721` | 僅檔名 | 未解 |
| folder-plus-svgrepo-com.svg | `623d3745f5e90258482f60d75bea487d4c71dd9b3ae3ec33350fb423cc88ce5e` | SVG Repo 平台標記 | 未解 |
| folder-svgrepo-com.svg | `64b4aa1b1d06519d7c869054c8becd86585b34e5412cf2f114a8ebe530d26a08` | SVG Repo 平台標記 | 未解 |
| grid-01-svgrepo-com.svg | `144cc716b8312efdb12b54ef949110505a7e60016434ca7e6db818f6ae1d8cf1` | 僅檔名 | 未解 |
| grip-vertical-svgrepo-com.svg | `125d5d3306bab295cc7ba934c14f3bc613ca9c6996207bb33bd2b95258fa4c6b` | Planist geometric icon；commit `a8cdf2c` | 內部來源 |
| hand-writing-svgrepo-com.svg | `f706af8cafd0256d2ab07f19755038bf179f6311fcbcd0dbc0c52550e414fbe2` | 僅檔名 | 未解 |
| inbox-01-svgrepo-com.svg | `1401b8bbb9892ec78aba769d3e1699ada6cddd0b361d21c2bcf58878b910a744` | SVG Repo 平台標記 | 未解 |
| info-square-svgrepo-com.svg | `78d14b71d144f68273786422b6fc7774e355e48094c92c911ae55fd0d48a2036` | 僅檔名 | 未解 |
| keyboard-svgrepo-com.svg | `10571e1ca33a4e8f52df2442f6b1fe1cbf1591e0c46912fab078e0651be626d7` | 僅檔名 | 未解 |
| loader-01-svgrepo-com.svg | `e691dbe12fbf27ffb5a03e8013868110eaae6391d1ee8b2867af3a5258c2e5a6` | 僅檔名 | 未解 |
| maximize-02-svgrepo-com.svg | `183419d36d1a5beaabe99a20d27d7fd0cf4aec5020e275559341779fbadb4dde` | commit `14e5b1f` 完整改寫 | 內部來源 |
| menu-hamburger-svgrepo-com.svg | `8fe42d38a0c39704f70b638816235c4e258ebf2769d659f4ecab981003761e25` | 本地註解聲明 SVG Repo／CC0 | 未解唯一官方頁 |
| minus-svgrepo-com.svg | `5a460c67e47c96d41e7b961bac46f85d176ba9ef2fb7dd49ebd3aba3a23ccd51` | 僅檔名 | 未解 |
| panel-bottom-svgrepo-com.svg | `0125796531d219a24f7d7ba79f9b09033a63e3fc0dbdb523ba871e1477de5c28` | 僅檔名 | 未解 |
| panel-left-svgrepo-com.svg | `62c309c3b6eaa22b92acc040b19022fb1101f6f15f09f53c28884edbefeb2daf` | 僅檔名 | 未解 |
| panel-right-svgrepo-com.svg | `5af097393a3edc157db442bee4a3e181620e4ffe9ccb8e06fc378105f5cca858` | 僅檔名 | 未解 |
| panel-split-svgrepo-com.svg | `ae5ef5cd7de986d666c7fa21fbbb91e397123216e99206bac9afc9426500157f` | 僅檔名 | 未解 |
| pencil-02-svgrepo-com.svg | `86ddf4b5865d3c6c0f61978a7c5c3ddbddc0f3849d8d94ff129372a1d49eb335` | SVG Repo 平台標記 | 未解 |
| refresh-cw-01-svgrepo-com.svg | `a1fe21f8806ce686023e7840f8d972750c264426a0ebeb93046acdfe7b1806c5` | 僅檔名 | 同名官方候選未能比對 |
| restore-svgrepo-com.svg | `e6002bf444e223d3d73b973241d6e337c4c80ec40dc722a379e673b9a7f11c26` | 僅檔名 | 未解 |
| search-sm-svgrepo-com.svg | `8070c0d358947b59d2673ba572d773eaa8b704a84c5f7474ca2e132ae10a9ec8` | SVG Repo 平台標記 | 同名官方候選未能比對 |
| settings-02-svgrepo-com.svg | `19a490284881d49de759d6b30152fb3cb7a0d4574b70404ba381379e7a84ecf7` | SVG Repo 平台標記 | 未解 |
| slash-octagon-svgrepo-com.svg | `f1eb7e134c1eceda1b1742135c465910eae89c25d1f5d5eb141df91b3c9fa92b` | SVG Repo 平台標記 | 未解 |
| split-circle-svgrepo-com.svg | `c24ab1dab765f51425712d3e26eded854cf5c0e132f3d8cdbab41b05726c7715` | 僅檔名 | 未解 |
| stars-01-svgrepo-com.svg | `aa79ab8d501fef7d20866bc75d8a2985e5cb2499daa68e45bcc475d186e9661e` | SVG Repo 平台標記 | 未解 |
| stars-02-svgrepo-com.svg | `6034ff35b8e21b194f89defd60670348916b990cda89b02ba80468febe18cb30` | SVG Repo 平台標記 | 未解 |
| switch-vertical-01-svgrepo-com.svg | `8bd068be5aedb335fb6bff105efc62fe1b8ec239ff1c6ef55808bfb14a974576` | SVG Repo 平台標記 | 未解 |
| telescope-svgrepo-com.svg | `30bffeb407b33244d0f6f178ea0bdc847d9561d8e23434ca4c846ec9d1a071fc` | SVG Repo 平台標記 | 未解 |
| timer-svgrepo-com.svg | `027094a6d5f5f87a4f7a0c78a3cdedbaef1e014e2b2a8df480a112fe6ee0de2f` | 僅檔名 | 未解 |
| trash-01-svgrepo-com.svg | `ca6e604c4745de049805cf7a7e800fb4e91120c962f70f7e63e5d7ba572a0fb9` | SVG Repo 平台標記 | 未解 |
| trash-03-svgrepo-com.svg | `178db70d144037c760b30c918c728939aed891d71d487fba346cfc7c89180ccb` | SVG Repo 平台標記 | 未解 |
| triangle-down-svgrepo-com.svg | `235f90f5e0dfe7e4d3d042231f8b60db466f660b4480fe6882ad7d2b8288b68a` | 僅檔名 | 未解 |
| users-01-svgrepo-com.svg | `2b57f32912728f3345e0094f0cd635b0c6206413c77af485d4953477c94a4cad` | SVG Repo 平台標記 | 未解 |
| x-square-svgrepo-com.svg | `6c4bff7ac16e3e021af149014fcbc387afaad5ff078d36aec1e8aa0389b8e00e` | 僅檔名 | 未解 |
| x-svgrepo-com.svg | `982b33b31ac6dba497a68f1b205c1f24bc823d6b7b8b38014fbb4744d2ec9f64` | 僅檔名 | 未解 |

## 發布閘門

在 49 份未查證圖示逐一取得唯一官方頁及 license，或由授權可證且視覺變更經核准的資產取代前，
`LICENSE／資產完整` 維持 **Required／未通過**。本清單不授權建立 tag 或 GitHub Release。
