import 'dart:mirrors';

import 'logger/logger_test.dart';
import 'runner/runner.dart';
import 'running_manager.dart';

class test {
  const test();
}

class Person {
  String _name;
  static int peopleAmount = 0;

  static int enrollPerson() => ++peopleAmount;

  static int expelPerson() => --peopleAmount;

  Person([this._name = "john doe"]);

  Person.eric() : _name = "eric";

  void get name => _name;

  @test()
  String scream(String sth) => sth.toUpperCase();

  void sayHello() {
    print("hello from person");
  }
}

class Test {
  void firstTest() {}

  String secondTest() => "second Test";

  int thirdTest(int a, int b) => a + b;

  String fourthTest({required String name, required int age}) =>
      "Happy birthday $name, you are $age";

  String fifthTest(String firstName, int age, {required String lastName}) =>
      "Happy birthday $firstName $lastName, you are $age";


}

void main() {


  final a = RunningManager(Test());

  a.simpleGeneralRun(
    positionals: {
      #thirdTest: [3, 8],
      #fifthTest: ["Princess", 40]
    },
    named: {
      #fourthTest: {
        #name: "Princess Caoline",
        #age: 32
      },
      #fifthTest: {
        #lastName: "Caroline",
      }
    },

  );
}
