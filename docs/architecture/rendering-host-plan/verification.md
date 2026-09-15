# REND-HOST-V1-r1 驗證

REND-V1-05 complete。R1 文字輸入及 R2 WebView 生命週期兩部分皆已整合，不以局部里程碑取代整片驗收。

- Features 持有純 Dart failure，application 從唯一 viewport 安裝 sink，原 error/stack 及 origin/phase 進入既有 recovery；六個公開 library 完整內容保持。
- 文字 source swap／dispose 共用捕捉身分且冪等的 detach，中斷失敗仍釋放 local input/binding，不取得 borrowed provider 權威。中斷擁有者回報一次，觀察者保留失敗而不重報；批次 typed error 有轉送，普通拒絕保持普通結果。
- 繪圖幾何回呼先確認存活再查渲染物件；批次收尾不以同 session 的舊快取投影覆寫較新回覆。新發布投影仍執行原嚴格驗證，沒有吞掉真正的版本倒退錯誤。
- BlockNote/Canva 按 controller identity 保留或換 State，attachment 固定借用身分。只有成功 bind 的 attachment 能 unbind；舊晚到清理不解除新 sender。多次 load-stop 去重，Canva 不新增自動重試；BlockNote upstream open 成功即固定，不因後續 flush/onOpened 失敗重播初始正文，且維持 editor/save sender。
- 環境建立晚到、建立／釋放失敗、JS receive／callback／page error 各經原操作出口回報一次；保留原 plugin error 物件與可取得的原 stack。Console 僅為診斷。

## 執行證據

- R1-integrated-fixed.log：46 pass。
- R2-integrated-frozen.log：38 pass。
- regression.log：61 pass。
- architecture.log：178 pass。
- 各單模組 Task Packet 與後續同範圍修正的實際 scope gate 全部 PASS。產品靜態分析無問題；atlas freshness 逐位元組相符，詳細數量見 execution.json。

獨立 R1 作者先跑原 18 項基線，舊 source 取消遭拒後 binding.close 應 1 實際 0 為有效 Red；另發現 inactive geometry 問題。首次整合 ordinary-rejection fixture 將回覆升版但永久保留舊 drawing，混入額外同步錯誤；作者保留原斷言，改為無變更的普通拒絕，並另加真實延後發布案例保護快取競態。R2 原 loader/surface 2 pass，兩個實際 renderer 的 controller replacement 取得有效 Red，整合 38 pass。測試與 fixture 由作者凍結雜湊後原樣拷貝；未降低基準或豁免邊界。

整合期間 application import 次序錯誤由所屬 BUILD 範圍修正；早期未複製凍結 R2 測試造成的缺參數／缺檔屬載入失敗，未當成產品 Red。完整初始與修正紀錄保存在外部 evidence。

## 證據限制

final 文字 session 無可注入 close 計數，使用真實 binding 次數、TextInput disconnect、stale input 不提交及既有 session 測試觀察釋放。上游 final channels 的 bind(false) 沒有外部可控制 await，因此用共享 channel 競爭及下一個真實 configure/open await 驗證 ownership；未加入產品測試掛鉤。原生 Windows WebView 及視覺／操作手感未執行，維持 human-pending；agent 不宣稱平台感官驗收。

原工作樹只回存预先雜湊且未改變的精確 paths，HEAD/index 保護與回存結果見外部 transfer receipt。剩餘 APP-V1-05、FEAT-V1-06 與全 50 切片最終證據稽核；本次不關閉整體目標。
