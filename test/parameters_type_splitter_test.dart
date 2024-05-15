
import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

void main() {

  test("empty string", () {
    expect(ParametersTypeSplitter().separates(""), equals([]));
  });

  test("one positional parameter", () {
    expect(ParametersTypeSplitter().separates("int a"), equals([{"type": ParameterType.positional, "text": "inta"}]));
  });

  test("two positional parameter", () {
    expect(ParametersTypeSplitter().separates("int a, int b"), equals([{"type": ParameterType.positional, "text": "inta"}, {"type": ParameterType.positional, "text": "intb"}]));
  });

  test("only positional", () {
    expect(ParametersTypeSplitter().separates("[int a, int b]"), equals([{"type": ParameterType.optionalPositional, "text": "inta"}, {"type": ParameterType.optionalPositional, "text": "intb"}]));
  });

  test("optional positional parameter", () {
    expect(ParametersTypeSplitter().separates("int a, [int optionalB, int optionalC]"), equals([{"type": ParameterType.positional, "text": "inta"}, {"type": ParameterType.optionalPositional, "text": "intoptionalB"}, {"type": ParameterType.optionalPositional, "text": "intoptionalC"}]));
  });

  test("named parameter", () {
    expect(ParametersTypeSplitter().separates("int a, {int namedB, int namedC}"), equals([{"type": ParameterType.positional, "text": "inta"}, {"type": ParameterType.named, "text": "intnamedB"}, {"type": ParameterType.named, "text": "intnamedC"}]));
  });

  test("generics parameter", () {
    expect(ParametersTypeSplitter().separates("Generic<String, int, int> a, {Generic<String, int, int> namedB, int namedC}"), equals([{"type": ParameterType.positional, "text": "Generic<String,int,int>a"}, {"type": ParameterType.named, "text": "Generic<String,int,int>namedB"}, {"type": ParameterType.named, "text": "intnamedC"}]));
  });
}