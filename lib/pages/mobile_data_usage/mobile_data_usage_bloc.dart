import 'package:dio/dio.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_request.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_response.dart';
import 'package:mobile_data_usage/pages/base/base_bloc.dart';
import 'package:mobile_data_usage/services/mobile_data_usage/mobile_data_service.dart';
import 'package:rxdart/rxdart.dart';

class MobileDataUsageBloc extends BaseBloc {
  final MobileDataUsageService mobileDataUsageService = MobileDataUsageServiceImpl();

  final BehaviorSubject<MobileDataUsageResponse> _bsMobileDataUsage =
      BehaviorSubject<MobileDataUsageResponse>();

  BehaviorSubject<MobileDataUsageResponse> get bsMobileDataUsage => _bsMobileDataUsage;

  fetchMobileDataUsage() async {
    try {
      MobileDataUsageRequest request = MobileDataUsageRequest(resourceId: "a807b7ab-6cad-4aa6-87d0-e283a7353a0fq", limit: 100);
      final Response<dynamic> response =
      await mobileDataUsageService.getMobileDataUsage(request).timeout(const Duration(seconds: 30));
      final MobileDataUsageResponse mobileDataUsageResponse =
      MobileDataUsageResponse(response.data as Map<String, dynamic>);
      _bsMobileDataUsage.sink.add(mobileDataUsageResponse);

    } catch (error) {
      if (error is DioError && error.type == DioErrorType.RESPONSE) {
        //MobileDataUsageResponse res = MobileDataUsageResponse()
        print(error.message);
      }
    }
  }

  @override
  void dispose() {
    _bsMobileDataUsage.close();
  }


}
