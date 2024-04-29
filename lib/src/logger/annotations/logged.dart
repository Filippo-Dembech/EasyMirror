/// ---
/// # Logged 🗈
/// use the `@logged()` annotation with the `Logger` class
/// to mark a method to be a _logged method_.
/// Logged methods are automatically invoked when a new
/// instance is created.
/// To show a message when the method is called use the optional
/// [msg] parameter and the passed `String` will be printed
/// next to the name of the logged method.
/// Example:
/// ```dart
/// @logged("my message")
/// void sampleMethod() {
///   // ...
/// }
/// ```
/// output:
/// ```
/// >>> sampleMethod() is running ...  my message
/// ```

class logged {
  /// ---
  /// The message showed next to the method's name when it
  /// is called.
  final String msg;

  const logged([this.msg = ""]);
}
