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

  // Create a Todo object from the database (e.g., from a Map or SQL result)
  factory Todo.fromSqliteDatabase(Map<String, dynamic> data) {
    return Todo(
      id: data['id'], // Make sure this matches the column name in the database
      title: data['title'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'] ??
          data['created_at'], // Handle the case where updatedAt may be null
    );
  }
}

