
import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

void main() {

  test("empty string", () {
    expect(ParametersTypeSplitter.separates(""), equals([]));
  });

}