import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_data_usage/utils/app_common_util.dart';

import '../../utils/app_config.dart';

class BaseRemoteSource with NetworkUtil {
  BaseRemoteSource() {
    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }
  }

  // Get base url by env
  final String apiBaseUrl = Config.instance.env.apiBaseUrl;
  final Dio dio = Dio();

  // Wrap Dio Exception
  Future<Response<dynamic>> wrapE(
      Future<Response<dynamic>> Function() dioApi) async {
    try {
      var isNetworkOk = await isNetworkConnectionOk();
      if (isNetworkOk) {
        return await dioApi();
      } else {
        throw DioError(error: 'Please check your internet connection!');
      }
    } catch (error) {
      if (error is DioError && error.type == DioErrorType.RESPONSE) {
        final Response<dynamic> response = error.response;

        /// if you want by pass dio header error code to get response content
        /// just uncomment line below
        //return response;
        final String errorMessage = '${response.data}';
        throw DioError(
            request: error.request,
            response: error.response,
            type: error.type,
            error: errorMessage);
      } else if (error.error != 'Please check your internet connection!') {
        throw DioError(error: 'Unknown error');
      }
      rethrow;
    }
  }
}
