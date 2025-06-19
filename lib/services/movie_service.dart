import 'package:http/http.dart' as http;
import 'package:moovie/models/movie_model.dart';

class MovieService {
  final String _baseUrl = 'api.themoviedb.org';
  final String _accessToken = 'API_TOKEN';
  final Duration _cacheDuration = const Duration(hours: 1);

  List<Movie>? _cachedPopularMovies;
  DateTime? _lastPopularFetch;

  List<Movie>? _cachedNowPlayingMovies;
  DateTime? _lastNowPlayingFetch;

  List<Movie>? _cachedTopRatedMovies;
  DateTime? _lastTopRatedFetch;

  Future<List<Movie>> getPopularMovies() async {
    if (_isCacheValid(_cachedPopularMovies, _lastPopularFetch)) {
      print('Returning popular movies from cache');
      return _cachedPopularMovies!;
    }

    print('Fetching popular movies from API');
    final url = Uri.https(_baseUrl, '/3/discover/movie', {
      'include_adult': 'false',
      'include_video': 'false',
      'language': 'en-US',
      'page': '1',
      'sort_by': 'popularity.desc',
    });

    return _fetchMovies(
      url,
      cacheSetter: (movies) {
        _cachedPopularMovies = movies;
        _lastPopularFetch = DateTime.now();
      },
    );
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    if (_isCacheValid(_cachedNowPlayingMovies, _lastNowPlayingFetch)) {
      print('Returning now playing movies from cache');
      return _cachedNowPlayingMovies!;
    }

    print('Fetching now playing movies from API');
    final url = Uri.https(_baseUrl, '/3/movie/now_playing', {
      'language': 'en-US',
      'page': '1',
    });

    return _fetchMovies(
      url,
      cacheSetter: (movies) {
        _cachedNowPlayingMovies = movies;
        _lastNowPlayingFetch = DateTime.now();
      },
    );
  }

  Future<List<Movie>> getTopRatedMovies() async {
    if (_isCacheValid(_cachedTopRatedMovies, _lastTopRatedFetch)) {
      print('Returning top rated movies from cache');
      return _cachedTopRatedMovies!;
    }

    print('Fetching top rated movies from API');
    final url = Uri.https(_baseUrl, '/3/movie/top_rated', {
      'language': 'en-US',
      'page': '1',
    });

    return _fetchMovies(
      url,
      cacheSetter: (movies) {
        _cachedTopRatedMovies = movies;
        _lastTopRatedFetch = DateTime.now();
      },
    );
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    print('Fetching movies by genre ID: $genreId');
    final url = Uri.https(_baseUrl, '/3/discover/movie', {
      'language': 'en-US',
      'page': '1',
      'with_genres': genreId.toString(),
    });

    return _fetchMovies(
      url,
      cacheSetter: (_) {},
    );
  }

  Future<List<Movie>> _fetchMovies(
      Uri url, {
        required void Function(List<Movie>) cacheSetter,
      }) async {
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final movieResponse = movieResponseFromJson(response.body);
        cacheSetter(movieResponse.results);
        return movieResponse.results;
      } else {
        print('API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to fetch movies (Status ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching movies: $e');
      throw Exception('Failed to fetch movies: $e');
    }
  }

  bool _isCacheValid(List<Movie>? cache, DateTime? timestamp) {
    return cache != null &&
        timestamp != null &&
        DateTime.now().difference(timestamp) < _cacheDuration;
  }
}
