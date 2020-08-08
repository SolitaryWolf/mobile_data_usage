import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/record.dart';
import 'package:mobile_data_usage/pages/mobile_data_usage/mobile_data_usage_bloc.dart';

class MobileDataUsageMockData {
  getMockQuarterDataList() {
    var json =
        '{"records":[{"volume_of_mobile_data":"0.012635","quarter":"2007-Q1","_id":11},{"volume_of_mobile_data":"0.029992","quarter":"2007-Q2","_id":12},{"volume_of_mobile_data":"0.053584","quarter":"2007-Q3","_id":13},{"volume_of_mobile_data":"0.100934","quarter":"2007-Q4","_id":14},{"volume_of_mobile_data":"0.171586","quarter":"2008-Q1","_id":15},{"volume_of_mobile_data":"0.248899","quarter":"2008-Q2","_id":16},{"volume_of_mobile_data":"0.439655","quarter":"2008-Q3","_id":17},{"volume_of_mobile_data":"0.683579","quarter":"2008-Q4","_id":18},{"volume_of_mobile_data":"1.066517","quarter":"2009-Q1","_id":19},{"volume_of_mobile_data":"1.357248","quarter":"2009-Q2","_id":20},{"volume_of_mobile_data":"1.695704","quarter":"2009-Q3","_id":21},{"volume_of_mobile_data":"2.109516","quarter":"2009-Q4","_id":22},{"volume_of_mobile_data":"2.3363","quarter":"2010-Q1","_id":23},{"volume_of_mobile_data":"2.777817","quarter":"2010-Q2","_id":24},{"volume_of_mobile_data":"3.002091","quarter":"2010-Q3","_id":25},{"volume_of_mobile_data":"3.336984","quarter":"2010-Q4","_id":26},{"volume_of_mobile_data":"3.466228","quarter":"2011-Q1","_id":27},{"volume_of_mobile_data":"3.380723","quarter":"2011-Q2","_id":28},{"volume_of_mobile_data":"3.713792","quarter":"2011-Q3","_id":29},{"volume_of_mobile_data":"4.07796","quarter":"2011-Q4","_id":30}]}';
    //var recordsJson = jsonDecode(json)['records'];
    //List<Record> records = recordsJson != null ? List.from(recordsJson) : null;

    var recordsJson = jsonDecode(json)['records'] as List;
    List<Record> records = recordsJson.map((recordJson) => Record.fromJson(recordJson)).toList();

    return records;
  }
}

void main() {
  group('Given quarter record list from 2007 -> 2011', () {
    MobileDataUsageBloc testBloc = MobileDataUsageBloc();
    MobileDataUsageMockData mockData = MobileDataUsageMockData();

    test('Handle data correctly', () async {
      List<Record> records = mockData.getMockQuarterDataList();

      testBloc.handleData(records);
      var yearRecords = testBloc.yearRecords;

      expect(yearRecords[0].year, 2008);
      expect(yearRecords[0].totalVolumeOfMobileDataInDec, Decimal.parse('1.543719'));
      expect(yearRecords[0].hasDataDecrease, false);

      expect(yearRecords[1].year, 2009);
      expect(yearRecords[1].totalVolumeOfMobileDataInDec, Decimal.parse('6.228985'));
      expect(yearRecords[1].hasDataDecrease, false);

      expect(yearRecords[2].year, 2010);
      expect(yearRecords[2].totalVolumeOfMobileDataInDec, Decimal.parse('11.453192'));
      expect(yearRecords[2].hasDataDecrease, false);

      expect(yearRecords[3].year, 2011);
      expect(yearRecords[3].totalVolumeOfMobileDataInDec, Decimal.parse('14.638703'));
      expect(yearRecords[3].hasDataDecrease, true);

    });
  });
}
