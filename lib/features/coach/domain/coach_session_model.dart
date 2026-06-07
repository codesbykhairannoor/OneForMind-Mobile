class CoachSession {
  final String id;
  final String title;
  final DateTime createdAt;

  CoachSession({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory CoachSession.fromJson(Map<String, dynamic> json) {
    return CoachSession(
      id: json['id'].toString(),
      title: json['title'] ?? 'New Session',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
