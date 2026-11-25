# 活動清單組裝

複製ActivityFeed.tsx與activity-feed.css至consumer；依[架構契約](architecture.md)填toolbar、項目heading/description/metadata/actions、empty與notice。

只搬移既有flat panel、contentInset與操作列，沒有新套件API。資料、已讀、篩選、時間格式、順序、路由及保存由consumer處理；不得將這些邏輯放回模板。來源為Unico依使用者視覺回存要求的呈現組裝，2026-10-18。

編譯、複製hash與scope gate為程式證據，實際畫面仍human-pending。
