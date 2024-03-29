class APIError {
  /// message get from your back-end
  dynamic serverMessage;

  /// your server back-end response status code
  int serverCode;

  /// code generated by this lib. to know the error place , start from 101
  int localCode;

  /// message by the lib. to use for get the correct message to describe the error
  /// you can add the APILocaleMessage values to you localization file as json key
  /// ex. tran(context , localMessage);
  /// => tran(context , "not_found"); ===> request url not found.
  APILocalMessage localMessage;

  /// the error type
  APIErrorType type;

  APIError(
      {this.serverMessage,
      this.serverCode,
      this.localCode,
      this.localMessage,
      this.type});

  @override
  String toString() {
    return this.serverMessage == null
        ? this.localMessage.toString().replaceFirst("APILocalMessage.", "") +
            "\n" +
            " كود : ${this.localCode}"
        : this
                .serverMessage
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", "")
                .replaceAll("[", "")
                .replaceAll(",", "")
                .replaceAll("]", "") +
            "\n" +
            " كود : ${this.serverCode}";
  }
}

enum APIErrorType {
  /// try and catch
  exception,

  /// {success:false}
  falseSuccess,

  /// {} no success key from back-end
  noSuccess,

  /// code not equal 200
  statueCode,

  /// laravel or any back-end validate
  validate,

  /// response from back-end == null
  nullResponse,

  /// un-known error
  unknown,
}

enum APILocalMessage {
  /// any request with 500 code
  internal_server_error,

  /// 404 code
  not_found,

  /// 401 code - no user in the back-end
  need_auth,

  /// may be internet connection
  unable_to_connect,

  /// no token stored in the app
  no_token,

  /// user canceled the request
  request_canceled,

  /// any other unknown status code
  server_status_error,

  /// time out for connect
  connect_timeout,

  /// time out while send the request
  send_timeout,

  /// time out while receive
  receive_timeout,

  /// validates error from back-end
  validates,

  /// unknown error
  unknown
}
