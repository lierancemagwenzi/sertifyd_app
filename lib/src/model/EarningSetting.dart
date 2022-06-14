class EarningSetting{
  int id;
  num admin_percentage;


  EarningSetting({this.id, this.admin_percentage});

  factory  EarningSetting.fromJson(Map<String, dynamic> json) {
    return     EarningSetting(
      id: json["id"],
      admin_percentage: json['admin_percentage'],
    );
  }

  num getPercentage(){

    if(admin_percentage==null){

      return 0;
    }

    return (admin_percentage/100);
  }

}