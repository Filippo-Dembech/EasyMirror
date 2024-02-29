class helper {
  final bool run;

  /// ---
  /// # Helper 😏
  /// This annotation marks a method as an _helper method_ for
  /// the `Runner' class where the helper methods aren't ran
  /// by default.
  /// ---
  /// # How to run helper methods
  /// ## Run all helper methods 🔗
  /// In order to run helper methods in the
  /// `Runner` class pass `runAlsoHelpers: true` to the
  /// `super` constructor of the class extending `Runner`.
  /// ## Run specific helper methods 📌
  /// Passing `run: true` to the `@helper()` annotation
  /// enforces the helper method to be treated as a normal
  /// method.<br>
  /// Example:
  /// ```dart
  /// @helper(run: true)
  /// void sampleMethod() {
  ///   // ...
  /// }
  /// ```
  const helper({this.run = false});
}
