import 'package:techoffice/api/APIError.dart';

class APIResponse {
  APIError _error;
  bool _isError;
  var _data;

  bool _isLoading = true;

  bool get isEmpty =>
      (data == null && isLoading == false) ||
      (data != null && data.isEmpty && isLoading == false);

  bool get isLoading => _isLoading;

  dynamic get data => _data;

  set data(var value) {
    _isLoading = false;
    _data = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
  }

  APIError get error => _error;

  set error(APIError value) {
    isError = true;
    isLoading = false;
    _error = value;
  }

  bool get isError => _isError;

  set isError(bool value) {
    if (!value) {
      isLoading = true;
    }
    _isError = value;
  }

  APIResponse() {
    error = null;
    isError = false;
  }
}
