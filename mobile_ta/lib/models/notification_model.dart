class NotificationModel {
  final String title;
  final String body;
  final DateTime sentAt;

  NotificationModel({
    required this.title,
    required this.body,
    required this.sentAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      sentAt: DateTime.parse(json['sent_at']),
    );
  }
}
