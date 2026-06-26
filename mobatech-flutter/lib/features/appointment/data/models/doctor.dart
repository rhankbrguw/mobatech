class Doctor {
  final int id;
  final int? userId;
  final int? polyclinicId;
  final String? polyclinicName;
  final String name;
  final String specialization;
  final String contactInfo;
  final String description;
  final String imageUrl;
  final bool isActive;

  Doctor({
    required this.id,
    this.userId,
    this.polyclinicId,
    this.polyclinicName,
    required this.name,
    required this.specialization,
    required this.contactInfo,
    required this.description,
    required this.imageUrl,
    required this.isActive,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final poly = json['polyclinic'];
    String rawImageUrl = json['image_url'] ?? '';
    // Fix localhost URL for Android Emulator
    if (rawImageUrl.startsWith('http://127.0.0.1:8080')) {
      // We can't import dart:io easily without making this file UI-dependent, 
      // but replacing it universally for 10.0.2.2 won't hurt the emulator, 
      // or we can just import dart:io
      rawImageUrl = rawImageUrl.replaceAll('http://127.0.0.1:8080', 'http://10.0.2.2:8080');
    }

    return Doctor(
      id: json['ID'] ?? 0,
      userId: json['user_id'],
      polyclinicId: json['polyclinic_id'],
      polyclinicName: poly is Map<String, dynamic> ? poly['name'] : null,
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      contactInfo: json['contact_info'] ?? '',
      description: json['description'] ?? '',
      imageUrl: rawImageUrl,
      isActive: json['is_active'] ?? true,
    );
  }
}
