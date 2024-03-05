import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repository/movie_repository_impl.dart';

// este repositoroio es inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImp(MovieDBDataSource());
});
