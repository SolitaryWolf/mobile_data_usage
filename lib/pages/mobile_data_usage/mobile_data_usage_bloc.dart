import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_request.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/mobile_data_usage_response.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/record.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/year_record.dart';
import 'package:mobile_data_usage/pages/base/base_bloc.dart';
import 'package:mobile_data_usage/services/mobile_data_usage/mobile_data_service.dart';
import 'package:mobile_data_usage/utils/app_common_util.dart';
import 'package:rxdart/rxdart.dart';

class MobileDataUsageBloc extends BaseBloc with NetworkUtil {
  final MobileDataUsageService mobileDataUsageService =
  MobileDataUsageServiceImpl();

  final BehaviorSubject<MobileDataUsageResponse> _bsMobileDataUsage =
  BehaviorSubject<MobileDataUsageResponse>();
  final BehaviorSubject<List<YearRecord>> _bsYearRecords =
  BehaviorSubject<List<YearRecord>>();

  BehaviorSubject<MobileDataUsageResponse> get bsMobileDataUsage =>
      _bsMobileDataUsage;

  BehaviorSubject<List<YearRecord>> get bsYearRecords => _bsYearRecords;

  /// Methods
  fetchMobileDataUsage() async {
    try {
      MobileDataUsageRequest request = MobileDataUsageRequest(
          resourceId: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 100);
      final Response<dynamic> response = await mobileDataUsageService
          .getMobileDataUsage(request)
          .timeout(const Duration(seconds: 30));
      final MobileDataUsageResponse mobileDataUsageResponse =
      MobileDataUsageResponse(response.data as Map<String, dynamic>);
      _bsMobileDataUsage.sink.add(mobileDataUsageResponse);
    } catch (error) {
      MobileDataUsageResponse res = MobileDataUsageResponse({'': ''});
      if (error is DioError) {
        res.setDioError(error);
      } else {
        res.setDioError(DioError(error: "Unknown error"));
      }
      _bsMobileDataUsage.sink.add(res);
    }
  }

  handleData(List<Record> records) async {
    if (records.length > 0) {
      List<YearRecord> yearRecords = [];

      // Get year from quarter
      for (var i = 0; i < records.length; i++) {
        var quarter = records[i].quarter;
        var arr = quarter.split('-');
        if (arr.length > 0) {
          records[i].year = int.tryParse(arr[0]);
        }
      }

      // Group by year
      var yearMap = records.fold<Map<int, List<Record>>>(
          {}, (yearMap, currentQuarter) {
        if (yearMap[currentQuarter.year] == null) {
          yearMap[currentQuarter.year] = [];
        }
        yearMap[currentQuarter.year].add(currentQuarter);
        return yearMap;
      });

      // Parse to list view model
      yearMap.forEach((key, value) {
        if (key >= 2008 && key <= 2018) {
          yearRecords.add(YearRecord(year: key, records: value));
        }
      });

      // Calculate total data usage and data decrease each quarter of a year
      for (var i = 0; i < yearRecords.length; i++) {
//        var totalDataUsageOfYearInDec = yearRecords[i].records.fold(
//            0, (t, e) => t + Decimal.parse(e.volumeOfMobileData));
        var hasDecrease = false;
        Decimal totalDataUsageOfYearInDec = Decimal.zero;

        int numOfQuarter = yearRecords[i].records.length;
        for (var j = 0; j < numOfQuarter; j++) {
          // For total data usage
          totalDataUsageOfYearInDec += Decimal.parse(yearRecords[i].records[j].volumeOfMobileData);

          // For capacity of decrease
          if (j < numOfQuarter - 1 && yearRecords[i].records[j].volumeOfMobileDataInDouble > yearRecords[i].records[j + 1].volumeOfMobileDataInDouble) {
            hasDecrease = true;
            yearRecords[i].decreaseDescription += "Volume data decrease from "
                + yearRecords[i].records[j].quarter + ': '
                + yearRecords[i].records[j].volumeOfMobileData
                + " to "
                + yearRecords[i].records[j + 1].quarter + ': '
                + yearRecords[i].records[j + 1].volumeOfMobileData
                +"\n";
          }
        }
        yearRecords[i].totalVolumeOfMobileDataInDec = totalDataUsageOfYearInDec;
        yearRecords[i].hasDataDecrease = hasDecrease;
      }

      //yearRecords.add(YearRecord(year: 2018, hasDataDecrease: false, records: [Record(volumeOfMobileData: '0.12', quarter: '1', id: 1), Record(volumeOfMobileData: '0.1', quarter: '2', id: 2)]));

      _bsYearRecords.sink.add(yearRecords);
    }
  }

  /// End Methods

  @override
  void dispose() {
    _bsMobileDataUsage.close();
    _bsYearRecords.close();
  }
}
