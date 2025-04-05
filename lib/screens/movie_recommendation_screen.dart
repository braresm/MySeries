import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_event.dart';
import '../blocs/movie/movie_state.dart';
import '../models/movie.dart';
import '../services/genre_service.dart';

class MovieRecommendationScreen extends StatefulWidget {
  final String selectedMood;

  const MovieRecommendationScreen({
    super.key,
    required this.selectedMood,
  });

  @override
  State<MovieRecommendationScreen> createState() => _MovieRecommendationScreenState();
}

class _MovieRecommendationScreenState extends State<MovieRecommendationScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieInitial) {
            context.read<MovieBloc>().add(LoadMoviesByMood(widget.selectedMood));
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieError) {
            return Center(child: Text(state.message));
          }

          if (state is MovieLoaded && state.movies.isNotEmpty) {
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return _MovieDetails(
                      movie: movie,
                      selectedMood: widget.selectedMood,
                    );
                  },
                ),
                // Page indicators
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.movies.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.deepPurple
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No movies found'));
        },
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final String selectedMood;

  const _MovieDetails({
    required this.movie,
    required this.selectedMood,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/Logo.png',
                  height: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style: TextStyle(
                  color: Colors.deepPurple[200],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 2/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _PlatformButton(
                    icon: Icons.play_circle_filled,
                    text: 'Watch now:',
                    onTap: () {
                      // TODO: Implement watch action
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement trailer action
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurple[200]!.withOpacity(0.2),
                    ),
                    child: const Text(
                      'Trailer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Released',
                        style: TextStyle(
                          color: Colors.deepPurple[200],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        movie.releaseDate.split('-')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rating',
                        style: TextStyle(
                          color: Colors.deepPurple[200],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${movie.rating}/10',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Genres',
                style: TextStyle(
                  color: Colors.deepPurple[200],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: movie.categories.map((genreId) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200]!.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      GenreService.getGenreName(genreId),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Moods',
                style: TextStyle(
                  color: Colors.deepPurple[200],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[200]!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/$selectedMood.png',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedMood,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(
                  color: Colors.deepPurple[200],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                movie.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40), // Extra padding for page indicators
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _PlatformButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
} 