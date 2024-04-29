extension whiteSpacesRemover on String {
  String withoutWhiteSpaces() => this.replaceAll(" ", "");
}
