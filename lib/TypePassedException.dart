class TypePassedException implements Exception {

  final String passedType;

  TypePassedException([this.passedType = ""]);

  @override
  String toString() => "TypePassedException: can't pass Type '$passedType', class instance must be passed.";
}