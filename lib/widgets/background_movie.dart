import 'package:flutter/material.dart';
import 'package:moovie/models/movie_model.dart';

class BackgroundMovie extends StatelessWidget {
  final Movie? movie;
  final void Function(Movie) onTap;

  const BackgroundMovie({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final imageUrl = movie!.backdropPath != null
        ? 'https://image.tmdb.org/t/p/w780${movie!.backdropPath}'
        : (movie!.posterPath != null
        ? 'https://image.tmdb.org/t/p/w780${movie!.posterPath}'
        : null);

    return GestureDetector(
      onTap: () => onTap(movie!),
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 48),
            )
                : const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Text(
              movie!.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
