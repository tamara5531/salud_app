import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para gestionar la autenticación de usuarios.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/globals.dart';
// Importa el archivo `globals.dart` del proyecto `medsal`, donde probablemente se encuentran definidas variables globales.

import 'package:medsal/helperFunction/sharedpref_helper.dart';
// Importa el archivo `sharedpref_helper.dart` del proyecto `medsal`, que probablemente contiene funciones de ayuda para gestionar preferencias compartidas.

import 'package:medsal/screens/register.dart';
// Importa la pantalla de registro del proyecto `medsal`.

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}
// Define una clase `SignIn` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Instancia de `FirebaseAuth` para gestionar la autenticación de usuarios.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Clave global para identificar el formulario y manejar su estado.

  final TextEditingController _emailController = TextEditingController();
  // Controlador de texto para gestionar la entrada del correo electrónico.

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Clave global para identificar el scaffold y manejar su estado.

  final TextEditingController _passwordController = TextEditingController();
  // Controlador de texto para gestionar la entrada de la contraseña.

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  // Nodos de enfoque para manejar el foco de los campos de texto.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Utiliza el scaffold key definido anteriormente.

      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            // Establece que el contenedor debe expandirse para llenar su contenedor.

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/2.png'),
                // Establece una imagen de fondo desde los assets.

                fit: BoxFit.cover,
                // Ajusta la imagen para que cubra todo el contenedor.
              ),
            ),
          ),
          SafeArea(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                // Desactiva el indicador de overscroll.

                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      // Define el padding del contenedor.

                      child: withEmailPassword(),
                      // Llama al widget que contiene el formulario de inicio de sesión.
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget withEmailPassword() {
    return Form(
      key: _formKey,
      // Utiliza la clave del formulario definida anteriormente.

      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        // Define el padding para el formulario.

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Alinea el contenido del formulario al centro.

          children: [
            const SizedBox(height: 20),
            // Añade un espacio vertical de 20 píxeles.

            Container(
              padding: const EdgeInsets.only(bottom: 25),
              // Define el padding inferior del contenedor.

              child: Text(
                'Login',
                // Texto que indica el título de la pantalla.

                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  // Estilo de texto usando la fuente Lato de Google Fonts.
                ),
              ),
            ),
            TextFormField(
              focusNode: f1,
              // Asigna el nodo de enfoque f1 a este campo de texto.

              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                // Estilo de texto usando la fuente Lato de Google Fonts.
              ),
              keyboardType: TextInputType.emailAddress,
              // Establece el tipo de teclado para direcciones de correo electrónico.

              controller: _emailController,
              // Asigna el controlador de texto para el correo electrónico.

              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                // Define el padding del contenido del campo de texto.

                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                  // Establece el borde del campo de texto sin línea.
                ),
                filled: true,
                fillColor: Colors.grey[350],
                // Rellena el campo de texto con un color gris.

                hintText: 'Email',
                // Texto de sugerencia dentro del campo de texto.

                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  // Estilo de texto de la sugerencia usando la fuente Lato.
                ),
              ),
              onFieldSubmitted: (value) {
                f1.unfocus();
                // Desenfoca el nodo f1.

                FocusScope.of(context).requestFocus(f2);
                // Enfoca el siguiente nodo f2.
              },
              textInputAction: TextInputAction.next,
              // Establece la acción del teclado a "siguiente".

              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingrese Email';
                  // Valida que el campo no esté vacío.
                } else if (!emailValidate(value)) {
                  return 'Por favor, ingrese email válido';
                  // Valida que el correo electrónico tenga un formato válido.
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 25.0),
            // Añade un espacio vertical de 25 píxeles.

            TextFormField(
              focusNode: f2,
              // Asigna el nodo de enfoque f2 a este campo de texto.

              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                // Estilo de texto usando la fuente Lato de Google Fonts.
              ),
              controller: _passwordController,
              // Asigna el controlador de texto para la contraseña.

              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                // Define el padding del contenido del campo de texto.

                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                  // Establece el borde del campo de texto sin línea.
                ),
                filled: true,
                fillColor: Colors.grey[350],
                // Rellena el campo de texto con un color gris.

                hintText: 'Contraseña',
                // Texto de sugerencia dentro del campo de texto.

                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  // Estilo de texto de la sugerencia usando la fuente Lato.
                ),
              ),
              onFieldSubmitted: (value) {
                f2.unfocus();
                // Desenfoca el nodo f2.

                FocusScope.of(context).requestFocus(f3);
                // Enfoca el siguiente nodo f3.
              },
              textInputAction: TextInputAction.done,
              // Establece la acción del teclado a "hecho".

              validator: (value) {
                if (value!.isEmpty) return 'Por favor, ingrese contraseña';
                // Valida que el campo no esté vacío.

                return null;
              },
              obscureText: true,
              // Establece que el texto debe estar oculto (para contraseñas).
            ),
            Container(
              padding: const EdgeInsets.only(top: 25.0),
              // Define el padding superior del contenedor.

              child: SizedBox(
                width: double.infinity,
                height: 50,
                // Establece el ancho y alto del botón de inicio de sesión.

                child: ElevatedButton(
                  focusNode: f3,
                  // Asigna el nodo de enfoque f3 a este botón.

                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showLoaderDialog(context);
                      // Muestra un diálogo de carga si el formulario es válido.

                      await _signInWithEmailAndPassword();
                      // Intenta iniciar sesión con correo electrónico y contraseña.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.indigo[900],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    // Estilo del botón de inicio de sesión.
                  ),
                  child: Text(
                    "Iniciar sesión",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      // Estilo del texto del botón usando la fuente Lato.
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              // Define el padding superior del contenedor.

              child: TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
                // Estilo del botón de texto.

                onPressed: () {},
                // Acción al presionar el botón.

                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    // Estilo del texto del botón usando la fuente Lato.
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              // Define el padding superior del contenedor.

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // Alinea los elementos en el centro.

                children: [
                  Text(
                    "¿No tienes cuenta? ",
                    style: GoogleFonts.lato(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      // Estilo del texto usando la fuente Lato.
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    // Estilo del botón de texto.

                    onPressed: () => _pushPage(context, const Register()),
                    // Acción al presionar el botón para navegar a la pantalla de registro.

                    child: Text(
                      'Regístrate aquí',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w600,
                        // Estilo del texto del botón usando la fuente Lato.
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // Limpia los controladores de texto cuando el widget se destruye.

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text("Cargando...")),
          // Muestra un diálogo de carga con un indicador de progreso.
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool emailValidate(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }
  // Valida el formato del correo electrónico usando una expresión regular.

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      // Intenta iniciar sesión con correo electrónico y contraseña.

      if (user == null) {
        Navigator.pop(context);
        final snackBar = SnackBar(
          content: Row(
            children: const [
              Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              Text(" User not found"),
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      // Obtiene el documento del usuario desde Firestore.

      if (!snap.exists) {
        Navigator.pop(context);
        final snackBar = SnackBar(
          content: Row(
            children: const [
              Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              Text(" User document not found"),
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      var basicInfo = snap.data() as Map<String, dynamic>;
      // Almacena la información básica del usuario.

      isDoctor = basicInfo['type'] == 'doctor';
      // Verifica si el usuario es doctor.

      // save data to local storage
      await SharedPreferenceHelper().saveUserId(user.uid);
      await SharedPreferenceHelper().saveUserName(basicInfo['name']);
      await SharedPreferenceHelper().saveAccountType(isDoctor);

      SharedPreferenceHelper().saveUserId(user.uid);
      SharedPreferenceHelper().saveUserName(basicInfo['name']);
      SharedPreferenceHelper()
          .saveAccountType(basicInfo['type'] == 'doctor' ? true : false);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      // Navega a la pantalla principal y elimina todas las rutas anteriores.
    } catch (e) {
      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            Text(" Hubo un problema al iniciar sesión"),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    // Navega a una nueva página.
  }
}
