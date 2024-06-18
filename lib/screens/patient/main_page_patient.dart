import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para gestionar la autenticación de usuarios.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:google_nav_bar/google_nav_bar.dart';
// Importa la biblioteca Google Nav Bar para una barra de navegación inferior con estilo de Google.

import 'package:medsal/screens/my_profile.dart';
// Importa el archivo `my_profile.dart` del proyecto `medsal`, que probablemente contiene la pantalla del perfil del usuario.

import 'package:medsal/screens/patient/doctor_list.dart';
// Importa el archivo `doctor_list.dart` del proyecto `medsal`, que probablemente contiene la lista de doctores para los pacientes.

import 'package:medsal/screens/patient/home_page.dart';
// Importa el archivo `home_page.dart` del proyecto `medsal`, que probablemente contiene la pantalla de inicio para los pacientes.

import 'package:medsal/screens/patient/appointments.dart';
// Importa el archivo `appointments.dart` del proyecto `medsal`, que probablemente contiene la pantalla de citas para los pacientes.

import 'package:typicons_flutter/typicons_flutter.dart';
// Importa la biblioteca Typicons para utilizar iconos adicionales.

class MainPagePatient extends StatefulWidget {
  const MainPagePatient({Key? key}) : super(key: key);
  // Define una clase `MainPagePatient` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor `const` se utiliza para crear una instancia constante de esta clase.

  @override
  State<MainPagePatient> createState() => _MainPagePatientState();
  // Sobrescribe el método `createState` para devolver una instancia de `_MainPagePatientState`, que manejará el estado de este widget.
}

class _MainPagePatientState extends State<MainPagePatient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Define una clave global para identificar el scaffold y manejar su estado.

  int _selectedIndex = 0;
  // Variable para rastrear el índice de la pestaña seleccionada.

  final List<Widget> _pages = [
    const HomePage(),
    const DoctorsList(),
    const Appointments(),
    const MyProfile(),
  ];
  // Lista de widgets que corresponden a cada página de la barra de navegación.

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
    // Llama a `_getUser` para obtener la información del usuario cuando se inicializa el estado del widget.
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Actualiza el índice de la pestaña seleccionada y reconstruye el widget.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // Establece el color de fondo del contenedor a blanco.

      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Establece el color de fondo del scaffold a transparente.

        key: _scaffoldKey,
        // Utiliza la clave del scaffold definida anteriormente.

        body: _pages[_selectedIndex],
        // Muestra la página correspondiente al índice seleccionado.

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // Establece el color de fondo del contenedor a blanco.

            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              // Define los radios de borde superior izquierdo y derecho.
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.2),
                // Establece una sombra con un desenfoque de 20 píxeles y una opacidad del 20%.
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              // Añade un padding horizontal y vertical al contenedor.

              child: GNav(
                curve: Curves.easeOutExpo,
                // Establece la curva de animación de las pestañas.

                rippleColor: Colors.grey.shade300,
                // Establece el color del ripple al tocar una pestaña.

                hoverColor: Colors.grey.shade100,
                // Establece el color al pasar el mouse sobre una pestaña.

                haptic: true,
                // Habilita la retroalimentación háptica.

                tabBorderRadius: 20,
                // Define el radio de borde de las pestañas.

                gap: 5,
                // Define el espacio entre el icono y el texto de las pestañas.

                activeColor: Colors.white,
                // Establece el color activo de las pestañas a blanco.

                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                // Añade un padding horizontal y vertical a las pestañas.

                duration: const Duration(milliseconds: 200),
                // Establece la duración de la animación de cambio de pestañas.

                tabBackgroundColor: Colors.blue.withOpacity(0.7),
                // Establece el color de fondo de las pestañas activas.

                textStyle: GoogleFonts.lato(
                  color: Colors.white,
                  // Aplica el estilo del texto de las pestañas usando la fuente Lato.
                ),
                tabs: const [
                  GButton(
                    iconSize: 28,
                    icon: Icons.home,
                    // Define el icono de la pestaña "Home".
                  ),
                  GButton(
                    icon: Icons.search,
                    // Define el icono de la pestaña "Search".
                  ),
                  GButton(
                    iconSize: 28,
                    icon: Typicons.calendar,
                    // Define el icono de la pestaña "Appointments".
                  ),
                  GButton(
                    iconSize: 28,
                    icon: Typicons.user,
                    // Define el icono de la pestaña "Profile".
                  ),
                ],
                selectedIndex: _selectedIndex,
                // Establece el índice de la pestaña seleccionada.

                onTabChange: _onItemTapped,
                // Llama a `_onItemTapped` cuando se cambia de pestaña.
              ),
            ),
          ),
        ),
      ),
    );
  }
}
