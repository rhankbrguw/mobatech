class Branch {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String gmapsLink;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.gmapsLink,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['ID'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      gmapsLink: json['gmaps_link'] ?? '',
    );
  }
}
