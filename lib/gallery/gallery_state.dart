import 'package:equatable/equatable.dart';

class GalleryState extends Equatable {
  final List<dynamic> books;
  final List<dynamic> videos;
  final List<dynamic> movies;

  const GalleryState({
    required this.books,
    required this.videos,
    required this.movies,
  });

  @override
  List<Object?> get props => [books, videos, movies];

  GalleryState copyWith({
    List<dynamic>? books,
    List<dynamic>? videos,
    List<dynamic>? movies,
  }) {
    return GalleryState(
      books: books ?? this.books,
      videos: videos ?? this.videos,
      movies: movies ?? this.movies,
    );
  }

  factory GalleryState.initial() {
    return const GalleryState(books: [], videos: [], movies: []);
  }
}
