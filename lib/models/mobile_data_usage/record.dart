class Record {
  String volumeOfMobileData;
  double volumeOfMobileDataInDouble;
  String quarter;
  int id;
  int year;

//  Record({
//    this.volumeOfMobileData,
//    this.quarter,
//    this.id,
//  });

  Record(String volumeOfMobileData, String quarter, int id) {
    this.volumeOfMobileData = volumeOfMobileData;
    this.quarter = quarter;
    this.id = id;
    this.volumeOfMobileDataInDouble = double.tryParse(this.volumeOfMobileData);
  }

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        json["volume_of_mobile_data"],
        json["quarter"],
        json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "volume_of_mobile_data": volumeOfMobileData,
        "quarter": quarter,
        "_id": id,
      };
}
