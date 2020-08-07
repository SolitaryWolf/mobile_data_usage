class MobileDataUsageRequest {
  String resourceId;
  int limit;

  MobileDataUsageRequest({this.resourceId, this.limit});

  factory MobileDataUsageRequest.fromJson(Map<String, dynamic> json) =>
      MobileDataUsageRequest(
          resourceId: json["resource_id"],
          limit: json["limit"]);

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "resource_id": resourceId,
      };
}
