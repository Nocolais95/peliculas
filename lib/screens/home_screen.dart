import 'package:flutter/material.dart';

import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hay que especificarle cual provider tiene que buscar --> <>
    // Basicamente, va al arbol de widgets y trae la primera instancia que encuentre en MoviesProvider
    // Si no encuentra la crea, siempre y cuando en el multiprovider tengamos definido ese provider
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Peliculas en cine'),
          ),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () => showSearch(
                      context: context,
                      // El delegate es un widget que tiene ciertas condiciones
                      delegate: MovieSearchDelegate(),
                    ))
          ],
        ),
        body: SingleChildScrollView(
          // El single child scrollview permite simplemente hacer scroll,
          // si no estuviera, la pantalla queda estatica y un widget abajo podria cortarse
          child: Column(
            children: [
              // Tarjetas principales
              // Le mandamos el moviesProvider.onDisplayMovie
              CardSwiper(
                movies: moviesProvider.onDisplayMovies,
              ),

              // Listado horizontal de peliculas
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: 'Populares',
                onNextPage: () => moviesProvider.getPopularMovies(), // opcional
              ),
            ],
          ),
        ));
  }
}
