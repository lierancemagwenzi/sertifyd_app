class ApplicationStatus{
  int id;
  String status;
  String admin_next;
  String client_next;

  String client;
String client_explanation;


  String admin_explanation;

  String admin;
bool can_chat;
  bool can_cancel;
  ApplicationStatus({this.id,this.status,this.admin_next,this.client_next,this.can_cancel,this.client,this.admin,this.can_chat,this.client_explanation,this.admin_explanation});
  factory ApplicationStatus.fromJson(Map<String, dynamic> json) {
    return ApplicationStatus(
      id: json["id"],
      status: json['status'],
      client: json['client'],

      client_explanation: json['client_explanation'],

      admin_explanation: json['admin_explanation'],
      admin: json['admin'],
      admin_next: json['admin_next'],
      client_next: json['client_next'],
      can_chat: json['can_chat'],
      can_cancel: json['can_cancel'],
    );
  }

}