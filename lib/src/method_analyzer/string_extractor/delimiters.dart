enum Delimiters {
  ROUND_BRACKETS("(", ")"),
  SQUARED_BRACKETS("[", "]"),
  CURLY_BRACKETS("{", "}"),
  DIAMOND_BRACKETS("<", ">");

  final String opening;
  final String closing;

  const Delimiters(this.opening, this.closing);

  static bool isOpeningDelimiter(String string) =>
      Delimiters.values.any((delimiters) => delimiters.opening == string);

  static bool isClosingDelimiter(String string) =>
      Delimiters.values.any((delimiters) => delimiters.closing == string);

  static Delimiters of(String string) =>
      Delimiters.values.firstWhere((delimiters) => delimiters.contains(string));

  static countOperation(
      Delimiters delimiters,
      Function(
        Delimiters delimiters,
        int openingCount,
        int closingCount,
      ) f) {
    int openingCount = 1;
    int closingCount = 0;
    f(delimiters, openingCount, closingCount);
  }

  bool contains(String string) => opening == string || closing == string;

  String toString() => "'$opening', '$closing'";
}
