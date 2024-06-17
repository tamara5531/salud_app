import 'dart:math'; // Importa el paquete math para generar números aleatorios.
import 'package:medsal/globals.dart'
    as globals; // Importa un archivo local con variables globales.

import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos en la nube de Firebase.
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth para la autenticación de usuarios.
import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para construir la interfaz de usuario.
import 'package:google_fonts/google_fonts.dart'; // Importa el paquete Google Fonts para utilizar fuentes específicas en el texto.
import 'package:medsal/screens/sign_in.dart'; // Importa la pantalla de inicio de sesión.

class Register extends StatefulWidget {
  // Define un widget con estado llamado Register.
  const Register({Key? key}) : super(key: key); // Constructor del widget.

  @override
  State<Register> createState() =>
      _RegisterState(); // Crea el estado asociado a este widget.
}

class _RegisterState extends State<Register> {
  // Define la clase de estado _RegisterState.
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Instancia de FirebaseAuth para manejar la autenticación.
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Llave global para el formulario.
  final TextEditingController _displayName =
      TextEditingController(); // Controlador para el campo de texto del nombre.
  final TextEditingController _emailController =
      TextEditingController(); // Controlador para el campo de texto del email.
  final TextEditingController _passwordController =
      TextEditingController(); // Controlador para el campo de texto de la contraseña.
  final TextEditingController _passwordConfirmController =
      TextEditingController(); // Controlador para el campo de texto de confirmación de la contraseña.

  int type = -1; // Variable para almacenar el tipo de cuenta.

  FocusNode f1 =
      FocusNode(); // Nodo de enfoque para el campo de texto del nombre.
  FocusNode f2 =
      FocusNode(); // Nodo de enfoque para el campo de texto del email.
  FocusNode f3 =
      FocusNode(); // Nodo de enfoque para el campo de texto de la contraseña.
  FocusNode f4 =
      FocusNode(); // Nodo de enfoque para el campo de texto de confirmación de la contraseña.

  @override
  void dispose() {
    // Método para limpiar controladores cuando se destruye el widget.
    _emailController.dispose(); // Limpia el controlador del email.
    _passwordController.dispose(); // Limpia el controlador de la contraseña.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Método build para construir la interfaz de usuario.
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo del Scaffold.
      body: SafeArea(
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              // Listener para manejar la sobrecarga del indicador de desplazamiento.
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              // Permite el desplazamiento en caso de que el contenido sea mayor que la pantalla.
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                        10, 40, 10, 10), // Padding del contenedor.
                    child: _signUp(), // Muestra el formulario de registro.
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUp() {
    // Método que devuelve el formulario de registro.
    return Form(
      key: _formKey, // Llave del formulario.
      child: Padding(
        padding: const EdgeInsets.only(
            right: 16, left: 16), // Padding del formulario.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Alinea los hijos en el centro horizontalmente.
          children: [
            const SizedBox(height: 20), // Espaciado vertical.
            Container(
              padding:
                  const EdgeInsets.only(bottom: 50), // Padding del contenedor.
              child: Text(
                'Crear cuenta', // Título del formulario.
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Campo de texto para el nombre.
            TextFormField(
              focusNode:
                  f1, // Nodo de enfoque para el campo de texto del nombre.
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _displayName,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 20,
                    top: 10,
                    bottom: 10), // Padding del contenido del campo de texto.
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(90.0)), // Bordes redondeados.
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Colors.grey[350], // Color de fondo del campo de texto.
                hintText: 'Nombre', // Texto de pista.
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                // Acción al enviar el campo.
                f1.unfocus();
                FocusScope.of(context).requestFocus(f2);
              },
              textInputAction: TextInputAction.next, // Acción del teclado.
              validator: (value) {
                // Validador del campo de texto.
                if (value!.isEmpty) return 'Por favor ingrese su nombre';
                return null;
              },
            ),
            const SizedBox(height: 25.0), // Espaciado vertical.

            // Campo de texto para el email.
            TextFormField(
              focusNode:
                  f2, // Nodo de enfoque para el campo de texto del email.
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 20,
                    top: 10,
                    bottom: 10), // Padding del contenido del campo de texto.
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(90.0)), // Bordes redondeados.
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Colors.grey[350], // Color de fondo del campo de texto.
                hintText: 'Email', // Texto de pista.
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                // Acción al enviar el campo.
                f2.unfocus();
                if (_passwordController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f3);
                }
              },
              textInputAction: TextInputAction.next, // Acción del teclado.
              validator: (value) {
                // Validador del campo de texto.
                if (value!.isEmpty) {
                  return 'Por favor ingrese su email';
                } else if (!emailValidate(value)) {
                  return 'Por favor ingrese un email valido';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0), // Espaciado vertical.

            // Campo de texto para la contraseña.
            TextFormField(
              focusNode:
                  f3, // Nodo de enfoque para el campo de texto de la contraseña.
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              controller: _passwordController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 20,
                    top: 10,
                    bottom: 10), // Padding del contenido del campo de texto.
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(90.0)), // Bordes redondeados.
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Colors.grey[350], // Color de fondo del campo de texto.
                hintText: 'Contraseña', // Texto de pista.
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                // Acción al enviar el campo.
                f3.unfocus();
                if (_passwordConfirmController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f4);
                }
              },
              textInputAction: TextInputAction.next, // Acción del teclado.
              validator: (value) {
                // Validador del campo de texto.
                if (value!.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                } else if (value.length < 8) {
                  return 'La contraseña debe tener al menos 8 caracteres';
                } else {
                  return null;
                }
              },
              obscureText: true, // Oculta el texto de la contraseña.
            ),
            const SizedBox(height: 25.0), // Espaciado vertical.

            // Campo de texto para confirmar la contraseña.
            TextFormField(
              focusNode:
                  f4, // Nodo de enfoque para el campo de texto de confirmación de la contraseña.
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              controller: _passwordConfirmController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 20,
                    top: 10,
                    bottom: 10), // Padding del contenido del campo de texto.
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(90.0)), // Bordes redondeados.
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Colors.grey[350], // Color de fondo del campo de texto.
                hintText: 'Confirmar contraseña', // Texto de pista.
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                // Acción al enviar el campo.
                f4.unfocus();
              },
              textInputAction: TextInputAction.done, // Acción del teclado.
              validator: (value) {
                // Validador del campo de texto.
                if (value!.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                } else if (value.compareTo(_passwordController.text) != 0) {
                  return 'La contraseña no coincide';
                } else {
                  return null;
                }
              },
              obscureText: true, // Oculta el texto de la contraseña.
            ),

            const SizedBox(height: 20), // Espaciado vertical.

            // Tipo de cuenta (profesional o paciente).
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón para profesional.
                SizedBox(
                  width: MediaQuery.of(context).size.width /
                      2.5, // Ancho del botón.
                  height: 50, // Altura del botón.
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type =
                            0; // Establece el tipo de cuenta como profesional.
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor:
                          Colors.grey[350], // Color de fondo del botón.
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(32.0), // Bordes redondeados.
                      ),
                      side: BorderSide(
                        width: 5.0,
                        color: Colors.black38,
                        style: type == 0
                            ? BorderStyle.solid
                            : BorderStyle
                                .none, // Muestra el borde solo si es seleccionado.
                      ),
                    ),
                    child: Text(
                      "Profesional",
                      style: GoogleFonts.lato(
                        color: type == 0 ? Colors.black38 : Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50, // Altura del texto.
                  child: Center(
                    child: Text(
                      'o', // Texto separador.
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Botón para paciente.
                SizedBox(
                  width: MediaQuery.of(context).size.width /
                      2.5, // Ancho del botón.
                  height: 50, // Altura del botón.
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 1; // Establece el tipo de cuenta como paciente.
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor:
                          Colors.grey[350], // Color de fondo del botón.
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(32.0), // Bordes redondeados.
                      ),
                      side: BorderSide(
                        style: type == 1
                            ? BorderStyle.solid
                            : BorderStyle
                                .none, // Muestra el borde solo si es seleccionado.
                        width: 5,
                        color: Colors.black38,
                      ),
                    ),
                    child: Text(
                      "Paciente",
                      style: GoogleFonts.lato(
                        color: type == 1 ? Colors.black38 : Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Botón de registrar.
            Container(
              padding:
                  const EdgeInsets.only(top: 25.0), // Padding del contenedor.
              child: SizedBox(
                width: double.infinity, // Ancho del botón.
                height: 50, // Altura del botón.
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && type != -1) {
                      // Valida el formulario y verifica que se haya seleccionado un tipo de cuenta.
                      showLoaderDialog(context); // Muestra un diálogo de carga.
                      _registerAccount(); // Llama al método para registrar la cuenta.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.indigo[900],
                    elevation: 2, // Color y elevación del botón.
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(32.0), // Bordes redondeados.
                    ),
                  ),
                  child: Text(
                    "Iniciar sesión", // Texto del botón.
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Separador
            Container(
              padding: const EdgeInsets.only(
                  top: 25, left: 10, right: 10), // Padding del contenedor.
              width: MediaQuery.of(context).size.width, // Ancho del contenedor.
              child: const Divider(
                thickness: 1.5, // Grosor del separador.
              ),
            ),

            // Opción para ir a la página de inicio de sesión.
            Padding(
              padding:
                  const EdgeInsets.only(top: 5.0), // Padding del contenedor.
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Alinea los elementos en el centro horizontalmente.
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Alinea los elementos en el centro verticalmente.
                children: [
                  Text(
                    "¿Ya tienes una cuenta?", // Texto de pregunta.
                    style: GoogleFonts.lato(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.transparent), // Sin efecto de superposición.
                    ),
                    onPressed: () => _pushPage(context,
                        const SignIn()), // Acción al presionar el botón.
                    child: Text(
                      'Iniciar sesión', // Texto del enlace.
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w600,
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

  showAlertDialog(BuildContext context) {
    // Método para mostrar un diálogo de alerta.
    Navigator.pop(context); // Cierra el diálogo actual.
    // Configura el botón de OK.
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context); // Cierra el diálogo.
        FocusScope.of(context)
            .requestFocus(f2); // Enfoca el campo de texto del email.
      },
    );

    // Configura el AlertDialog.
    AlertDialog alert = AlertDialog(
      title: Text(
        "Error!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Email ya existe",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
      ],
    );

    // Muestra el diálogo.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoaderDialog(BuildContext context) {
    // Método para mostrar un diálogo de carga.
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(), // Indicador de progreso circular.
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text("Cargando..."), // Texto de carga.
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false, // No permite cerrar el diálogo al tocar fuera.
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool emailValidate(String email) {
    // Método para validar el formato del email.
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  void _registerAccount() async {
    // Método para registrar una nueva cuenta.
    User? user;
    UserCredential? credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ); // Crea una nueva cuenta de usuario con email y contraseña.
    } catch (error) {
      if (error.toString().compareTo(
              '[firebase_auth/email-already-in-use] The email address is already in use by another account.') ==
          0) {
        showAlertDialog(
            context); // Muestra un diálogo de alerta si el email ya está en uso.
      }
      print(error.toString()); // Imprime el error en la consola.
    }
    user = credential!.user;

    if (user != null) {
      if (!user.emailVerified) {
        await user
            .sendEmailVerification(); // Envía un correo de verificación si el email no está verificado.
      }
      await user.updateDisplayName(
          _displayName.text); // Actualiza el nombre del usuario.

      String name = (type == 0)
          ? 'Profesional. ${_displayName.text}'
          : _displayName.text; // Establece el nombre según el tipo de cuenta.
      String accountType =
          (type == 0) ? 'doctor' : 'patient'; // Establece el tipo de cuenta.
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'type': accountType,
        'email': user.email,
      }, SetOptions(merge: true)); // Guarda los datos del usuario en Firestore.

      // Configura los datos según el tipo de cuenta (doctor o paciente).
      Map<String, dynamic> mp = {
        'id': user.uid,
        'type': accountType,
        'name': name,
        'birthDate': null,
        'email': user.email,
        'phone': null,
        'bio': null,
        'address': null,
        'profilePhoto': null,
      };
      // Si es doctor
      if (type == 0) {
        mp.addAll({
          'openHour': "09:00",
          'closeHour': "21:00",
          'rating': double.parse(
              (3 + Random().nextDouble() * 1.9).toStringAsPrecision(2)),
          'specification': null,
          'specialization': 'general',
        });
        globals.isDoctor = true;
      }

      FirebaseFirestore.instance
          .collection(accountType)
          .doc(user.uid)
          .set(mp); // Guarda los datos adicionales del usuario en Firestore.

      Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (Route<dynamic> route) =>
              false); // Navega a la pantalla principal y elimina el historial.
    }
  }

  void _pushPage(BuildContext context, Widget page) {
    // Método para navegar a otra página.
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
