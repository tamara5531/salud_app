import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para gestionar la autenticación de usuarios.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/carousel_slider.dart';
// Importa el archivo `carousel_slider.dart` del proyecto `medsal`, que probablemente contiene un carrusel de imágenes o contenido.

import 'package:medsal/firestore_data/notification_list.dart';
// Importa el archivo `notification_list.dart` del proyecto `medsal`, que probablemente contiene la lista de notificaciones.

import 'package:medsal/firestore_data/search_list.dart';
// Importa el archivo `search_list.dart` del proyecto `medsal`, que probablemente contiene la lista de resultados de búsqueda.

import 'package:medsal/firestore_data/top_rated_list.dart';
// Importa el archivo `top_rated_list.dart` del proyecto `medsal`, que probablemente contiene la lista de los más valorados.

import 'package:medsal/model/card_model.dart';
// Importa el archivo `card_model.dart` del proyecto `medsal`, que probablemente contiene el modelo de datos para las tarjetas.

import 'package:medsal/screens/explore_list.dart';
// Importa el archivo `explore_list.dart` del proyecto `medsal`, que probablemente contiene la lista de exploración.

import 'package:intl/intl.dart';
// Importa la biblioteca Intl para la internacionalización y el formato de fechas.

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // Define una clase `HomePage` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor `const` se utiliza para crear una instancia constante de esta clase.

  @override
  State<HomePage> createState() => _HomePageState();
  // Sobrescribe el método `createState` para devolver una instancia de `_HomePageState`, que manejará el estado de este widget.
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Define una clave global para identificar el scaffold y manejar su estado.

  TextEditingController _doctorName = TextEditingController();
  // Controlador para el campo de texto de búsqueda de doctores.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Instancia de `FirebaseAuth` para gestionar la autenticación de usuarios.

  User? user;
  // Variable para almacenar el usuario autenticado actualmente.

  Future<void> _getUser() async {
    user = _auth.currentUser;
    // Método asíncrono para obtener el usuario autenticado actualmente y almacenarlo en la variable `user`.
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _doctorName = TextEditingController();
    // Inicializa el controlador de texto para la búsqueda de doctores.
  }

  @override
  void dispose() {
    _doctorName.dispose();
    super.dispose();
    // Libera el controlador de texto cuando se destruye el widget.
  }

  @override
  Widget build(BuildContext context) {
    String message = "Good";
    DateTime now = DateTime.now();
    // Obtiene la fecha y hora actual.

    String currentHour = DateFormat('kk').format(now);
    // Formatea la hora actual en un formato de 24 horas.

    int hour = int.parse(currentHour);
    // Convierte la hora actual a un entero.

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          message = 'Buenos dias ';
        } else if (hour >= 12 && hour <= 17) {
          message = 'Buenas tardes';
        } else {
          message = 'Buenas noches';
        }
        // Define el mensaje de saludo según la hora del día.
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // Establece el color de fondo del scaffold a blanco.

      key: _scaffoldKey,
      // Utiliza la clave del scaffold definida anteriormente.

      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Evita que se muestre el botón de retroceso predeterminado.

        actions: <Widget>[Container()],
        // Lista de acciones para la AppBar.

        backgroundColor: Colors.white,
        // Establece el color de fondo de la AppBar a blanco.

        elevation: 0,
        // Establece la elevación de la AppBar a 0.

        title: Container(
          padding: const EdgeInsets.only(top: 5),
          // Añade un padding superior al contenedor del título.

          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            // Alinea el contenido de la fila al final horizontalmente.

            children: [
              Container(
                alignment: Alignment.center,
                // Alinea el contenido del contenedor al centro.

                child: Text(
                  message,
                  // Muestra el mensaje de saludo.

                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    // Aplica el estilo del texto usando la fuente Lato.
                  ),
                ),
              ),
              const SizedBox(
                width: 55,
                // Añade un espacio de 55 píxeles de ancho.
              ),
              IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.notifications_active),
                // Muestra el icono de notificaciones.

                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => const NotificationList()));
                  // Navega a la lista de notificaciones cuando se presiona el botón.
                },
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
          // Establece el color de los iconos de la AppBar a negro.
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            // Desactiva el indicador de overscroll.

            return true;
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            // Establece la física del desplazamiento para que no haya efecto de rebote.

            shrinkWrap: true,
            // Permite que el ListView se ajuste a su contenido.

            children: <Widget>[
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                    // Añade un espacio vertical de 30 píxeles.
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    // Alinea el contenido del contenedor al inicio horizontalmente.

                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    // Añade un padding izquierdo y inferior al contenedor.

                    child: Text(
                      "Hola ${user?.displayName}",
                      // Muestra un saludo con el nombre del usuario autenticado.

                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        // Aplica el estilo del texto usando la fuente Lato.
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, bottom: 25),
                    child: Text(
                      "Busquemos a tu profesional",
                      // Muestra el mensaje "Busquemos a tu profesional".

                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        // Aplica el estilo del texto usando la fuente Lato.
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      // Capitaliza cada palabra introducida en el campo de texto.

                      textInputAction: TextInputAction.search,
                      // Cambia la acción del teclado a "buscar".

                      controller: _doctorName,
                      // Asigna el controlador de texto para la búsqueda de doctores.

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        // Añade un padding al contenido del campo de texto.

                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide.none,
                          // Estilo del borde del campo de texto.
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        // Rellena el campo de texto con un color gris claro.

                        hintText: 'Buscar a tu profesional',
                        // Texto de sugerencia del campo de texto.

                        hintStyle: GoogleFonts.lato(
                          color: Colors.black26,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          // Aplica el estilo del texto de sugerencia usando la fuente Lato.
                        ),
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            // Estilo del icono de búsqueda.
                          ),
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            color: Colors.white,
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        // Aplica el estilo del texto del campo de búsqueda usando la fuente Lato.
                      ),
                      onFieldSubmitted: (String value) {
                        setState(
                          () {
                            value.isEmpty
                                ? Container()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchList(
                                        searchKey: value,
                                      ),
                                    ),
                                  );
                            // Navega a la lista de resultados de búsqueda cuando se envía el texto.
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 23, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nosotros te cuidamos",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Carouselslider(),
                    // Muestra un carrusel de contenido.
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Profesionales",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.only(top: 14),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      // Establece la física del desplazamiento para que no haya efecto de rebote.

                      scrollDirection: Axis.horizontal,
                      // Establece la dirección de desplazamiento a horizontal.

                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: cards.length,
                      // Número de elementos en la lista.

                      itemBuilder: (context, index) {
                        // Crea cada elemento de la lista.

                        return Container(
                          margin: const EdgeInsets.only(right: 14),
                          height: 150,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(cards[index].cardBackground),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(3, 3),
                                ),
                              ]
                              // Aplica estilo y sombra a cada tarjeta de la lista.
                              ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExploreList(
                                          type: cards[index].doctor,
                                        )),
                              );
                              // Navega a la lista de exploración correspondiente al tipo de doctor seleccionado.
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Alinea el contenido de la columna al centro verticalmente.

                              children: [
                                const SizedBox(
                                  height: 16,
                                  // Añade un espacio vertical de 16 píxeles.
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 29,
                                  child: Icon(
                                    cards[index].cardIcon,
                                    size: 26,
                                    color: Color(cards[index].cardBackground),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                  // Añade un espacio vertical de 10 píxeles.
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    cards[index].doctor,
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    // Añade un espacio vertical de 30 píxeles.
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Los más valorados",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const TopRatedList(),
                    // Muestra la lista de los más valorados.
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
