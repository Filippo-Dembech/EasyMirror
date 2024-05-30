import 'package:collection/collection.dart';
import 'package:easy_mirror/src/method_analyzer/extensions/list__empty_string_remover.dart';


// TODO: review StringChopper documentation
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
    if (_string.isEmpty) return [];
    _checkInRange(choppingStrategy._indexes);
    return choppingStrategy.chops(_string);
  }

  /// Returns the substring of the parsed string after the specified index.
  /// 
  /// The returned substring is calculated from the passed [index], excluded,
  ///  up to the end of the parsed string. To include the character at the
  /// specified [index] into the returned substring set the named parameter
  /// [includeIndex] to `true`.
  /// 
  /// If the given index is greater then the length of the parsed string
  /// a [ChoppingException] is thorwn.
  /// 
  /// Examples:
  /// ```dart
  /// StringChopper("a").after(0); // ""
  /// StringChopper("a").after(0, includeIndex: true); // "a"
  /// StringChopper("sample string").after(2); // "ple string"
  /// StringChopper("sample string").after(2, includeIndex: true); // "mple string"
  /// StringChopper("sample string").after(0); // "ample string"
  /// StringChopper("sample string").after(0, includeIndex: true); // "sample string"
  /// StringChopper("sample string").after(12); // ""
  /// StringChopper("sample string").after(12, includeIndex: true); // "g"
  /// StringChopper("").after(2); // throws ChoppingException()
  /// StringChopper("hi there").after(20); // throws ChoppingException>()
  /// ```
  String after(int index, {bool includeIndex = false}) {
    _checkIndexInRange(index);
    return includeIndex 
      ? _string.substring(index)
      : _string.substring(index + 1);
  }

  /// Returns the substring of the parsed string before the specified index.
  /// 
  /// The returned substring is calculated from the beginning of the parsed
  /// string up to the given [index], excluded. To include the character at
  /// the specified [index] into the returned substring set the named parameter
  /// [includeIndex] to `true`.
  /// 
  /// If the given index is greater then the length of the parsed string
  /// a [ChoppingException] is thorwn.
  /// 
  /// Examples:
  /// ```dart
  /// StringChopper("a").before(0); // ""
  /// StringChopper("a").before(0, includeIndex: true); // "a"
  /// StringChopper("sample string").before(2); // "sa"
  /// StringChopper("sample string").before(2, includeIndex: true); // "sam"
  /// StringChopper("sample string").before(0); // ""
  /// StringChopper("sample string").before(0, includeIndex: true); // "s"
  /// StringChopper("sample string").before(12); // "sample strin"
  /// StringChopper("sample string").before(12, includeIndex: true); // "sample string"
  /// StringChopper("").before(2); // throws ChoppingException()
  /// StringChopper("hi there").before(20); // throws ChoppingException>()
  /// ```
  String before(int index, {bool includeIndex = false}) {
    _checkIndexInRange(index);
    String result = "";
    if (includeIndex)
      for (int i = 0; i <= index; i++) result += _string[i];
    else
      for (int i = 0; i < index; i++) result += _string[i];
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
          "Chopping index $i out of range. String length is only ${_string.length} long",
        );
  }

  void _checkIndexInRange(int index) {
    if (index >= _string.length)
      throw ChoppingException(
          "Chopping index $index out of range. '$_string' string length is only ${_string.length} long",
      );

  }
}

abstract class ChoppingStrategy {
  final List<int> _indexes;

  const ChoppingStrategy(this._indexes);

  List<String> chops(String string) {
    if (!_indexes.isSorted((a, b) => a.compareTo(b)))
      throw UnsortedIndexesException(
          "given indexes $_indexes are not sorted. Only provide sorted indexes with ChoppingStrategies",
      );

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
/// StringChopper("a").copsAt(Included([0])) // [ "a" ]
/// StringChopper("abc").chopsAt(Included([0, 1, 2])), // ["a", "b", "c"]));
/// StringChopper("sample string").copsAt(Included([3])) // [ "sam", "ple string"]
/// StringChopper("sample string").copsAt(Included([3, 5])) // [ "sam", "pl", "e string"]
/// ```
class Included extends ChoppingStrategy {

  /// A [ChoppingStrategy] that includes the specified indexes.
  ///
  /// The first chunk is included between the index 0 and the
  /// first index of the passed list, which is excluded.
  /// Each index represents the beginning of a chunk (included)
  /// and its following index represents the ending of that chunk
  /// (excluded). For example:
  ///
  /// ```dart
  /// StringChopper("a").copsAt(Included([0])) // [ "a" ]
  /// StringChopper("abc").chopsAt(Included([0, 1, 2])), // ["a", "b", "c"]));
  /// StringChopper("sample string").copsAt(Included([3])) // [ "sam", "ple string"]
  /// StringChopper("sample string").copsAt(Included([3, 5])) // [ "sam", "pl", "e string"]
  /// ```
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
/// StringChopper("ab").chopsAt(Excluded([0, 1])) // [];
/// StringChopper("abc").chopsAt(Excluded([0, 1, 2])) // [];
/// StringChopper("sample string").copsAt(Excluded([3])) // [ "sam", "le string"]
/// StringChopper("sample string").copsAt(Excluded([3, 5])) // [ "sam", "l", " string"]
///
/// ```
class Excluded extends ChoppingStrategy {

  /// A [ChoppingStrategy] that excluded the specified indexes.
  ///
  /// The characters that lay at the specified indexes are discarded
  /// and the returning list is made up of all the remaning characters
  /// split by those indexes.
  ///
  /// ```dart
  /// StringChopper("ab").chopsAt(Excluded([0, 1])) // [];
  /// StringChopper("abc").chopsAt(Excluded([0, 1, 2])) // [];
  /// StringChopper("sample string").copsAt(Excluded([3])) // [ "sam", "le string"]
  /// StringChopper("sample string").copsAt(Excluded([3, 5])) // [ "sam", "l", " string"]
  /// ```
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
