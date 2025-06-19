import 'package:flutter/material.dart';
import 'package:moovie/models/movie_model.dart';
import 'package:moovie/theme/app_colors.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final Future<List<Movie>> moviesFuture;
  final void Function(Movie) onMovieTap;
  final VoidCallback? onTitleTap;

  const MovieSection({
    super.key,
    required this.title,
    required this.moviesFuture,
    required this.onMovieTap,
    this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final movies = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTitleTap,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.netflixRed,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () => onMovieTap(movie),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.fullPosterUrl,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
