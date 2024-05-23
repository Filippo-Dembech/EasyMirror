class WhiteSpacesPermutator {
  static List<String> permutationsOf(String text) {
    String trimmedText = text.trim();
    if (trimmedText.isEmpty) return [];
    if (!trimmedText.contains(" ")) return [text];

    List<String> words = _reducedWhitespaces(trimmedText).split(" ");

    if (words.length == 2)
      return [
        spaceBetween(words[0], words[1]),
        noSpaceBetween(words[0], words[1])
      ];

    List<String> intermediateResults =
        permutationsOf(words.sublist(0, words.length - 1).join(" "));

    List<String> result = [];

    for (String word in intermediateResults) {
      result.add("$word${words[words.length - 1]}");
      result.add("$word ${words[words.length - 1]}");
    }

    return result;
  }

  static String _reducedWhitespaces(String text) =>
      text.replaceAll(RegExp(r"\s+"), " ");

  static String spaceBetween(String a, String b) => "$a $b";
  static String noSpaceBetween(String a, String b) => "$a$b";
}
