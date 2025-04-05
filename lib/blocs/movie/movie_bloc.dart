import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/movie_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService _movieService;

  MovieBloc(this._movieService) : super(MovieInitial()) {
    on<LoadMoviesByMood>(_onLoadMoviesByMood);
  }

  Future<void> _onLoadMoviesByMood(
    LoadMoviesByMood event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    try {
      final movies = await _movieService.getMoviesByMood(event.mood);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
} 