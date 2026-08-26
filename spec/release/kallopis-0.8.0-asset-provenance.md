# Kallopis 0.8.0 圖示資產來源

這份清單供 release reviewer 與後續維護者重現 `assets/icons/ui_oval/` 的圖示來源。
舊檔名為維持既有 asset-path ABI 而保留；檔案內容已按下表以官方上游檔案逐位元取代，
不能再從檔名中的 `svgrepo-com` 推斷來源。

## 上游版本與授權

- 官方倉庫：<https://github.com/lucide-icons/lucide>
- 固定 tag：`1.27.0`
- 固定 commit：`4aec3f892fd6c23063bc2fead83c899b5d412b1c`
- 授權：Lucide 使用 ISC；由 Feather 衍生的圖示另依同一官方 `LICENSE` 內的 MIT 條款。
- 隨附原文：`assets/icons/ui_oval/LUCIDE_LICENSE.txt`
- 官方固定版本授權頁：
  <https://github.com/lucide-icons/lucide/blob/4aec3f892fd6c23063bc2fead83c899b5d412b1c/LICENSE>

下表的 SHA-256 是 Kallopis 內檔案指紋。這 49 份 SVG 未經改寫，與固定 commit 的
`icons/<name>.svg` 內容相同；換行與 metadata 都必須保留，否則指紋會不同。

## Lucide 逐檔對照

| Kallopis 資產 | 上游路徑 | SHA-256 |
| --- | --- | --- |
| alert-square-svgrepo-com.svg | `icons/octagon-alert.svg` | `86d28171a1d6ee0e65ebd44c9e683dce5803a85a1d3980fcc60bd46465f8c6b2` |
| archive-svgrepo-com.svg | `icons/archive.svg` | `78c732e34e232db63af06a2330b4448045cfdf49b48b59f2d31922df54c7bb17` |
| arrows-collapse-svgrepo-com.svg | `icons/minimize-2.svg` | `1150437d5a870321c59b7ebca2e1bc3f6227f0fa03dd10484ab384dfe5110739` |
| bookmark-svgrepo-com.svg | `icons/bookmark.svg` | `1d5023760db81f21c3b5a63f012ef540acc01932731c733e4645012a876d39f4` |
| box-svgrepo-com.svg | `icons/box.svg` | `511862693d914d2bf1947c9ccc513595f2a256541f5dd4f6f9ac8383cd41ac4f` |
| calendar-svgrepo-com.svg | `icons/calendar.svg` | `c5c59382ebf9c3c2ce6426bd9f36fdda7ef8f0a96bffb8d8316ab38dc4dcc982` |
| check-square-svgrepo-com.svg | `icons/square-check.svg` | `929cdff3bf27aeaff13260d4acf9d1afe62997e0ca88222032fb568dfc93005c` |
| check-svgrepo-com.svg | `icons/check.svg` | `7f33acc9a77a61659531044525fc008edebe215bf4dcf1c789c8674ad3277db0` |
| chevron-down-svgrepo-com.svg | `icons/chevron-down.svg` | `66ea878e72ed3488bb3b464c39dfdccee8d1f78e560dccea40e5e12da0e87e87` |
| circle-svgrepo-com.svg | `icons/circle.svg` | `3a991bd47beaf9874fba6fdf87bbba442970a89b5e6aa391558bc8b0a00a0513` |
| clipboard-svgrepo-com.svg | `icons/clipboard.svg` | `d9b433e6a571d96a035ddb83d2ff52c4f85925ffcba9e584cf371d0dfa90875d` |
| clock-svgrepo-com.svg | `icons/clock.svg` | `e9d3e3acf4d1c280fcf8092293439dc0a4756a908ceb859de144b12451cd1cb9` |
| collapse-svgrepo-com.svg | `icons/minimize-2.svg` | `1150437d5a870321c59b7ebca2e1bc3f6227f0fa03dd10484ab384dfe5110739` |
| container-svgrepo-com.svg | `icons/container.svg` | `8a41c445ba181b69b4ccf652f46fec5df0f410d64fff5e2cc202600b4862c633` |
| cpu-chip-01-svgrepo-com.svg | `icons/cpu.svg` | `ec83bb69ec029d367d749afc445b39c8e95891ebf99b0400652677c2b149b99c` |
| distribute-spacing-vertical-svgrepo-com.svg | `icons/align-vertical-space-around.svg` | `8b0b4f125fe32197c89e316850482ffd04d293e3e77a927f12a88d09b970ecfe` |
| edit-05-svgrepo-com.svg | `icons/square-pen.svg` | `09bdac7fdb94058246a5d3132eea0976e690d01694179ab6f474faa2c21de59a` |
| eye-svgrepo-com.svg | `icons/eye.svg` | `5bf90197dd7629cad64a2e48d1186a71559deb6121207d10e3dc5b19ebaffdcf` |
| folder-plus-svgrepo-com.svg | `icons/folder-plus.svg` | `76d62eb7796ce6c7e303c437464923de2d1ae19a5c8d010f8b36dfc1d6180890` |
| folder-svgrepo-com.svg | `icons/folder.svg` | `f0d92b94b797a8ab7d4c4ae33c3236c47f64068351b4e14bdb5014ee42898a39` |
| grid-01-svgrepo-com.svg | `icons/grid-2x2.svg` | `dc1896d3b22e88e0ba45a77bc8e947b7a01d0c9fb5ff77d07d24a5589816bb84` |
| hand-writing-svgrepo-com.svg | `icons/pencil-line.svg` | `cd0814e0744b4a81f9ccb1d4db9ee34de0e11f2cf82fa1522a86a8056e065e00` |
| inbox-01-svgrepo-com.svg | `icons/inbox.svg` | `1838482c53d0846badef9be96fdcf7a167064241bd4891efa995c77ebec5f187` |
| info-square-svgrepo-com.svg | `icons/badge-info.svg` | `42d969da31742cb7ad6c10aaa30100b8b19bd014545c9fd661271f2cf9aa3bce` |
| keyboard-svgrepo-com.svg | `icons/keyboard.svg` | `f509925ca81964ed06251ad4702e989bb81a566ffc74d15c2226b4f07ded67be` |
| loader-01-svgrepo-com.svg | `icons/loader-circle.svg` | `043021bb903919668804bdb6fee0342072e4ffea5f03fbd857774c440179ad3b` |
| minus-svgrepo-com.svg | `icons/minus.svg` | `a0c743ab6dbf545d8a6e19ef3874f48ede686ce68d25e231bd81f540d97b1f19` |
| panel-bottom-svgrepo-com.svg | `icons/panel-bottom.svg` | `7792f8b39919a347ba7be86fda059c41a46e38dbe23758f7be6aa4514579703e` |
| panel-left-svgrepo-com.svg | `icons/panel-left.svg` | `029f67b9e3eeb7ddf7c7c499b174c50388725e8ea50d4ea59ed7dbaf8d61cb82` |
| panel-right-svgrepo-com.svg | `icons/panel-right.svg` | `327d197328f9feb1f88c36c9db04e9b00fe717d877459f92fcd892f5e4c349fa` |
| panel-split-svgrepo-com.svg | `icons/panels-top-left.svg` | `321a2a5500f2b814a2e62eb73c4b01dc65c7334fe2e6f7d77517239383e26bb1` |
| pencil-02-svgrepo-com.svg | `icons/pencil.svg` | `7e1ca7a6f5c1eb949671df762f2baadd32f5bd841d43153c3a15279af7d78d0c` |
| refresh-cw-01-svgrepo-com.svg | `icons/refresh-cw.svg` | `2e10dd403c85a24f163d59fc6151aa21147fe9402e1305dfc8979208caee8944` |
| restore-svgrepo-com.svg | `icons/copy.svg` | `ea80e566c7a12628a447cb53179b19aea4f60b9143e2becd0d0f20bf260e5718` |
| search-sm-svgrepo-com.svg | `icons/search.svg` | `283d371c2e433817bb9c0c8310caa6c77fa4177c0f4f1168d9c83b97af7389dc` |
| settings-02-svgrepo-com.svg | `icons/settings-2.svg` | `06d06c191bd7eb28afaf9d40acb5c49ef69448fdeda91801d9823d7c440a4e10` |
| slash-octagon-svgrepo-com.svg | `icons/circle-slash-2.svg` | `ae6f82929f4e0cf293f816342ce30da9c4ec02f1a2949850ff2a02674779067a` |
| split-circle-svgrepo-com.svg | `icons/columns-2.svg` | `bddf3348a9c82d111a060d118299c90755b1ae8411bd16ea1d5ddb83c5f98a27` |
| stars-01-svgrepo-com.svg | `icons/sparkles.svg` | `f5499f33f09d7158151e9bd2ec0faf79ff8fb57292f84fdd7286d96d0f0424d8` |
| stars-02-svgrepo-com.svg | `icons/sparkles.svg` | `f5499f33f09d7158151e9bd2ec0faf79ff8fb57292f84fdd7286d96d0f0424d8` |
| switch-vertical-01-svgrepo-com.svg | `icons/arrow-up-down.svg` | `d15411438095bac7cab0cf91f18cadfbde2ca752284c06b4b3642c4695b1774e` |
| telescope-svgrepo-com.svg | `icons/telescope.svg` | `ef9c953964649dd84764478de5396aaab3c924927e522a74f4ccfdeef381b023` |
| timer-svgrepo-com.svg | `icons/timer.svg` | `6771297be65225d462c930865b6f9ee1617aa453885be4c8116a7512a77ac2b6` |
| trash-01-svgrepo-com.svg | `icons/trash-2.svg` | `27299f69ad7c6272be64b1b8e2d48cbd6dcf0ef0d4f92827a1affa945c91700e` |
| trash-03-svgrepo-com.svg | `icons/trash.svg` | `a38b5b9f55c5258ed1096b9d6bab414cce64a72a1213bf9f9b515e7b583ae3fc` |
| triangle-down-svgrepo-com.svg | `icons/chevron-down.svg` | `66ea878e72ed3488bb3b464c39dfdccee8d1f78e560dccea40e5e12da0e87e87` |
| users-01-svgrepo-com.svg | `icons/users.svg` | `eeed488a1ec95ba730dd69996536fb65061d6ea273afb2429ae47e65eebf401c` |
| x-square-svgrepo-com.svg | `icons/square-x.svg` | `fbc62d7310eb57f6a3233d65a4d12a895e9a014cf56f0b62349855f523498cb9` |
| x-svgrepo-com.svg | `icons/x.svg` | `4a9cdab38fbb96162e7dace28e33f4ca0e49d8963a6162abc3d4691b7d675117` |

## 非 Lucide 資產

| 資產 | SHA-256 | 來源與授權狀態 |
| --- | --- | --- |
| grip-vertical-svgrepo-com.svg | `125d5d3306bab295cc7ba934c14f3bc613ca9c6996207bb33bd2b95258fa4c6b` | Kallopis／Planist 內部製作；首次以 geometric icon 入庫。 |
| maximize-02-svgrepo-com.svg | `183419d36d1a5beaabe99a20d27d7fd0cf4aec5020e275559341779fbadb4dde` | Kallopis 內部完整改寫的圓角矩形圖示。 |
| menu-hamburger-svgrepo-com.svg | `8fe42d38a0c39704f70b638816235c4e258ebf2769d659f4ecab981003761e25` | 檔內明示 SVG Repo／CC0；保留原始聲明。 |

## 發布閘門

- `KlpIcons` 的公開欄位名稱與既有 asset path 不變。
- 49 份原先未查證資產已不再存在於 release candidate 的內容中。
- Lucide 的完整 ISC／MIT 原文必須隨 package 散佈；刪除
  `LUCIDE_LICENSE.txt` 即視為 release gate 失敗。
- 更新固定 tag 或任何 SVG 時，必須同步更新上游路徑、commit 與 SHA-256，並重新檢視 golden。
