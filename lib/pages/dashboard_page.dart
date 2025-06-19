import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moovie/models/movie_model.dart';
import 'package:moovie/services/movie_service.dart';
import 'package:moovie/pages/movie_detail_page.dart';
import 'package:moovie/widgets/background_movie.dart';
import 'package:moovie/widgets/movie_section.dart';
import 'filtered_result_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final MovieService movieService = MovieService();

  late Future<List<Movie>> popularMoviesFuture;
  late Future<List<Movie>> nowPlayingMoviesFuture;
  late Future<List<Movie>> topRatedMoviesFuture;

  List<Movie> randomMovies = [];
  int currentIndex = 0;
  Timer? _timer;

  final Map<int, Movie> _movieCache = {};

  @override
  void initState() {
    super.initState();

    popularMoviesFuture = movieService.getPopularMovies();
    nowPlayingMoviesFuture = movieService.getNowPlayingMovies();
    topRatedMoviesFuture = movieService.getTopRatedMovies();

    popularMoviesFuture.then((movies) {
      if (movies.isNotEmpty) {
        movies.shuffle();
        setState(() {
          randomMovies = movies.take(4).toList();
        });
        _startAutoScroll();
      }
    });
  }

  void _startAutoScroll() {
    if (randomMovies.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % randomMovies.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToDetail(Movie movie) {
    _movieCache.putIfAbsent(movie.id, () => movie);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: _movieCache[movie.id]!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/images/logo.png',
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.movie_filter_outlined, color: Colors.white),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BackgroundMovie(
              movie: randomMovies.isNotEmpty ? randomMovies[currentIndex] : null,
              onTap: _navigateToDetail,
            ),
            MovieSection(
              title: 'Trending',
              moviesFuture: popularMoviesFuture,
              onMovieTap: _navigateToDetail,
              onTitleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FilteredResultPage(
                      title: 'Trending',
                      category: MovieCategory.popular, // or however you define it
                    ),
                  ),
                );
              },
            ),
            MovieSection(
              title: 'Now Playing',
              moviesFuture: nowPlayingMoviesFuture,
              onMovieTap: _navigateToDetail,
              onTitleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FilteredResultPage(
                      title: 'Now Playing',
                      category: MovieCategory.nowPlaying, // or however you define it
                    ),
                  ),
                );
              },
            ),
            MovieSection(
              title: 'Top Rated',
              moviesFuture: topRatedMoviesFuture,
              onMovieTap: _navigateToDetail,
              onTitleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FilteredResultPage(
                      title: 'Top Rated',
                      category: MovieCategory.topRated, // or however you define it
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
