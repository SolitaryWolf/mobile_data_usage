import 'package:decimal/decimal.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/record.dart';

class YearRecord {
  int year;
  bool hasDataDecrease;
  List<Record> records;
  double totalVolumeOfMobileData;
  String decreaseDescription = "";
  Decimal totalVolumeOfMobileDataInDec;

  YearRecord({
    this.year,
    this.records,
  });
}