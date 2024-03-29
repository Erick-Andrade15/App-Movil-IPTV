// ignore_for_file: prefer_typing_uninitialized_variables

class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  // ignore: annotate_overrides
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, "Unauthorised Request: ");
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}