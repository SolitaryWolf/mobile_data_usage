import 'package:dio/dio.dart';
import 'package:mobile_data_usage/models/base/base_response.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_request.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_response.dart';
import 'package:mobile_data_usage/pages/base/base_bloc.dart';
import 'package:mobile_data_usage/services/mobile_data_usage/mobile_data_service.dart';
import 'package:mobile_data_usage/utils/app_common_util.dart';
import 'package:rxdart/rxdart.dart';

class MobileDataUsageBloc extends BaseBloc with NetworkUtil {
  final MobileDataUsageService mobileDataUsageService = MobileDataUsageServiceImpl();

  final BehaviorSubject<MobileDataUsageResponse> _bsMobileDataUsage =
      BehaviorSubject<MobileDataUsageResponse>();
  final BehaviorSubject<String> _bsDioErrorMessage =
  BehaviorSubject<String>();

  BehaviorSubject<MobileDataUsageResponse> get bsMobileDataUsage => _bsMobileDataUsage;
  BehaviorSubject<String> get bsDioErrorMessage => _bsDioErrorMessage;

  fetchMobileDataUsage() async {
    try {
      MobileDataUsageRequest request = MobileDataUsageRequest(resourceId: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 100);
      final Response<dynamic> response =
      await mobileDataUsageService.getMobileDataUsage(request).timeout(const Duration(seconds: 30));
      final MobileDataUsageResponse mobileDataUsageResponse =
      MobileDataUsageResponse(response.data as Map<String, dynamic>);
      _bsMobileDataUsage.sink.add(mobileDataUsageResponse);

    } catch (error) {
      MobileDataUsageResponse res = MobileDataUsageResponse({'': ''});
      if (error is DioError && (error.type == DioErrorType.RESPONSE || error.type == DioErrorType.DEFAULT)) {
        res.setDioError(error);
      } else {
        res.setDioError(DioError(error: "Unknown error"));
      }
      _bsMobileDataUsage.sink.add(res);
    }
  }

  @override
  void dispose() {
    _bsMobileDataUsage.close();
  }


}
