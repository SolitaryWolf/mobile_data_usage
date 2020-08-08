import 'package:dio/dio.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_request.dart';
import 'package:mobile_data_usage/services/base/base_remote_source.dart';
import 'package:mobile_data_usage/services/mobile_data_usage/mobile_data_usage_local_source.dart';
import 'package:mobile_data_usage/utils/app_cache.dart';

abstract class MobileDataUsageRemoteSource {
  Future<Response<dynamic>> getMobileDataUsage(MobileDataUsageRequest mobileDataUsageRequest);
}

class MobileDataUsageRemoteSourceImpl extends BaseRemoteSource
    implements MobileDataUsageRemoteSource {

  @override
  Future<Response<dynamic>> getMobileDataUsage(MobileDataUsageRequest mobileDataUsageRequest) async {
    return wrapE(() => dio.get<dynamic>(
      apiBaseUrl + '/datastore_search',
      queryParameters: mobileDataUsageRequest.toJson(),
      options: MobileDataUsageLocalSource.isCacheEnable ? DioCacheUtil.getBuildCacheOption() : null
    ));
  }
}
