import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore para manejar la base de datos en la nube.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para manejar la autenticación de usuarios.
import 'package:google_fonts/google_fonts.dart'; // Importa Google Fonts para usar fuentes personalizadas.
import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para el desarrollo de aplicaciones.
import 'package:medsal/globals.dart'; // Importa el archivo de variables globales.

class UpdateUserDetails extends StatefulWidget {
  // Define un widget con estado llamado UpdateUserDetails.
  final String label; // Etiqueta del campo a actualizar.
  final String field; // Nombre del campo en la base de datos.
  final String value; // Valor actual del campo.

  const UpdateUserDetails(
      {super.key,
      required this.label,
      required this.field,
      required this.value}); // Constructor del widget.

  @override
  State<UpdateUserDetails> createState() =>
      _UpdateUserDetailsState(); // Crea el estado para el widget.
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  final TextEditingController _textcontroller =
      TextEditingController(); // Controlador para el campo de texto.
  late FocusNode f1; // Nodo de enfoque para el campo de texto.
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Obtiene una instancia de FirebaseAuth.
  User? user; // Define una variable para almacenar el usuario actual.
  String? userID; // Define una variable para almacenar el ID del usuario.

  Future<void> _getUser() async {
    // Función para obtener el usuario actual.
    user = _auth.currentUser!; // Obtiene el usuario actual.
    userID = user!.uid; // Obtiene el ID del usuario.
  }

  @override
  void initState() {
    // Se llama una vez al crear el estado del widget.
    super.initState();
    _getUser(); // Llama a la función para obtener el usuario actual.
  }

  @override
  Widget build(BuildContext context) {
    _textcontroller.text =
        widget.value; // Establece el valor inicial del campo de texto.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors
            .white, // Establece el color de fondo de la barra de aplicaciones.
        elevation: 2, // Establece la elevación de la barra de aplicaciones.
        // Botón de retroceso
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navega de regreso a la pantalla anterior.
          },
          child: const Icon(
            Icons.arrow_back_ios, // Icono del botón de retroceso.
            color: Colors.indigo, // Color del icono del botón de retroceso.
          ),
        ),
        title: Container(
          alignment: Alignment.centerLeft, // Alinea el título a la izquierda.
          child: Text(
            widget.label, // Muestra la etiqueta del campo.
            style: GoogleFonts.lato(
              color: Colors.indigo, // Establece el color del texto.
              fontSize: 21, // Establece el tamaño de la fuente.
              fontWeight: FontWeight.bold, // Establece el grosor de la fuente.
            ),
          ),
        ),
      ),
      body: Padding(
        // Añade un relleno alrededor del contenido.
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          // Organiza los widgets en una columna.
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 15), // Añade un margen horizontal.
              child: TextFormField(
                controller: _textcontroller, // Controlador del campo de texto.
                style: GoogleFonts.lato(
                  fontSize: 20, // Establece el tamaño de la fuente.
                  fontWeight:
                      FontWeight.bold, // Establece el grosor de la fuente.
                ),
                onFieldSubmitted: (String data) {
                  _textcontroller.text =
                      data; // Actualiza el texto del controlador al enviar el formulario.
                },
                textInputAction: TextInputAction
                    .done, // Establece la acción del teclado en "hecho".
                validator: (value) {
                  // Valida el campo de texto.
                  if (value == null) {
                    return 'Por favor ingrese el ${widget.label}'; // Mensaje de error si el campo está vacío.
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 50, // Añade un espacio vertical.
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30), // Añade un relleno horizontal.
              height: 50, // Establece la altura del botón.
              width: MediaQuery.of(context)
                  .size
                  .width, // Establece el ancho del botón al ancho de la pantalla.
              child: ElevatedButton(
                onPressed: () {
                  // Función que se ejecuta al presionar el botón.
                  FocusScope.of(context).unfocus(); // Oculta el teclado.
                  updateData(); // Llama a la función para actualizar los datos.
                  Navigator.of(context).pop(
                      context); // Navega de regreso a la pantalla anterior.
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Colors.black, // Establece el color del texto del botón.
                  backgroundColor: Colors.indigo.withOpacity(
                      0.9), // Establece el color de fondo del botón.
                  elevation: 2, // Establece la elevación del botón.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        32.0), // Establece el radio de las esquinas del botón.
                  ),
                ),
                child: Text(
                  'Actualizar', // Texto del botón.
                  style: GoogleFonts.lato(
                    color: Colors.white, // Establece el color del texto.
                    fontSize: 18, // Establece el tamaño de la fuente.
                    fontWeight:
                        FontWeight.bold, // Establece el grosor de la fuente.
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    // Función para actualizar los datos en Firestore.
    FirebaseFirestore.instance
        .collection(isDoctor
            ? 'doctor'
            : 'patient') // Selecciona la colección según el tipo de usuario.
        .doc(userID) // Selecciona el documento del usuario actual.
        .set({
      widget.field:
          _textcontroller.text, // Actualiza el campo con el nuevo valor.
    }, SetOptions(merge: true)); // Fusiona los nuevos datos con los existentes.
    if (widget.field.compareTo('name') == 0) {
      await user!.updateDisplayName(_textcontroller
          .text); // Actualiza el nombre de usuario en Firebase Auth.
    }
  }
}
