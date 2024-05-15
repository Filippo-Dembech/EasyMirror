import 'dart:mirrors';

import 'package:easy_mirror/easy_mirror.dart';
import 'package:easy_mirror/src/method_analyzer/parameter_type.dart';
import 'package:test/test.dart';

class NoParamClass {
  void a() {
    print("a");
  }
}

class OnePositionalParamClass {
  void a(String a) {
    print("a");
  }
}

List<Parameter> onePositionalParamList = [
  Parameter(dataType: "String", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional)
];


class TwoPositionalParamClass {

  void a(int a, int b) {
    print("a, b");
  }
}

List<Parameter> twoPositionalParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional)
];


class OptionalPositionalParamClass {
  // methods with optional positional parameters
  void a([int? optionalA, int? optionalB]) {
    print("c");
  }
}

List<Parameter> optionalPositionalParamList = [
  Parameter(dataType: "int?", name: "optionalA", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "int?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional)
];

class PositionalAndOptionalPositionalParamClass {
  // methods with positional parameters and optional positional parameters
  void a(int a, int b, [int? optionalC, int? optionalD]) {
    print("d");
  }
}
List<Parameter> positionalAndOptionalPositionalParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "optionalC", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "int?", name: "optionalD", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional)
];

class NamedParamClass {
  // methods with named parameters
  void a({int? namedA, int? namedB}) {
    print("e");
  }
}

List<Parameter> namedParamList = [
  // TODO: this parameters should be optionalNamed because they aren't required (BUT, does it really makes sense to do that distinction as long as isRequired is 'false')
  Parameter(dataType: "int?", name: "namedA", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "int?", name: "namedB", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named)
];


class PositionalAndNamedParamClass {
  // methods with positional parameters and named parameters
  void a(int a, int b, {int? namedC, int? namedD}) {
    print("f");
  }
}

List<Parameter> positionalAndNamedParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "namedC", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "int?", name: "namedD", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named)
];

class NoParamReturningClass {
  // methods without parameters and returning value
  String a() => "a";
}
List<Parameter> noParamReturningList = [];

class PositionalParamReturningClass {
  // methods with positional parameters and returning value
  String a(int a, int b) => "b";
}

List<Parameter> positionalParamReturningList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];

class OptionalPositionalParamReturningClass {
  // methods with optional positional parameters and returning value
  String a([int? optionalA, int? optionalB]) => "c";
}

List<Parameter> OptionalPositionalParamReturningList = [
  Parameter(dataType: "int?", name: "optionalA", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "int?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];

class PositionalAndOptionalPositionalParamReturningClass {
  // methods with positional parameters and optional positional parameters and returning value
  String a(int a, int b, [int? optionalC, int? optionalD]) => "d";
}

List<Parameter> positionalAndOptionalPositionalParamReturningList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "optionalC", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "int?", name: "optionalD", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];

class NamedParamReturningClass {
  // methods with named parameters and returning value
  String a({int? namedA, int? namedB}) => "e";
}

List<Parameter> namedParamReturningList = [
  // TODO: this parameters should be optionalNamed because they aren't required (BUT, does it really makes sense to do that distinction as long as isRequired is 'false')
  Parameter(dataType: "int?", name: "namedA", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "int?", name: "namedB", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named)
];


class PositionalAndNamedParamReturningClass {
  // methods with positional parameters and named parameters and returning value
  String a(int a, int b, {int? namedC, int? namedD}) => "f";
}

List<Parameter> positionalAndNamedParamReturningList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "namedC", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "int?", name: "namedD", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named)
];

class Generic<T, V, K> {}


class PositionalGenericsParamClass {
  // methods with positional parameters with generics
  void a(Generic<String, int, int> a, int b) {
    print("b");
  }
}

List<Parameter> positionalGenericsParamList = [
  // ! can't Write "Generic<String, int, int>" with spaces because the hash code would be different
  Parameter(dataType: "Generic<String,int,int>", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];

class OptionalPositionalGenericsParamClass {
  // methods with optional positional parameters with generics
  void a([int? optionalA, Generic<String, int, int>? optionalB]) {
    print("c");
  }
}
List<Parameter> optionalPositionalGenericsParamList = [
  Parameter(dataType: "int?", name: "optionalA", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "Generic<String,int,int>?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];

class PositionalAndOptionalGenericsParamClass {
  // methods with positional parameters and optional positional parameters with generics
  void a(int a, Generic<String, int, int> b, [int? optionalC, Generic<String, int, int>? optionalD]) {
    print("d");
  }
}

List<Parameter> positionalAndOptionalGenericsParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "Generic<String,int,int>", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "optionalC", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "Generic<String,int,int>?", name: "optionalD", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];


class NamedGenericsParamClass {
  // methods with named parameters with generics
  void a({int? namedA, Generic<String, int, int>? namedB}) {
    print("e");
  }
}

List<Parameter> namedGenericsParamList = [
  Parameter(dataType: "int?", name: "namedA", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "Generic<String,int,int>?", name: "namedB", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];


class PositionalAndNamedGenericsParamClass {
  // methods with positional parameters and named parameters with generics
  void a(int a, Generic<String, int, int> b, {int? namedC, Generic<String, int, int>? namedD}) {
    print("f");
  }
}

List<Parameter> positionalAndNamedGenericsParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "Generic<String,int,int>", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "namedC", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "Generic<String,int,int>?", name: "namedD", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];


class NoParamReturningGenericsClass {
  // methods without parameters with generics
  Generic<String, int, int> a() => Generic();
}

List<Parameter> noParamReturningGenericsList = [];

class PositionalGenericsParamReturningGenericsClass {
  // methods with positional parameters and returning value with generics
  Generic<String, int, int> a(Generic<String, int, int> a, int b) => Generic();
}

List<Parameter> positionalGenericsParamReturningGenericsList = [
  // ! can't Write "Generic<String, int, int>" with spaces because the hash code would be different
  Parameter(dataType: "Generic<String,int,int>", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];


class OptionalPositionalGenericsParamReturningGenericsClass {
  // methods with optional positional parameters and returning value with generics
  Generic<String, int, int> a([int? optionalA, Generic<String, int, int>? optionalB]) => Generic();
}

List<Parameter> optionalPositionalGenericsParamReturningGenericsList = [
  Parameter(dataType: "int?", name: "optionalA", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "Generic<String,int,int>?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];


class PositionalAndOptionalPositionalGenericsParamReturningGenericsClass {
  // methods with positional parameters and optional positional parameters and returning value with generics
  Generic<String, int, int> a(int a, Generic<String, int, int> b, [int? optionalC, Generic<String, int, int>? optionalD]) => Generic();
}


List<Parameter> positionalAndOptionalPositionalGenericsParamReturningGenericsList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "Generic<String,int,int>", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "optionalC", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "Generic<String,int,int>?", name: "optionalD", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];


class NamedGenericsParamReturningGenericsClass {
  // methods with named parameters and returning value with generics
  Generic<String, int, int> a({int? namedA, Generic<String, int, int>? namedB}) => Generic();
}

List<Parameter> namedGenericsParamReturningGenericsList = [
  Parameter(dataType: "int?", name: "namedA", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "Generic<String,int,int>?", name: "namedB", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];

class PositionalAndNamedGenericsParamReturningGenericsClass {
  // methods with positional parameters and named parameters and returning value with generics
  Generic<String, int, int> a(int a, Generic<String, int, int> b, {int? namedC, Generic<String, int, int>? namedD}) => Generic();
}

List<Parameter> positionalAndNamedGenericsParamReturningGenericsList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "Generic<String,int,int>", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "namedC", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "Generic<String,int,int>?", name: "namedD", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];



class PositionalRecordParamClass {
  // methods with positional parameters with generics
  void a((String, int) a, int b) {
    print("b");
  }
}

List<Parameter> positionalRecordParamList = [
  // ! can't Write "Generic<String, int, int>" with spaces because the hash code would be different
  Parameter(dataType: "(String,int)", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];

class OptionalPositionalRecordParamClass {
  // methods with optional positional parameters with generics
  void a([int? optionalA, (String, int)? optionalB]) {
    print("c");
  }
}

List<Parameter> optionalPositionalRecordParamList = [
  Parameter(dataType: "int?", name: "optionalA", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "(String,int)?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];

class PositionalAndOptionalRecordParamClass {
  // methods with positional parameters and optional positional parameters with generics
  void a(int a, (String, int) b, [int? optionalC, (String, int)? optionalD]) {
    print("d");
  }
}

List<Parameter> positionalAndOptionalRecordParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "(String,int)", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "optionalC", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "(String,int)?", name: "optionalD", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];


class NamedRecordParamClass {
  // methods with named parameters with generics
  void a({int? namedA, (String, int)? namedB}) {
    print("e");
  }
}

List<Parameter> namedRecordParamList = [
  Parameter(dataType: "int?", name: "namedA", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "(String,int)?", name: "namedB", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];


class PositionalAndNamedRecordParamClass {
  // methods with positional parameters and named parameters with generics
  void a(int a, (String, int) b, {int? namedC, (String, int)? namedD}) {
    print("f");
  }
}

List<Parameter> positionalAndNamedRecordParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "(String,int)", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "namedC", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "(String,int)?", name: "namedD", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];


class NoParamReturningRecordClass {
  // methods without parameters with generics
  (String, int) a() => ("", 0);
}

List<Parameter> noParamReturningRecordList = [];

class PositionalRecordParamReturningRecordClass {
  // methods with positional parameters and returning value with generics
  (String, int) a((String, int) a, int b) => ("", 0);
}


List<Parameter> positionalRecordParamReturningRecordList = [
  // ! can't Write "Generic<String, int, int>" with spaces because the hash code would be different
  Parameter(dataType: "(String,int)", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];


class OptionalPositionalRecordParamReturningRecordClass {
  // methods with optional positional parameters and returning value with generics
  (String, int) a([int? optionalA, (String, int)? optionalB]) => ("", 0);
}

List<Parameter> optionalPositionalRecordParamReturningRecordList = [
  Parameter(dataType: "int?", name: "optionalA", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "(String,int)?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];


class PositionalAndOptionalPositionalRecordParamReturningRecordClass {
  // methods with positional parameters and optional positional parameters and returning value with generics
  (String, int) a(int a, (String, int) b, [int? optionalC, (String, int)? optionalD]) => ("", 0);
}


List<Parameter> positionalAndOptionalPositionalRecordParamReturningRecordList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "(String,int)", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "optionalC", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "(String,int)?", name: "optionalD", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];


class NamedRecordParamReturningRecordClass {
  // methods with named parameters and returning value with generics
  (String, int) a({int? namedA, (String, int)? namedB}) => ("", 0);
}

List<Parameter> namedRecordParamReturningRecordList = [
  Parameter(dataType: "int?", name: "namedA", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "(String,int)?", name: "namedB", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];

class PositionalAndNamedRecordParamReturningRecordClass {
  // methods with positional parameters and named parameters and returning value with generics
  (String, int) a(int a, (String, int) b, {int? namedC, (String, int)? namedD}) => ("", 0);
}

List<Parameter> positionalAndNamedRecordParamReturningRecordList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "(String,int)", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "namedC", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "(String,int)?", name: "namedD", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];


class RecordAndGenericsParamClass {
  void a((String, int) a, [Generic<String, int, int>? optionalB]) {
    print("B");
  }
}

List<Parameter> recordAndGenericsParamList = [
  Parameter(dataType: "(String,int)", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "Generic<String,int,int>?", name: "optionalB", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];

class RecordWithinRecordParamClass {
  void a(((String, int), int) a) {
    print("B");
  }
}

List<Parameter> recordWithinRecordParamList = [
  Parameter(dataType: "((String,int),int)", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];


class RequiredNamedParamClass {
  void a(int a, int b, {int? c, required int d}) {}
}

List<Parameter> requiredNamedParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "c", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "int", name: "d", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.named),
];


class FunctionRequiredNamedParamClass {
  void a(int a, Function(Generic<bool, int, int>) b, {int? c, required Function(int, int) d}) {}
}

List<Parameter> functionRequiredNamedParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "Function(Generic<bool,int,int>)", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
  Parameter(dataType: "int?", name: "c", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "Function(int,int)", name: "d", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.named),
];

class MultipleRequiedNamedParamClass {
  void a({required String a, required Generic<bool, String, int> b, required Function(int, int) c, required (String, int) d}) {}
}
List<Parameter> multipleRequiedNamedParamList = [
  Parameter(dataType: "String", name: "a", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.named),
  Parameter(dataType: "Generic<bool,String,int>", name: "b", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.named),
  Parameter(dataType: "Function(int,int)", name: "c", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.named),
  Parameter(dataType: "(String,int)", name: "d", defaultValue: null, hasDefaultValue: false, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.named),
];

class DefaultParamClass {
  void a({int a = 2}) {}
}

List<Parameter> defaultParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: "2", hasDefaultValue: true, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: false, type: ParameterType.named),
];


class OptionalDefaultParamClass {
  void a([int a = 2, int b = 3, int? c]) {}
}

List<Parameter> optionalDefaultParamList = [
  Parameter(dataType: "int", name: "a", defaultValue: "2", hasDefaultValue: true, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: false, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "int", name: "b", defaultValue: "3", hasDefaultValue: true, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: false, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "int?", name: "c", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: true, isRequired: false, type: ParameterType.optionalPositional),
];

class ListNamedDefaultParamClass {
  void a({List<String>? names = const []}) {}
}

List<Parameter> listNamedDefaultParamList = [
  Parameter(dataType: "List<String>?", name: "names", defaultValue: "const[]", hasDefaultValue: true, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: true, isRequired: false, type: ParameterType.named),
];

class LongNameParamClass {
  void a(String superBoss) {}
}

List<Parameter> longNameParamList = [
  Parameter(dataType: "String", name: "superBoss", defaultValue: null, hasDefaultValue: false, isNamed: false, isPositional: true, isOptionalPositional: false, isNullable: false, isRequired: true, type: ParameterType.positional),
];

class LongNameDefaultParamClass {
  void a([String superBoss = "me"]) {}
}

List<Parameter> longNameDefaultParamList = [
  Parameter(dataType: "String", name: "superBoss", defaultValue: "me", hasDefaultValue: true, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: false, isRequired: false, type: ParameterType.optionalPositional),
];


class EmptyRecordOptionalPositionalDefaultParamClass {
  void a([() a = ()]) {}
}

List<Parameter> emptyRecordOptionalDefaultPositionalParamList = [
  Parameter(dataType: "()", name: "a", defaultValue: "()", hasDefaultValue: true, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: false, isRequired: false, type: ParameterType.optionalPositional),
];

class MultipleEmptyRecordOptionalPositionalDefaultParamClass {
  void a([() a = (), () b = ()]) {}
}
List<Parameter> multipleEmptyRecordOptionalPositionalDefaultParamList = [
  Parameter(dataType: "()", name: "a", defaultValue: "()", hasDefaultValue: true, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: false, isRequired: false, type: ParameterType.optionalPositional),
  Parameter(dataType: "()", name: "b", defaultValue: "()", hasDefaultValue: true, isNamed: false, isPositional: false, isOptionalPositional: true, isNullable: false, isRequired: false, type: ParameterType.optionalPositional),
];

class EmptyRecordNamedDefaultParamClass {
  void a({() a = ()}) {}
}

List<Parameter> emptyRecordNamedDefaultParamList = [
  Parameter(dataType: "()", name: "a", defaultValue: "()", hasDefaultValue: true, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: false, type: ParameterType.named),
];

class MultipleEmptyRecordNamedDefaultParamClass {
  void a({() a = (), () b = ()}) {}
}

List<Parameter> multipleEmptyRecordNamedDefaultParamList = [
  Parameter(dataType: "()", name: "a", defaultValue: "()", hasDefaultValue: true, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: false, type: ParameterType.named),
  Parameter(dataType: "()", name: "b", defaultValue: "()", hasDefaultValue: true, isNamed: true, isPositional: false, isOptionalPositional: false, isNullable: false, isRequired: false, type: ParameterType.named),
];

/*
class EmptyRecordNamedParamClass {
  void a({() a = ()}) {}
}

class MultipleEmtpyRecordNamedParamClass {
  void a({() a = (), () b = ()}) {}
}
*/


void main() {

  test("No parameters method", () {
    expect(getFirstMethodParametersFrom(NoParamClass()), isEmpty);
  });

  test("one parameter method", () {
    expect(getFirstMethodParametersFrom(OnePositionalParamClass()), equals(onePositionalParamList));
  });

  test("two parameter method", () {
    expect(getFirstMethodParametersFrom(TwoPositionalParamClass()), equals(twoPositionalParamList));
  });

  test("optional positional parameter method", () {
    expect(getFirstMethodParametersFrom(OptionalPositionalParamClass()), equals(optionalPositionalParamList));
  });

  test("positional and optional positional parameter method", () {
    expect(getFirstMethodParametersFrom(PositionalAndOptionalPositionalParamClass()), equals(positionalAndOptionalPositionalParamList));
  });

  test("named parameter method", () {
    expect(getFirstMethodParametersFrom(NamedParamClass()), equals(namedParamList));
  });

  test("positional and named parameter method", () {
    expect(getFirstMethodParametersFrom(PositionalAndNamedParamClass()), equals(positionalAndNamedParamList));
  });

  test("no parameters and returning method", () {
    expect(getFirstMethodParametersFrom(NoParamReturningClass()), equals(noParamReturningList));
  });

  test("positional parameters and returning method", () {
    expect(getFirstMethodParametersFrom(PositionalParamReturningClass()), equals(positionalParamReturningList));
  });

  test("optional positional parameters and returning method", () {
    expect(getFirstMethodParametersFrom(OptionalPositionalParamReturningClass()), equals(OptionalPositionalParamReturningList));
  });

  test("positional and optional positional parameters and returning method", () {
    expect(getFirstMethodParametersFrom(PositionalAndOptionalPositionalParamReturningClass()), equals(positionalAndOptionalPositionalParamReturningList));
  });

  test("named parameters and returning method", () {
    expect(getFirstMethodParametersFrom(NamedParamReturningClass()), equals(namedParamReturningList));
  });

  test("positional and named parameters and returning method", () {
    expect(getFirstMethodParametersFrom(PositionalAndNamedParamReturningClass()), equals(positionalAndNamedParamReturningList));
  });

  // ====================== GENERICS ======================

  test("no parameters and returning generics method", () {
    expect(getFirstMethodParametersFrom(NoParamReturningGenericsClass()), equals(noParamReturningGenericsList));
  });

  test("positional generics parameters method", () {
    expect(getFirstMethodParametersFrom(PositionalGenericsParamClass()), equals(positionalGenericsParamList));
  });

  test("optional positional generics parameters method", () {
    expect(getFirstMethodParametersFrom(OptionalPositionalGenericsParamClass()), equals(optionalPositionalGenericsParamList));
  });

  test("positional and optional generics parameters method", () {
    expect(getFirstMethodParametersFrom(PositionalAndOptionalGenericsParamClass()), equals(positionalAndOptionalGenericsParamList));
  });

  test("named generics parameters method", () {
    expect(getFirstMethodParametersFrom(NamedGenericsParamClass()), equals(namedGenericsParamList));
  });

  test("positional and named generics parameters method", () {
    expect(getFirstMethodParametersFrom(PositionalAndNamedGenericsParamClass()), equals(positionalAndNamedGenericsParamList));
  });

  test("positional generics parameters returning generics method", () {
    expect(getFirstMethodParametersFrom(PositionalGenericsParamReturningGenericsClass()), equals(positionalGenericsParamReturningGenericsList));
  });

  test("optional positional generics parameters returning generics method", () {
    expect(getFirstMethodParametersFrom(OptionalPositionalGenericsParamReturningGenericsClass()), equals(optionalPositionalGenericsParamReturningGenericsList));
  });

  test("positional and optional positional generics parameters returning generics method", () {
    expect(getFirstMethodParametersFrom(PositionalAndOptionalPositionalGenericsParamReturningGenericsClass()), equals(positionalAndOptionalPositionalGenericsParamReturningGenericsList));
  });
  
  test("named positional generics parameters returning generics method", () {
    expect(getFirstMethodParametersFrom(NamedGenericsParamReturningGenericsClass()), equals(namedGenericsParamReturningGenericsList));
  });

  test("positional and named generics parameters returning generics method", () {
    expect(getFirstMethodParametersFrom(PositionalAndNamedGenericsParamClass()), equals(positionalAndNamedGenericsParamList));
  });

  // ====================== RECORD ======================

  test("no parameters and returning record method", () {
    expect(getFirstMethodParametersFrom(NoParamReturningRecordClass()), equals(noParamReturningRecordList));
  });

  test("positional record parameters method", () {
    expect(getFirstMethodParametersFrom(PositionalRecordParamClass()), equals(positionalRecordParamList));
  });

  test("optional positional record parameters method", () {
    expect(getFirstMethodParametersFrom(OptionalPositionalRecordParamClass()), equals(optionalPositionalRecordParamList));
  });

  test("positional and optional record parameters method", () {
    expect(getFirstMethodParametersFrom(PositionalAndOptionalRecordParamClass()), equals(positionalAndOptionalRecordParamList));
  });

  test("named record parameters method", () {
    expect(getFirstMethodParametersFrom(NamedRecordParamClass()), equals(namedRecordParamList));
  });

  test("positional and named record parameters method", () {
    expect(getFirstMethodParametersFrom(PositionalAndNamedRecordParamClass()), equals(positionalAndNamedRecordParamList));
  });

  test("positional record parameters returning record method", () {
    expect(getFirstMethodParametersFrom(PositionalRecordParamReturningRecordClass()), equals(positionalRecordParamReturningRecordList));
  });

  test("optional positional record parameters returning record method", () {
    expect(getFirstMethodParametersFrom(OptionalPositionalRecordParamReturningRecordClass()), equals(optionalPositionalRecordParamReturningRecordList));
  });

  test("positional and optional positional record parameters returning record method", () {
    expect(getFirstMethodParametersFrom(PositionalAndOptionalPositionalRecordParamReturningRecordClass()), equals(positionalAndOptionalPositionalRecordParamReturningRecordList));
  });
  
  test("named positional record parameters returning record method", () {
    expect(getFirstMethodParametersFrom(NamedRecordParamReturningRecordClass()), equals(namedRecordParamReturningRecordList));
  });

  test("positional and named record parameters returning generics method", () {
    expect(getFirstMethodParametersFrom(PositionalAndNamedRecordParamClass()), equals(positionalAndNamedRecordParamList));
  });


  // ====================== RECORD AND GENERICS ======================

  test("record and generics parameters method", () {
    expect(getFirstMethodParametersFrom(RecordAndGenericsParamClass()), equals(recordAndGenericsParamList));
  });

  // ====================== RECORD AND GENERICS ======================

  test("record within record parameters method", () {
    expect(getFirstMethodParametersFrom(RecordWithinRecordParamClass()), equals(recordWithinRecordParamList));
  });

  // ====================== REQUIRED NAMED ======================
  test("required named parameters method", () {
    expect(getFirstMethodParametersFrom(RequiredNamedParamClass()), equals(requiredNamedParamList));
  });

  test("required named parameters method", () {
    expect(getFirstMethodParametersFrom(FunctionRequiredNamedParamClass()), equals(functionRequiredNamedParamList));
  });

  test("multiple required named parameters method", () {
    expect(getFirstMethodParametersFrom(MultipleRequiedNamedParamClass()), equals(multipleRequiedNamedParamList));
  });

  // ====================== REQUIRED NAMED ======================

  test("default parameters method", () {
    expect(getFirstMethodParametersFrom(DefaultParamClass()), equals(defaultParamList));
  });
  
  test("optional default parameters method", () {
    expect(getFirstMethodParametersFrom(OptionalDefaultParamClass()), equals(optionalDefaultParamList));
  });

  test("long name parameters method", () {
    expect(getFirstMethodParametersFrom(LongNameParamClass()), equals(longNameParamList));
  });

  test("long name default parameters method", () {
    expect(getFirstMethodParametersFrom(LongNameDefaultParamClass()), equals(longNameDefaultParamList));
  });

  test("empty record optional positional parameters method", () {
    expect(getFirstMethodParametersFrom(EmptyRecordOptionalPositionalDefaultParamClass()), equals(emptyRecordOptionalDefaultPositionalParamList));
  });

  test("multiple empty record optional positional parameters method", () {
    expect(getFirstMethodParametersFrom(MultipleEmptyRecordOptionalPositionalDefaultParamClass()), equals(multipleEmptyRecordOptionalPositionalDefaultParamList));
  });

  test("empty record named parameters method", () {
    expect(getFirstMethodParametersFrom(EmptyRecordNamedDefaultParamClass()), equals(emptyRecordNamedDefaultParamList));
  });

  test("multiple empty record named parameters method", () {
    expect(getFirstMethodParametersFrom(MultipleEmptyRecordNamedDefaultParamClass()), equals(multipleEmptyRecordNamedDefaultParamList));
  });

}


List<Parameter> getFirstMethodParametersFrom(dynamic instance) {
    final a = reflect(instance);
    List<Parameter> result = [];
    a.type.declarations.forEach((symbol, declaration) {
      if (declaration is MethodMirror && !declaration.isConstructor) {
        final method = MethodAnalyzer(declaration);
        result = method.parameters;
      }
    });
    return result;
}