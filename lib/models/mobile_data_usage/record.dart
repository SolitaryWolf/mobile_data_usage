class Record {
  Record({
    this.volumeOfMobileData,
    this.quarter,
    this.id,
  });

  String volumeOfMobileData;
  String quarter;
  int id;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        volumeOfMobileData: json["volume_of_mobile_data"],
        quarter: json["quarter"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "volume_of_mobile_data": volumeOfMobileData,
        "quarter": quarter,
        "_id": id,
      };
}
