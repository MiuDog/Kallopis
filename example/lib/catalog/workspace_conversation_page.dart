import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final workspaceConversationPage = CatalogPageData(
  label: 'Conversation',
  title: '訊息串與輸入器',
  description: '對話的通用呈現與輸入 chrome；角色、內容、範圍與提交行為由消費端提供。',
  icon: KlpIcons.sparkles,
  specimens: [
    Specimen(
      name: 'KlpMessageBubble',
      note: '作者、時間與內容的單一訊息。',
      build: (context) => const KlpMessageBubble(
        author: 'Assistant',
        timestamp: '12:01',
        emphasized: true,
        child: KlpText('摘要完成；內容仍由消費端與資料來源負責。'),
      ),
    ),
    Specimen(
      name: 'KlpMessageThread',
      note: '排列訊息並提供載入較早內容的入口。',
      build: (context) => KlpMessageThread(
        loadOlderLabel: '載入較早訊息',
        onLoadOlder: () {},
        messages: const [
          KlpMessageBubble(
            author: '你',
            timestamp: '11:58',
            child: KlpText('請整理這段資料的三個重點。'),
          ),
          KlpMessageBubble(
            author: 'Assistant',
            timestamp: '11:59',
            emphasized: true,
            child: KlpText('第一個重點是統一入口，第二個是集中排程。'),
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpMessageComposer',
      note: '多行輸入、範圍標籤、附件與送出動作。',
      build: (context) => KlpMessageComposer(
        tags: const ['這則筆記', '整個專案'],
        placeholder: '輸入訊息…',
        sendLabel: '送出',
        attachLabel: '加入附件',
        onChanged: (_) {},
        onAttach: () {},
        onSend: () {},
      ),
    ),
  ],
);
