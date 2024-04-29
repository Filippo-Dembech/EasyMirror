extension emptyStringRemover on List<String> {
  List<String> withoutEmptyStrings() => this.where((str) => str != "").toList();
}
