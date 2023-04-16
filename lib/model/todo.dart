import 'dart:convert';

class Todo {
  String title;
  bool completed;

  Todo({
    required this.title,
    this.completed = false,
  });

    static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
      };
}

// Helper method to convert a Todo object to a JSON string
String todoToJson(Todo todo) {
  final Map<String, dynamic> data = todo.toJson();
  return json.encode(data);
}

// Helper method to convert a JSON string to a Todo object
Todo todoFromJson(String jsonString) {
  final data = json.decode(jsonString);
  return Todo.fromJson(data);
}

