class Todo {
  final int id;
  final String title;
  final int createdAt;
  final int updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromSqliteDatabase(Map<String, dynamic> data) {
    return Todo(
      id: data['id'], 
      title: data['title'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'] ??
          data['created_at'], 
    );
  }
}

