import 'logger.dart';

class LoggerTest extends Logger {

  void nonLoggedMethod() => print("non logged method");

  @logged()
  void loggedMethodWithoutMessage() => print("logged method without message");

  @logged("logged message")
  void loggedMethodWithMessage() => print("logged method with message");

}