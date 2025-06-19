import 'package:flutter/material.dart';
import 'package:moovie/models/movie_model.dart';
import 'package:moovie/services/movie_service.dart';
import 'package:moovie/pages/movie_detail_page.dart';

class FilteredResultPage extends StatefulWidget {
  final int genreId;
  final String title;

  const FilteredResultPage({super.key, required this.genreId, required this.title});

  @override
  State<FilteredResultPage> createState() => _FilteredResultPageState();
}

class _FilteredResultPageState extends State<FilteredResultPage> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieService().getMoviesByGenre(widget.genreId);
  }

  void _navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load movies', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
          }

          final movies = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => _navigateToDetail(movie),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.fullPosterUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}