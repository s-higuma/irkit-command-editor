class Util {
  static List<String> getRange(String firstChar, String lastChar) {
    final first = firstChar.codeUnitAt(0);
    final last = lastChar.codeUnitAt(0);
    final List<String> result = [];
    for (var i = first; i <= last; i++) {
      result.add(String.fromCharCode(i));
    }
    return result;
  }
}
