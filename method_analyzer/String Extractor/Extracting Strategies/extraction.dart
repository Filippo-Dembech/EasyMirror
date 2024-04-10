import '../delimiters.dart';

abstract class Extraction {
  const Extraction();
  String extract(String string, Delimiters delimiters);
}