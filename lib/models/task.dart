class Task {
  final String id;
  String title;
  bool isDone;
  DateTime date;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.date,
  });
}
