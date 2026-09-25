typedef Article = ForYouArticle;

class ForYouArticle {
  final String id;
  final String title;
  final String category;
  final String readTime;
  final String content;
  final String tag;
  final String actionText;
  final String actionRoute;
  final String? doctorName;
  final String? polyName;
  final int likesCount;
  final bool isLiked;
  final bool isBookmarked;

  const ForYouArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.content,
    this.tag = 'Berdasarkan Chat Terakhir Anda',
    this.actionText = 'Konsultasi Dokter Terkait',
    this.actionRoute = '/doctors',
    this.doctorName,
    this.polyName,
    this.likesCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  factory ForYouArticle.fromJson(Map<String, dynamic> json) {
    return ForYouArticle(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Kesehatan',
      readTime: json['readTime']?.toString() ?? '3 min',
      content: json['content']?.toString() ?? '',
      tag: json['tag']?.toString() ?? 'Berdasarkan Chat Terakhir Anda',
      actionText: json['actionText']?.toString() ?? 'Konsultasi Dokter Terkait',
      actionRoute: json['actionRoute']?.toString() ?? '/doctors',
      doctorName: json['doctorName']?.toString(),
      polyName: json['polyName']?.toString(),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] == true,
      isBookmarked: json['isBookmarked'] == true,
    );
  }

  ForYouArticle copyWith({
    String? id,
    String? title,
    String? category,
    String? readTime,
    String? content,
    String? tag,
    String? actionText,
    String? actionRoute,
    String? doctorName,
    String? polyName,
    int? likesCount,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return ForYouArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      readTime: readTime ?? this.readTime,
      content: content ?? this.content,
      tag: tag ?? this.tag,
      actionText: actionText ?? this.actionText,
      actionRoute: actionRoute ?? this.actionRoute,
      doctorName: doctorName ?? this.doctorName,
      polyName: polyName ?? this.polyName,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
