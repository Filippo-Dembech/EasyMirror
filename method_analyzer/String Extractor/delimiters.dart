enum Delimiters {
  ROUND_BRACKETS("(", ")"),
  SQUARED_BRACKETS("[", "]"),
  CURLY_BRACKETS("{", "}"),
  DIAMOND_BRACKETS("<", ">");

  final String opening;
  final String closing;

  const Delimiters(this.opening, this.closing);

  String toString() => "'$opening', '$closing'";
}
