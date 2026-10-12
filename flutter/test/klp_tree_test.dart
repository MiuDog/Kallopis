import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('側邊欄樹狀物件支援 PENDING、STALE、APPROVED、REJECTED 狀態與高對比選取框', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final tokens = brightness == Brightness.light
          ? KlpThemeData.light
          : KlpThemeData.dark;

      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(brightness),
          theme: buildKlpTheme(brightness),
          home: Scaffold(
            body: KlpTree(
              nodes: [
                KlpTreeNode(
                  id: 'proposals',
                  label: '提案',
                  icon: KlpIcons.folder,
                  children: [
                    KlpTreeNode(
                      id: 'pending',
                      label: '補上 unver...',
                      icon: KlpIcons.checkSquare,
                      badge: 'PENDING',
                      tone: KlpFeedbackTone.warning,
                    ),
                    KlpTreeNode(
                      id: 'stale',
                      label: '匯入報告加上逐...',
                      icon: KlpIcons.checkSquare,
                      badge: 'STALE',
                      tone: KlpFeedbackTone.info,
                      selected: true,
                    ),
                    KlpTreeNode(
                      id: 'approved',
                      label: 'anchor 四...',
                      icon: KlpIcons.checkSquare,
                      badge: 'APPROVED',
                      tone: KlpFeedbackTone.success,
                    ),
                    KlpTreeNode(
                      id: 'rejected',
                      label: '以 wall c...',
                      icon: KlpIcons.checkSquare,
                      badge: 'REJECTED',
                      tone: KlpFeedbackTone.danger,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // 檢查文字與徽章渲染
      expect(find.text('提案'), findsOneWidget);
      expect(find.text('補上 unver...'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.text('匯入報告加上逐...'), findsOneWidget);
      expect(find.text('STALE'), findsOneWidget);
      expect(find.text('anchor 四...'), findsOneWidget);
      expect(find.text('APPROVED'), findsOneWidget);
      expect(find.text('以 wall c...'), findsOneWidget);
      expect(find.text('REJECTED'), findsOneWidget);

      final isDark = brightness == Brightness.dark;
      final expectedPendingAlpha = isDark ? 0.28 : 0.14;
      final expectedStaleAlpha = isDark ? 0.48 : 0.32;

      // 檢查未選取狀態背景半透明柔和色
      final pendingContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('補上 unver...'),
              matching: find.byType(Container),
            )
            .first,
      );
      final pendingDeco = pendingContainer.decoration as BoxDecoration;
      expect(
        pendingDeco.color,
        tokens.warning.withValues(alpha: expectedPendingAlpha),
      );

      // 檢查選取狀態背景半透明高亮色
      final staleContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('匯入報告加上逐...'),
              matching: find.byType(Container),
            )
            .first,
      );
      final staleDeco = staleContainer.decoration as BoxDecoration;
      expect(
        staleDeco.color,
        tokens.info.withValues(alpha: expectedStaleAlpha),
      );
    }
  });
}
