import 'package:dio/dio.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_request.dart';
import 'package:mobile_data_usage/services/mobile_data_usage/mobile_data_usage_remote_source.dart';

abstract class MobileDataUsageRepository {
  Future<Response<dynamic>> getMobileDataUsage(MobileDataUsageRequest mobileDataUsageRequest);
}

class MobileDataUsageRepositoryImpl
    implements MobileDataUsageRepository {
  final MobileDataUsageRemoteSource mobileDataUsageRemoteSource = MobileDataUsageRemoteSourceImpl();

  @override
  Future<Response<dynamic>> getMobileDataUsage(MobileDataUsageRequest mobileDataUsageRequest) async {
    return mobileDataUsageRemoteSource.getMobileDataUsage(mobileDataUsageRequest);
  }
}