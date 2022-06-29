import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Como estamos trabajando con Null Safety puede que los argumentos no vengan, por lo tanto ponemos ?
    // Si no vienen los argunmentos (??), nos figura "no movie"
    final Movie movie = ModalRoute.of(context)!.settings.arguments
        as Movie; // No lo convierte, solo lo trata como una pelicula

    return Scaffold(
        // En vez de un appBar ponemos esto, es mas dinamico al momento de hacer Scroll
        // Resive unos slivers, que son los que tienen el comportamiento durante el scroll
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(movie),
        // Hay que agregar widgets que tengan algo de sliver, no pueden ser widgets comunes
        SliverList(
          delegate: SliverChildListDelegate([
            _PosterAndTitle(movie),
            _Overview(movie),
            CastingCards(movie.id),
          ]),
        ),
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      // Esto no se para que es, investigar
      floating: false,
      // Esto es para que nunca desaparezca cuando hacemos scroll
      pinned: true,
      // Esto es un titulo que se achica o agranda cuando movemos
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Si no ponemos esto aparece una separacion gris abajo del titulo
        titlePadding: EdgeInsets.all(0),
        // Recordemos que el title es un widget, por lo tanto podemos poner un container
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 20),
          child: Text(
            movie.title,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackDropPath),
          // Esto es para que el Fade In Image tome todo el ancho posible
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);
  @override
  Widget build(BuildContext context) {
    // creamos una variable random para no repetirla tantas veces a esta parte
    final textTheme = Theme.of(context).textTheme;
    // Esto define el ancho total
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                // Una imagen es mas grande que la otra y pueden haber fallas de renderizado cuando uno entra
                // Hay que poner el tama;o deseado asi no pasa esto
                height: 150,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              // Esto es para que se alineen al principio
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    SizedBox(width: 5),
                    Text('${movie.voteAverage}', style: textTheme.caption)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
