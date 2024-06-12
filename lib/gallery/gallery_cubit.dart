import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryState.initial());

  Future<void> fetchBooks() async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=sign%20language'));

    if (response.statusCode == 200) {
      final books = json.decode(response.body)['items'];
      emit(state.copyWith(books: books));
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> fetchVideos() async {
    const apiKey = 'AIzaSyCWLk9Z-W0Qp3aDZo_5Rk9i-WhU5vaJl44';
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=sign%20language&maxResults=15&key=$apiKey'));

    if (response.statusCode == 200) {
      final videos = json.decode(response.body)['items'];
      emit(state.copyWith(videos: videos));
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<void> fetchMovies() async {
    const apiKey = '37704a4f73816464227db09f4bb99bde';
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=sign%20language'));

    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      final moviesWithPosters =
          results.where((movie) => movie['poster_path'] != null).toList();
      emit(state.copyWith(movies: moviesWithPosters));
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
