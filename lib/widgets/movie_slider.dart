import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';

// Primero fue un stateless pero lo convertimos a ful para modificar su estado y poder hacer el scroll horizontal
class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  // Creamos esta funcion para controlar lo que se manda en populares
  final Function onNextPage;
  const MovieSlider({
    Key? key,
    required this.movies,
    this.title,
    required this.onNextPage,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  // Esto nos permite crear un listener
  // Tiene que estar amarrado a algun widget que use un scroll, asique lo enviamos tambien al ListView
  final ScrollController scrollController = ScrollController();

  // Aca se crea el widget
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      // Tenemos que decirle que cuando llegue al final del scroll llame de nuevo al provider
      //y siga creando items, le restamos 500 asi llama antes de llegar al final
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  // Aca se destruye
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  this.widget.title!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              // Lo asociamos aca
              controller: scrollController,
              // Para poner en horizontal la direccion de las tarjetas
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) => _MoviePoster(
                widget.movies[index],
                '${widget.title}-$index-${widget.movies[index].id}',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;
  const _MoviePoster(this.movie, this.heroId);
  @override
  Widget build(BuildContext context) {
    // Hay que inventarse otro Id unico
    movie.heroId = heroId;
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            movie.title,
            // Esto es para los 3 puntitos
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
