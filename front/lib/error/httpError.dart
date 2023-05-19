class httpError implements Exception{
  final String _message;

  httpError(this._message);

  String toString() {
    return _message;
  }

  String get message {
    return _message;
  }
}
