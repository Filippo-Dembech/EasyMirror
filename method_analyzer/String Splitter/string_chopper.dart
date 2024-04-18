/// Thrown when a [StringChopper] uses an out of range index
/// to chop the parsed string.
class ChoppingException implements Exception {
  String _message;
  ChoppingException(this._message);

  @override
  String toString() => "ChoppingException: $_message";
}

/// An utility class to chop a string.
///
/// The string passed to the constructor will be parsed and chopped
/// at indexes (excluded) specified in the [StringChopper.chopsAt]
/// method. The result of the chopping will be a list of the derived
/// chunks of the chopped string.
///
/// If one of the indexes exceedes the string length a [ChoppingException]
/// is thrown.
///
/// ---
///
/// For example:
/// ```dart
/// StringChopper("sample string").chopsAt([1]) // [ "s", "ample string"]
/// StringChopper("sample string").chopsAt([2, 8]) // [ "sa", "mple s, "tring"]
/// StringChopper("sample string").chopsAt([2, 3, 9]) // ["sa", "m", "ple st", "ring"]
/// StringChopper("sample string").chopsAt([20]) // ChoppingException...
/// ```
class StringChopper {
  /// The string to chop.
  final String _string;

  /// Creates a [StringChopper] with the string to chop.
  StringChopper(this._string);

  /// Chops the parsed string at the passed indexes.
  ///
  /// ## How Are Chunks Computed
  /// The first chunk is included between the index 0 and the
  /// first index of the passed list, which is excluded.
  /// Each index represents the beginning of a chunk (included)
  /// and its following index represents the ending of that chunk
  /// (excluded). For example:
  ///
  /// ```dart
  /// [1] // means two chunks - 'from index 0 (included) to 1 (excluded) and from 1 (included) to the end of the string.
  /// [2, 5] // means three chunks - 'from index 0 (included) to 2 (excluded), from 2 (included) to 5 (excluded), and from 5 (included) to the end of the string.
  /// ```
  /// ## Chopping Exception
  /// If one of the indexes exceedes the string length a [ChoppingException]
  /// is thrown.
  ///
  /// ## Exclude Indexes
  /// If [excludingIndexes] is `true` the characters at the indexes
  /// are completely ignored and none of them is included in any
  /// chunk.
  /// ---
  ///
  /// ## Examples
  /// ```dart
  /// StringChopper("sample string").chopsAt([1]) // [ "s", "ample string"]
  /// StringChopper("sample string").chopsAt([2, 8]) // [ "sa", "mple s, "tring"]
  /// StringChopper("sample string").chopsAt([2, 3, 9]) // ["sa", "m", "ple st", "ring"]
  /// StringChopper("sample string").chopsAt([20]) // ChoppingException...
  /// ```
  List<String> chopsAt(List<int> indexes, {bool excludingIndexes = false}) {
    _checkInRange(indexes);
    return (excludingIndexes)
        ? _excludingChopping(indexes, 1)
        : _excludingChopping(indexes, 0);
  }

  /// Chops the parsed string, excluding the passed indexes by the
  /// the value passed to [excluding]. No chunk contains any of the
  /// characters at the indexes.
  List<String> _excludingChopping(List<int> indexes, int excluding) {
    List<String> result = [];
    int chunkStart = 0;
    for (int chunkEnd in indexes) {
      result.add(_chunkAt(chunkStart, chunkEnd - excluding));
      chunkStart = chunkEnd;
    }
    result.add(_chunkAt(chunkStart));
    return result;
  }

  /// Checks whether all the indexes are less than the parsed
  /// string length.
  ///
  /// If one of the indexes is greater or equal the length of the
  /// string a [ChoppingException] is Thrown.
  ///
  /// For example:
  /// ```dart
  /// StringChopper("hello").chopsAt([3]) // ["hel", "lo"]
  /// StringChopper("hello").chopsAt([2, 4]) // [ "he", "ll, "o"]
  /// StringChopper("hello").chopsAt([5]) // ChoppingException...
  /// StringChopper("hello").chopsAt([8]) // ChoppingException...
  /// StringChopper("hello").chopsAt([1, 3, 8]) // ChoppingException... (because of 8 which is out of index)
  /// ```
  void _checkInRange(List<int> indexes) {
    for (int i in indexes)
      if (i > _string.length)
        throw ChoppingException(
          "Chopping index $i out of range. String length is only ${_string.length}",
        );
  }

  /// Chunks the parsed string from [start] to [end].
  ///
  /// If [end] is not given the substring from [start] to the end of
  /// the string is returned.
  String _chunkAt(int start, [int? end]) =>
      (end != null) ? _string.substring(start, end) : _string.substring(start);
}