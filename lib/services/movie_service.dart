import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'category_service.dart';

class MovieService {
  final String apiUrl = 'https://api.themoviedb.org/3';
  final String imageUrl = 'https://image.tmdb.org/t/p/w500';
  final String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNzQyMjA2NTM0ZWMyMGEzMjIzYmIwNGQxODA2NmYwNiIsInN1YiI6IjY0MjZmYWVkYTNlNGJhMDBmMjMzZGViNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.A7RGfC0iFj6thL6qaHpueCEtp8o2r7KuFy8flrcwGJQ'; // Replace with your TMDB API key
  final CategoryService categoryService = CategoryService();

  Future<List<Movie>> getMoviesByMood(String mood) async {
    final categories = categoryService.getCategoriesForMood(mood);
    final url = Uri.parse('$apiUrl/discover/movie').replace(queryParameters: {
      'with_genres': categories.join('|'),
      'vote_average.gte': '8',
      'page': '1',
      'sort_by': 'popularity.desc',
    });

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie, imageUrl))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
} 