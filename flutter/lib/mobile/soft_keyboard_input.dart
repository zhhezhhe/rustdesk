import 'package:flutter/widgets.dart';

({int backspaces, String text}) getNonIOSSoftKeyboardEdit(
    String oldValue, String newValue) {
  final oldCharacters = oldValue.characters.toList(growable: false);
  final newCharacters = newValue.characters.toList(growable: false);
  var common = 0;
  while (common < oldCharacters.length &&
      common < newCharacters.length &&
      oldCharacters[common] == newCharacters[common]) {
    common++;
  }
  return (
    backspaces: oldCharacters.length - common,
    text: newCharacters.skip(common).join(),
  );
}

bool canUseNonIOSSoftKeyboardDiff(
    String oldValue, String newValue, String sentinel, int? selectionOffset) {
  if (selectionOffset == null ||
      selectionOffset < sentinel.length ||
      selectionOffset > newValue.length ||
      !oldValue.startsWith(sentinel) ||
      !newValue.startsWith(sentinel)) {
    return false;
  }

  int leadingOnesEnd(String value) {
    var i = sentinel.length;
    while (i < value.length && value[i] == '1') {
      i++;
    }
    return i;
  }

  // A real 1 can mask a deleted sentinel 1 in the same leading run.
  return leadingOnesEnd(oldValue) == leadingOnesEnd(newValue);
}
