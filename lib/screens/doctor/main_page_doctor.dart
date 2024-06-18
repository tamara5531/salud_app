import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para el desarrollo de aplicaciones.
import 'package:google_fonts/google_fonts.dart'; // Importa Google Fonts para usar fuentes personalizadas.
import 'package:google_nav_bar/google_nav_bar.dart'; // Importa Google Nav Bar para una barra de navegación moderna.
import 'package:medsal/screens/my_profile.dart'; // Importa el archivo que contiene la pantalla de perfil.
import 'package:medsal/screens/patient/appointments.dart'; // Importa el archivo que contiene la pantalla de citas.
import 'package:typicons_flutter/typicons_flutter.dart'; // Importa Typicons para usar íconos.

class MainPageDoctor extends StatefulWidget {
  // Define un widget con estado llamado MainPageDoctor.
  const MainPageDoctor({Key? key}) : super(key: key);

  @override
  State<MainPageDoctor> createState() =>
      _MainPageDoctorState(); // Crea el estado para el widget.
}

class _MainPageDoctorState extends State<MainPageDoctor> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Define una clave global para Scaffold.
  int _selectedIndex = 0; // Inicializa el índice seleccionado a 0.
  final List<Widget> _pages = [
    // Define una lista de widgets para las diferentes páginas.
    const Appointments(), // Página de citas.
    const MyProfile(), // Página de perfil.
  ];

  void _onItemTapped(int index) {
    // Función que se llama cuando se toca un elemento de la barra de navegación.
    setState(() {
      if (index < _pages.length) {
        _selectedIndex = index; // Actualiza el índice seleccionado.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario del widget.
    return Container(
      color: Colors.white, // Establece el color de fondo del contenedor.
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // Establece el color de fondo del Scaffold como transparente.
        key: _scaffoldKey, // Asigna la clave global al Scaffold.
        body: _pages[
            _selectedIndex], // Muestra la página correspondiente al índice seleccionado.
        bottomNavigationBar: Container(
          // Define la barra de navegación inferior.
          decoration: BoxDecoration(
            // Establece la decoración del contenedor.
            color: Colors.white, // Color de fondo blanco.
            borderRadius: const BorderRadius.only(
              topLeft:
                  Radius.circular(20), // Esquina superior izquierda redondeada.
              topRight:
                  Radius.circular(20), // Esquina superior derecha redondeada.
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20, // Radio de desenfoque de la sombra.
                color: Colors.black
                    .withOpacity(.2), // Color de la sombra con opacidad.
              ),
            ],
          ),
          child: SafeArea(
            // Asegura que el contenido no se solape con las áreas seguras del dispositivo.
            child: Padding(
              // Añade un relleno alrededor del contenido.
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                // Define la barra de navegación.
                curve: Curves.easeOutExpo, // Curva de animación.
                rippleColor: Colors.grey.shade300, // Color del efecto ripple.
                hoverColor: Colors
                    .grey.shade100, // Color cuando se pasa el ratón por encima.
                haptic: true, // Habilita retroalimentación háptica.
                tabBorderRadius: 20, // Radio del borde de las pestañas.
                gap: 5, // Espacio entre el ícono y el texto.
                activeColor: Colors.white, // Color del texto activo.
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12), // Relleno de las pestañas.
                duration: const Duration(
                    milliseconds: 200), // Duración de la animación.
                tabBackgroundColor: Colors.blue
                    .withOpacity(0.7), // Color de fondo de la pestaña activa.
                textStyle: GoogleFonts.lato(
                  // Estilo de texto usando Google Fonts.
                  color: Colors.white, // Color del texto.
                ),
                iconSize: 30, // Tamaño del ícono.
                tabs: const [
                  // Define las pestañas de la barra de navegación.
                  GButton(
                    icon: Typicons.calendar, // Ícono de calendario.
                    text: 'Todas las citas', // Texto de la pestaña.
                  ),
                  GButton(
                    icon: Typicons.user, // Ícono de usuario.
                    text: 'Perfil', // Texto de la pestaña.
                  ),
                ],
                selectedIndex: _selectedIndex, // Índice seleccionado.
                onTabChange:
                    _onItemTapped, // Función que se llama al cambiar de pestaña.
              ),
            ),
          ),
        ),
      ),
    );
  }
}
