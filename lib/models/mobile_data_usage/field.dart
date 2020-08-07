class Field {
  Field({
    this.type,
    this.id,
  });

  String type;
  String id;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}
