
import 'package:test/test.dart';

void main() {

  test("empty string", () {
    expect(ParametersSeparator.separates(""), equals([]));
  });

}