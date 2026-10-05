class Note {
  const Note({this.id, required this.content, this.createdAt});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id']?.toString(),
    content: (json['content'] ?? '').toString(),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.tryParse(json['created_at'].toString()),
  );

  final String? id;
  final String content;
  final DateTime? createdAt;
}
