import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';

// Para meter todos los directorios creamos un archivo con el mismo nombre de la carperta
// y lo importamos aca como uno solo
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

// Creamos un nuevo StatelessWidget para mantener el estado de la app
// Y sera el primero en ser llamado para que podamos tener acceso de entrada al movies provider
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          // Se agrega esto, que por defecto viene en verdadero, ya que queremos que se ejecute apenas inicializamos
          // la app, de lo contrario no lo hace, ya que espera a que algun widget la necesite para lanzarla
          lazy: false,
        ),
      ],
      // Aqui mismo llamamos My App
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',
      routes: {
        // Si no usamos el context podemos poner un _
        'home': (_) => HomeScreen(),
        'details': (_) => DetailsScreen(),
      },
      // Para crear o modificar las variaciones del AppBar
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
