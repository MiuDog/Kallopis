import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('legacy KlpSpacingTheme constructor call omits iconGlyph', () {
    const legacySpacing = KlpSpacingTheme(
      hairline: 1,
      tight: 2,
      compact: 3,
      base: 4,
      comfortable: 5,
      loose: 6,
      section: 7,
      page: 8,
      controlPaddingX: 9,
      controlPaddingY: 10,
      containerPadding: 11,
      itemGap: 12,
      groupGap: 13,
      controlHeight: 14,
      controlHeightSmall: 15,
      controlHeightLarge: 16,
      iconSmall: 17,
      icon: 20,
      iconLarge: 21,
      chromeHeader: 22,
      chromeStatusBar: 23,
      chromeRail: 24,
      chromeTab: 25,
      iconButton: 26,
      iconTiny: 27,
      indicatorDot: 28,
      indicatorDotLarge: 29,
      switchTrackWidth: 30,
      switchTrackHeight: 31,
      switchThumb: 32,
      noticeIconSlot: 33,
      toastIconSlot: 34,
      gutterNumber: 35,
      gutterMarker: 36,
      micro: 37,
      calendarContentCell: 38,
      iconMicro: 39,
      avatarSmall: 40,
      progressTrack: 41,
      skeletonLine: 42,
      railItem: 43,
      drawerWidth: 44,
      drawerHeight: 45,
    );

    expect(legacySpacing.iconGlyph, 18);
    expect(legacySpacing.controlHeightXSmall, 30);
  });
}
