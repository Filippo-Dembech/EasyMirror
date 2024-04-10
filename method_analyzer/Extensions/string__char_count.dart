extension charCount on String {
  int counts(String substring) {
    int result = 0;
    for (int i = 0; i < this.length; i++)
      if (this[i] == substring) result++;
    return result;
  }
}