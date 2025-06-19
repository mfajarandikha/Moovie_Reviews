import 'package:flutter/material.dart';
import 'package:moovie/models/movie_model.dart';
import 'package:hive/hive.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    final box = await Hive.openBox<Movie>('favorites');
    final exists = box.values.any((m) => m.id == widget.movie.id);
    setState(() {
      isFavorite = exists;
    });
  }

  void toggleFavorite() async {
    final box = await Hive.openBox<Movie>('favorites');
    if (isFavorite) {
      final keyToRemove =
      box.keys.firstWhere((key) => box.get(key)!.id == widget.movie.id);
      await box.delete(keyToRemove);
    } else {
      await box.add(widget.movie);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  movie.fullBackdropUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                        Colors.black.withOpacity(0.8)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      movie.fullPosterUrl,
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Release: ${movie.releaseDate}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Language: ${movie.originalLanguage.toUpperCase()}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${movie.voteAverage}',
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${movie.voteCount} votes)',
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
