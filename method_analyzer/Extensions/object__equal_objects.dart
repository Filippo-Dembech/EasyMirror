extension equalObjects on Object {
  bool isEqualTo(Object o) => this == o && this.runtimeType == o.runtimeType;
}
