class Todo {
  String id;
  String name;
  DateTime? deadline;
  bool isDone;
  Todo({
    required this.id,
    required this.name,
    this.deadline,
    required this.isDone,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        name: json["name"],
        deadline: json["deadline"] != null
            ? DateTime.fromMillisecondsSinceEpoch(json["deadline"])
            : null,
        isDone: json["isDone"],
      );

  Map<String, dynamic> toJson(Todo todo) => {
        "id": id,
        "name": name,
        "deadline": deadline != null ? deadline!.millisecondsSinceEpoch : null,
        "isDone": isDone,
      };
}
