import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hbb/mobile/soft_keyboard_input.dart';

void main() {
  final prefix = '1' * 1024;

  test('replaces an equal-length pinyin initial with a selected Hanzi', () {
    expect(
      getNonIOSSoftKeyboardEdit('${prefix}w', '$prefix我'),
      (backspaces: 1, text: '我'),
    );
  });

  test('removes every pinyin letter before inserting a selected Hanzi', () {
    expect(
      getNonIOSSoftKeyboardEdit('${prefix}ni', '$prefix你'),
      (backspaces: 2, text: '你'),
    );
  });

  test('removes every deleted character', () {
    expect(
      getNonIOSSoftKeyboardEdit('${prefix}abc', '${prefix}a'),
      (backspaces: 2, text: ''),
    );
  });

  test('replaces an emoji as one character', () {
    expect(
      getNonIOSSoftKeyboardEdit('$prefix😀', '$prefix😁'),
      (backspaces: 1, text: '😁'),
    );
  });

  test('appends ordinary input without deleting existing text', () {
    expect(
      getNonIOSSoftKeyboardEdit('${prefix}a', '${prefix}ab'),
      (backspaces: 0, text: 'b'),
    );
  });

  test('does nothing when the input method repeats the same value', () {
    expect(
      getNonIOSSoftKeyboardEdit('${prefix}a', '${prefix}a'),
      (backspaces: 0, text: ''),
    );
  });

  test('grapheme diff is enabled for IME edits after the intact sentinel', () {
    expect(
      canUseNonIOSSoftKeyboardDiff(
          '${prefix}ni', '$prefix你', prefix, prefix.length + 1),
      isTrue,
    );
    expect(
      canUseNonIOSSoftKeyboardDiff(
          '$prefix😀', '$prefix😁', prefix, prefix.length + 2),
      isTrue,
    );
    expect(
      canUseNonIOSSoftKeyboardDiff(
          '${prefix}abc', '${prefix}a', prefix, prefix.length + 1),
      isTrue,
    );
  });

  test('grapheme diff is disabled when the leading 1 run changes', () {
    final suffix = 'a' * 500;
    expect(
      canUseNonIOSSoftKeyboardDiff(
          '${prefix}1$suffix', '$prefix$suffix', prefix, prefix.length),
      isFalse,
    );
    expect(
      canUseNonIOSSoftKeyboardDiff('${prefix}1', prefix, prefix, prefix.length),
      isFalse,
    );
  });

  test('grapheme diff is disabled for edits within the sentinel', () {
    final changedPrefix = '${'1' * 512}a${'1' * 511}';
    expect(
      canUseNonIOSSoftKeyboardDiff(prefix, changedPrefix, prefix, 513),
      isFalse,
    );
  });

  test('grapheme diff requires a valid caret after the sentinel', () {
    expect(
      canUseNonIOSSoftKeyboardDiff('${prefix}w', '$prefix我', prefix, null),
      isFalse,
    );
    expect(
      canUseNonIOSSoftKeyboardDiff(prefix, '', prefix, 0),
      isFalse,
    );
    expect(
      canUseNonIOSSoftKeyboardDiff(
          '${prefix}w', '$prefix我', prefix, prefix.length - 1),
      isFalse,
    );
  });
}
