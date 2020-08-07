class Link {
  Link({
    this.start,
    this.next,
  });

  String start;
  String next;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        start: json["start"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "next": next,
      };
}
