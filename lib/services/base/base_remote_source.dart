import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utils/app_config.dart';

class BaseRemoteSource {
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
      return await dioApi();
    } catch (error) {
      if (error is DioError && error.type == DioErrorType.RESPONSE) {
        final Response<dynamic> response = error.response;
        /// if you want by pass dio header error code to get response content
        /// just uncomment line below
        //return response;
        final String errorMessage =
            'Code ${response.statusCode} - ${response.statusMessage} ${response.data != null ? '\n' : ''} ${response.data}';
        throw DioError(
            request: error.request,
            response: error.response,
            type: error.type,
            error: errorMessage);
      }
      rethrow;
    }
  }
}
