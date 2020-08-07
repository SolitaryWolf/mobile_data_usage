import 'package:dio/dio.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_request.dart';
import 'package:mobile_data_usage/services/mobile_data_usage/mobile_data_usage_repository.dart';

abstract class MobileDataUsageService {
  Future<Response<dynamic>> getMobileDataUsage(MobileDataUsageRequest mobileDataUsageRequest);
}

class MobileDataUsageServiceImpl implements MobileDataUsageService {
  final MobileDataUsageRepository mobileDataUsageRepository = MobileDataUsageRepositoryImpl();

  @override
  Future<Response<dynamic>> getMobileDataUsage(MobileDataUsageRequest mobileDataUsageRequest) async {
    return mobileDataUsageRepository.getMobileDataUsage(mobileDataUsageRequest);
  }
}