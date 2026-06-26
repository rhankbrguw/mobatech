class Prescription {
  final int id;
  final int userId;
  final String imageUrl;
  final String notes;
  final String status;
  final DateTime createdAt;

  Prescription({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    String rawImageUrl = json['image_url'] as String? ?? '';
    if (rawImageUrl.startsWith('http://127.0.0.1:8080')) {
      rawImageUrl = rawImageUrl.replaceAll('http://127.0.0.1:8080', 'http://10.0.2.2:8080');
    }

    return Prescription(
      id: json['ID'] ?? json['id'] as int,
      userId: json['user_id'] as int? ?? 0,
      imageUrl: rawImageUrl,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      createdAt: json['CreatedAt'] != null 
          ? DateTime.parse(json['CreatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'notes': notes,
      'status': status,
      'CreatedAt': createdAt.toIso8601String(),
    };
  }
}
