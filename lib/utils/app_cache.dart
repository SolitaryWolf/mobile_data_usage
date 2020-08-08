import 'package:dio_http_cache/dio_http_cache.dart';

class DioCacheUtil {
  static getBuildCacheOption() {
    return buildCacheOptions(
      Duration(days: 0),
      maxStale: Duration(days: 5),
      forceRefresh: true,
    );
  }

  static getCacheConfig() {
    return CacheConfig(databaseName: "MobileDataUsageCache");
  }
}
