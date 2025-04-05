class Movie {
  final String title;
  final String description;
  final String posterPath;
  final String releaseDate;
  final List<int> categories;
  final double rating;

  Movie({
    required this.title,
    required this.description,
    required this.posterPath,
    required this.releaseDate,
    required this.categories,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json, String imageBaseUrl) {
    return Movie(
      title: json['title'] ?? '',
      description: json['overview'] ?? '',
      posterPath: '$imageBaseUrl${json['poster_path']}',
      releaseDate: json['release_date'] ?? '',
      categories: List<int>.from(json['genre_ids'] ?? []),
      rating: (json['vote_average'] ?? 0.0).toDouble(),
    );
  }
} 