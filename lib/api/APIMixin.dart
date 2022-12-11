import 'dart:async';

import 'package:dio/dio.dart';
import 'package:techoffice/api/APIError.dart';
import 'package:techoffice/utils/Auth.dart';

class APIMixin extends Object {
  getWithToken(url) async {
    var token = await getToken();

    if (token == null) {
      return Future.error(APILocalMessage.no_token);
    }

    Future<Response> response = Dio().get(
      url,
      options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
          headers: {
            Headers.acceptHeader: Headers.jsonContentType,
          }),
      queryParameters: {"api_token": token},
    );

    return response;
  }

  postWithToken(url, data) async {
    var token = await getToken();

    if (token == null) {
      return Future.error(APILocalMessage.no_token);
    }

    Future<Response> response = Dio().post(
      url,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
        },
        validateStatus: (status) => true,
      ),
      queryParameters: {"api_token": token},
      data: data,
    );

    return response;
  }

  post(url, data) async {
    var response = Dio().post(
      url,
      options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
          headers: {
            Headers.acceptHeader: Headers.jsonContentType,
            Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
          }),
      data: data,
    );

    return response;
  }

  get(url) async {
    Future<Response> response = Dio().get(
      url,
      options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
          headers: {
            Headers.acceptHeader: Headers.jsonContentType,
          }),
    );

    return response;
  }

  validateError(Map validateErrors) {
    String errors = validateErrors["data"]
        .keys
        .map((e) {
          if (e == null) {
            return null;
          }

          var messages = validateErrors["data"][e].join("\n");

          return messages;
        })
        .toList()
        .join("\n");

    return APIError(
        type: APIErrorType.validate,
        localMessage: APILocalMessage.validates,
        serverMessage: errors,
        serverCode: 200,
        localCode: 115);
  }

  falseSuccessError(responseJson) {
    var message = responseJson.containsKey("data")
        ? responseJson["data"]
        : (responseJson.containsKey("message")
            ? responseJson["message"]
            : "UNKNOWN_ERROR");
    return APIError(
        type: APIErrorType.falseSuccess,
        serverMessage: message,
        serverCode: 200,
        localMessage: APILocalMessage.unknown,
        localCode: 101);
  }

  noSuccessError(responseJson) {
    var message = responseJson.containsKey("data")
        ? responseJson["data"]
        : (responseJson.containsKey("message")
            ? responseJson["message"]
            : "UNKNOWN_ERROR");
    return APIError(
        type: APIErrorType.noSuccess,
        serverMessage: message,
        serverCode: 200,
        localMessage: APILocalMessage.unknown,
        localCode: 102);
  }

  statusCodeError(Response response) {
    Map data = response.data;
    switch (response.statusCode) {
      case 404:
        // not found
        return APIError(
            type: APIErrorType.statueCode,
            serverCode: 404,
            localMessage: APILocalMessage.not_found,
            localCode: 103);
      case 500:
        // server error
        var message = data.containsKey("data")
            ? data["data"]
            : (data.containsKey("message") ? data["message"] : "UNKNOWN_ERROR");
        return APIError(
            type: APIErrorType.statueCode,
            serverCode: 500,
            localMessage: APILocalMessage.internal_server_error,
            localCode: 104);
      case 401:
        // unauth error
        return APIError(
            type: APIErrorType.statueCode,
            serverCode: 401,
            localMessage: APILocalMessage.need_auth,
            localCode: 105);
      default:
        print(response);
        var message = data.containsKey("data")
            ? data["data"]
            : (data.containsKey("message") ? data["message"] : "UNKNOWN_ERROR");
        return APIError(
            type: APIErrorType.statueCode,
            serverCode: response.statusCode,
            localMessage: APILocalMessage.unknown,
            serverMessage: message,
            localCode: 106);
    }
  }

  exceptionError(e) {
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          return APIError(
              type: APIErrorType.exception,
              localMessage: APILocalMessage.connect_timeout,
              localCode: 107);
        case DioErrorType.sendTimeout:
          return APIError(
              type: APIErrorType.exception,
              localMessage: APILocalMessage.send_timeout,
              localCode: 108);
        case DioErrorType.receiveTimeout:
          return APIError(
              type: APIErrorType.exception,
              localMessage: APILocalMessage.receive_timeout,
              localCode: 109);
        case DioErrorType.response:
          return APIError(
              type: APIErrorType.exception,
              localMessage: APILocalMessage.server_status_error,
              localCode: 110);
        case DioErrorType.cancel:
          return APIError(
              type: APIErrorType.exception,
              localMessage: APILocalMessage.request_canceled,
              localCode: 111);
        case DioErrorType.other:
        default:
          return APIError(
              type: APIErrorType.exception,
              localMessage: APILocalMessage.unable_to_connect,
              localCode: 112);
      }
    } else if (e is APILocalMessage) {
      if (e == APILocalMessage.no_token) {
        return APIError(
            type: APIErrorType.exception,
            localMessage: APILocalMessage.no_token,
            localCode: 113);
      }
    } else {
      return APIError(
          type: APIErrorType.exception,
          localMessage: APILocalMessage.unknown,
          serverMessage: e.toString(),
          localCode: 114);
    }
  }
}
