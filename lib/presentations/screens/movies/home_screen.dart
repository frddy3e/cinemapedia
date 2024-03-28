import 'package:cinemapedia/presentations/providers/providers.dart';
import 'package:cinemapedia/presentations/widgets/movies/movie_horizontal_listview.dart';
import 'package:cinemapedia/presentations/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottonNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) {
      return const FullScreenLoader();
    }

    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppBar()),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                MoviesSlideShow(movies: slideShowMovies),
                MovieHorizontalListView(
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subTitle: 'asd',
                ),
                MovieHorizontalListView(
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                  movies: upcomingMovies,
                  title: 'Proximamente',
                  subTitle: 'En este mes',
                ),
                MovieHorizontalListView(
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                  movies: popularMovies,
                  title: 'Populares',
                  // subTitle: '',
                ),
                MovieHorizontalListView(
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                  },
                  movies: topRatedMovies,
                  title: 'Mejor calificados',
                  subTitle: 'De todos los tiempos',
                ),
                const SizedBox(height: 50)
              ],
            );
          },
          childCount: 1,
        ))
      ],
    );
  }
}
