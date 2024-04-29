import 'runner.dart';

class Test extends Runner {

  void firstMethod() => print("should run");
  void secondMethod(String n) => print("shouldn't run");
  String thirdMethod() { print("should run"); return ""; }
  void helperMethod() => print("shouldn't run");
  void methodHelper() => print("shouldn't run");
  void thirdHelperMethod() => print("shouldn't run");

  @run()
  void firstHelper() => print("should run");

  void fourthMethod() => print("shouldn't run");

  @run()
  @helper()
  void fifthMethod() => print("should run");

  @helper(run: true)
  void sixthMethod() => print("should run");


}
