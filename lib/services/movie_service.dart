import 'package:http/http.dart' as http;
import 'package:moovie/models/movie_model.dart';

class MovieService {
  final String _baseUrl = 'api.themoviedb.org';
  final String _accessToken = ;

  final Duration _cacheDuration = const Duration(hours: 1);

  // Caches
  List<Movie>? _cachedPopularMovies;
  DateTime? _lastPopularFetch;

  List<Movie>? _cachedNowPlayingMovies;
  DateTime? _lastNowPlayingFetch;

  List<Movie>? _cachedTopRatedMovies;
  DateTime? _lastTopRatedFetch;

  /// Fetches popular movies (trending)
  Future<List<Movie>> getPopularMovies() async {
    if (_cachedPopularMovies != null &&
        _lastPopularFetch != null &&
        DateTime.now().difference(_lastPopularFetch!) < _cacheDuration) {
      print("Returning popular movies from cache");
      return _cachedPopularMovies!;
    }

    print("Fetching popular movies from API");
    final Uri url = Uri.https(_baseUrl, '/3/discover/movie', {
      'include_adult': 'false',
      'include_video': 'false',
      'language': 'en-US',
      'page': '1',
      'sort_by': 'popularity.desc',
    });

    return _fetchMovies(url, cacheSetter: (movies) {
      _cachedPopularMovies = movies;
      _lastPopularFetch = DateTime.now();
    });
  }

  /// Fetches now playing movies
  Future<List<Movie>> getNowPlayingMovies() async {
    if (_cachedNowPlayingMovies != null &&
        _lastNowPlayingFetch != null &&
        DateTime.now().difference(_lastNowPlayingFetch!) < _cacheDuration) {
      print("Returning now playing movies from cache");
      return _cachedNowPlayingMovies!;
    }

    print("Fetching now playing movies from API");
    final Uri url = Uri.https(_baseUrl, '/3/movie/now_playing', {
      'language': 'en-US',
      'page': '1',
    });

    return _fetchMovies(url, cacheSetter: (movies) {
      _cachedNowPlayingMovies = movies;
      _lastNowPlayingFetch = DateTime.now();
    });
  }

  /// Fetches top-rated movies
  Future<List<Movie>> getTopRatedMovies() async {
    if (_cachedTopRatedMovies != null &&
        _lastTopRatedFetch != null &&
        DateTime.now().difference(_lastTopRatedFetch!) < _cacheDuration) {
      print("Returning top rated movies from cache");
      return _cachedTopRatedMovies!;
    }

    print("Fetching top rated movies from API");
    final Uri url = Uri.https(_baseUrl, '/3/movie/top_rated', {
      'language': 'en-US',
      'page': '1',
    });

    return _fetchMovies(url, cacheSetter: (movies) {
      _cachedTopRatedMovies = movies;
      _lastTopRatedFetch = DateTime.now();
    });
  }


  Future<List<Movie>> _fetchMovies(Uri url,
      {required void Function(List<Movie>) cacheSetter}) async {
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
        print('API Response: ${response.body}');
        throw Exception('Failed to load movies (Status code: ${response.statusCode})');
      }
    } catch (e) {
      print('Network or parsing error: $e');
      throw Exception('Failed to load movies: $e');
    }
  }
}
