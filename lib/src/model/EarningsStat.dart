class EarningsStat{
  int month;
  String monthname;

  int year;

  EarningsStat({this.month, this.monthname,this.year});

  factory     EarningsStat.fromJson(Map<String, dynamic> json) {
    return     EarningsStat(
      month: json["month"],
      monthname: json['monthname'],
      year: json['year'],

    );
  }

}