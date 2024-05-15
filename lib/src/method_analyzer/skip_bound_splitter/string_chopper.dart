import 'package:collection/collection.dart';
import 'package:easy_mirror/src/method_analyzer/extensions/list__empty_string_remover.dart';

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
  /// It depends on the passed [ChoppingStrategy]. There are two
  /// [ChoppingStrategy] you can chose: [Included] and [Excluded].
  /// To understand how they decide how chop the string check their
  /// documentation.
  ///
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
  List<String> chopsAt(ChoppingStrategy choppingStrategy) {
    // TODO: method with multiple responsibilities (validate indexes and compute chunks)
    if (_string.isEmpty) return [""];
    _checkInRange(choppingStrategy._indexes);
    return choppingStrategy.chops(_string);
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
}

abstract class ChoppingStrategy {
  final List<int> _indexes;

  const ChoppingStrategy(this._indexes);

  List<String> chops(String string) {
    if (!_indexes.isSorted((a, b) => a.compareTo(b)))
      throw UnsortedIndexesException(
          "given indexes $_indexes are not sorted. Only provide sorted indexes with ChoppingStrategies");

    List<String> result = [];
    int chunkStart = 0;
    for (int chunkEnd in _indexes) {
      var chunk = string.substring(chunkStart, chunkEnd);
      result.add(chunk);
      chunkStart = _shift(chunkEnd);
    }
    result.add(string.substring(chunkStart));
    return result.withoutEmptyStrings();
  }

  int _shift(int chunkEnd);
}

/// A [ChoppingStrategy] that includes the specified indexes.
///
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
class Included extends ChoppingStrategy {
  const Included(super._indexes);

  @override
  int _shift(int chunkEnd) => chunkEnd;
}

/// A [ChoppingStrategy] that excluded the specified indexes.
///
/// The characters that lay at the specified indexes are discarded
/// and the returning list is made up of all the remaning characters
/// split by those indexes.
///
/// ```dart
/// StringChopper("sample string").copsAt(Excluded([3])) // [ "sam", "le string"]
/// StringChopper("sample string").copsAt(Excluded([3, 5])) // [ "sam", "l", " string"]
///
/// ```
class Excluded extends ChoppingStrategy {
  const Excluded(super._indexes);

  @override
  int _shift(int chunkEnd) => chunkEnd + 1;
}

/// Thrown when a [StringChopper] uses an out of range index
/// to chop the parsed string.
class ChoppingException implements Exception {
  String _message;
  ChoppingException(this._message);

  @override
  String toString() => "ChoppingException: $_message";
}

class UnsortedIndexesException implements Exception {
  String _message;
  UnsortedIndexesException(this._message);

  @override
  String toString() => "UnsortedIndexesException: $_message";
}
