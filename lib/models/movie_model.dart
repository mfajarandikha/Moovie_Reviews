import 'dart:convert';

MovieResponse movieResponseFromJson(String str) =>
    MovieResponse.fromJson(json.decode(str));

String movieResponseToJson(MovieResponse data) =>
    json.encode(data.toJson());

class MovieResponse {
  final int page;
  final List<Movie> results;

  MovieResponse({
    required this.page,
    required this.results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
    page: json["page"],
    results:
    List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Movie {
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;

  Movie({
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    backdropPath: json["backdrop_path"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    originalLanguage: json["original_language"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    releaseDate: json["release_date"],
    title: json["title"],
    voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "overview": overview,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "title": title,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  String get fullPosterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://placehold.co/200x300/303030/f5f5f1?text=No+Image';
  }

  String get fullBackdropUrl {
    if (backdropPath != null) {
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }
    return 'https://placehold.co/600x340/221f1f/E50914?text=No+Backdrop';
  }
}
