import 'package:cinemapedia/presentations/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../views/views.dart';

class HomeScreen extends StatelessWidget {
  final int pageIndex;
  static const String name = "home-screen";
  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottonNavigation(
        currentIndex: pageIndex,
      ),
    );
  }
}
