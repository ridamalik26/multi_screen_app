class Course {
  final int id;
  final String title;
  final String body;

  Course({required this.id, required this.title, required this.body});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}