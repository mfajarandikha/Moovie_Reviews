import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moovie/models/movie_model.dart';
import 'package:moovie/services/movie_service.dart';
import 'package:moovie/pages/movie_detail_page.dart';

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

  Map<int, Movie> _movieCache = {}; // Movie cache map

  @override
  void initState() {
    super.initState();
    popularMoviesFuture = movieService.getPopularMovies();
    nowPlayingMoviesFuture = movieService.getNowPlayingMovies();
    topRatedMoviesFuture = movieService.getTopRatedMovies();

    movieService.getPopularMovies().then((movies) {
      movies.shuffle();
      setState(() {
        randomMovies = movies.take(4).toList();
      });
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
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
    if (!_movieCache.containsKey(movie.id)) {
      _movieCache[movie.id] = movie;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: _movieCache[movie.id]!),
      ),
    );
  }

  Widget _buildMovieSection(String title, Future<List<Movie>> moviesFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Movie>>(
            future: moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
              }

              final movies = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () => _navigateToDetail(movie),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 2 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 12, // Increased for better readability
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.2, // Line height for better spacing
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundMovie() {
    if (randomMovies.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = randomMovies[currentIndex];

    return GestureDetector(
      onTap: () => _navigateToDetail(movie),
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              'https://image.tmdb.org/t/p/w780${movie.backdropPath ?? movie.posterPath}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            child: SizedBox(
              width: 300,
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
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
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBackgroundMovie(),
            _buildMovieSection('Trending Now', popularMoviesFuture),
            _buildMovieSection('Now Playing', nowPlayingMoviesFuture),
            _buildMovieSection('Top Rated', topRatedMoviesFuture),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
