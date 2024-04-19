import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if (query.isEmpty) return debounceMovies.add([]);
      final movies = await searchMovies(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debounceMovies.close();
    isLoadingStream.close();
  }

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  @override
  String? get searchFieldLabel => 'Buscar películas';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            return isLoading
                ? SpinPerfect(
                    duration: const Duration(seconds: 20),
                    spins: 10,
                    infinite: true,
                    child: IconButton(
                        onPressed: () => query = '',
                        icon: const Icon(Icons.refresh_rounded)))
                : FadeIn(
                    animate: query.isNotEmpty,
                    child: IconButton(
                        onPressed: () => query = '',
                        icon: const Icon(Icons.clear)));
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
        initialData: initialMovies,
        stream: debounceMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: _MovieItem(
                      movie: movie,
                      onMovieSelected: (context, movie) {
                        clearStreams();
                        close(context, movie);
                      }),
                  onTap: () => close(context, movie),
                );
              });
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
                  const SizedBox(height: 5),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...',
                          style: textStyles.bodySmall)
                      : Text(movie.overview, style: textStyles.bodySmall),
                  Row(
                    children: [
                      const Icon(Icons.star_half_rounded, color: Colors.amber),
                      Text(
                          HumanFormats.number(movie.voteAverage,
                              decimalDigits: 1),
                          style: textStyles.bodySmall!
                              .copyWith(color: Colors.yellow.shade800))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
