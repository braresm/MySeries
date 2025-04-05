import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadMoviesByMood extends MovieEvent {
  final String mood;

  const LoadMoviesByMood(this.mood);

  @override
  List<Object> get props => [mood];
} 