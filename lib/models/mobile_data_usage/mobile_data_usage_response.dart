import 'package:mobile_data_usage/models/base/base_response.dart';
import 'package:mobile_data_usage/models/mobile_data_usage/link.dart';

import 'field.dart';
import 'record.dart';

class MobileDataUsage {
  MobileDataUsage({
    this.resourceId,
    this.fields,
    this.records,
    this.link,
    this.limit,
    this.total,
  });

  String resourceId;
  List<Field> fields;
  List<Record> records;
  Link link;
  int limit;
  int total;

  factory MobileDataUsage.fromJson(Map<String, dynamic> json) => MobileDataUsage(
    resourceId: json["resource_id"],
    fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
    records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
    link: Link.fromJson(json["_links"]),
    limit: json["limit"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
    "records": List<dynamic>.from(records.map((x) => x.toJson())),
    "_links": link.toJson(),
    "limit": limit,
    "total": total,
  };
}

class MobileDataUsageResponse extends BaseResponse<MobileDataUsage> {
  MobileDataUsageResponse(Map<String, dynamic> fullJson) : super(fullJson);

  @override
  Map<String, dynamic> dataToJson(MobileDataUsage data) {
    return data.toJson();
  }

  @override
  MobileDataUsage jsonToData(Map<String, dynamic> dataJson) {
    return MobileDataUsage.fromJson(dataJson);
  }
}
