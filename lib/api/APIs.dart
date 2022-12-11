import 'package:dio/dio.dart';
import 'package:techoffice/api/APIError.dart';
import 'package:techoffice/api/APIMixin.dart';
import 'package:techoffice/api/APIResponse.dart';

class APIs extends APIMixin {
  Future<APIResponse> getData(url, {token: false}) async {
    APIResponse apiResponse = APIResponse();

    try {
      Response response = token ? await getWithToken(url) : await get(url);

      if (response == null) {
        apiResponse.error = APIError(
            type: APIErrorType.nullResponse,
            localMessage: APILocalMessage.unknown,
            localCode: 116);

        return apiResponse;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            apiResponse.data = responseJson["data"];
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            apiResponse.error = validateError(responseJson);
          } else {
            apiResponse.error = falseSuccessError(responseJson);
          }
        } else {
          apiResponse.error = noSuccessError(responseJson);
        }
      } else {
        apiResponse.error = statusCodeError(response);
      }
    } catch (e) {
      apiResponse.error = exceptionError(e);
    }

    return apiResponse;
  }

  Future<APIResponse> postData(url, {data: const {}, token: false}) async {
    APIResponse apiResponse = APIResponse();
    try {
      var response =
          token ? await postWithToken(url, data) : await post(url, data);

      if (response == null) {
        apiResponse.error = APIError(
            type: APIErrorType.nullResponse,
            localMessage: APILocalMessage.unknown,
            localCode: 117);

        return apiResponse;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            apiResponse.data = responseJson["data"];
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            apiResponse.error = validateError(responseJson);
          } else {
            apiResponse.error = falseSuccessError(responseJson);
          }
        } else {
          apiResponse.error = noSuccessError(responseJson);
        }
      } else {
        apiResponse.error = statusCodeError(response);
      }
    } catch (e) {
      apiResponse.error = exceptionError(e);
    }

    return apiResponse;
  }
}
