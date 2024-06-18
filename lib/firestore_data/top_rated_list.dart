import 'dart:math'; // Importa la biblioteca 'math' de Dart para el uso de funciones matemáticas.

import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore de Firebase.
import 'package:flutter/material.dart'; // Importa Flutter para la creación de interfaces de usuario.
import 'package:google_fonts/google_fonts.dart'; // Importa Google Fonts para el uso de fuentes personalizadas.
import 'package:medsal/screens/patient/doctor_profile.dart'; // Importa la pantalla del perfil del doctor.
import 'package:typicons_flutter/typicons_flutter.dart'; // Importa los iconos de Typicons.

class TopRatedList extends StatefulWidget {
  const TopRatedList({Key? key}) : super(key: key);

  @override
  State<TopRatedList> createState() => _TopRatedListState();
}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        // Crea un StreamBuilder que escucha cambios en la colección 'doctor' ordenados por 'rating' de forma descendente.
        stream: FirebaseFirestore.instance
            .collection('doctor')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            // Si no hay datos, muestra un indicador de carga.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Construye una lista de los mejores doctores basándose en la clasificación.
          return ListView.builder(
            scrollDirection: Axis
                .vertical, // Establece la dirección de desplazamiento de la lista.
            physics:
                const ClampingScrollPhysics(), // Establece la física de desplazamiento.
            shrinkWrap: true, // Permite que la lista se ajuste a su contenido.
            itemCount: min(
                5,
                snapshot.data!.docs
                    .length), // Limita la lista a un máximo de 5 elementos.
            itemBuilder: (context, index) {
              DocumentSnapshot doctor = snapshot.data!.docs[
                  index]; // Obtiene el documento del doctor en la posición actual.
              return Padding(
                padding: const EdgeInsets.only(
                    top: 3.0), // Añade un margen superior.
                child: Card(
                  color: Colors
                      .blue[50], // Establece el color de fondo de la tarjeta.
                  elevation: 0, // Establece la elevación de la tarjeta.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Define el radio del borde redondeado.
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 0), // Añade un relleno interno.
                    width: MediaQuery.of(context)
                        .size
                        .width, // Establece el ancho del contenedor.
                    height: MediaQuery.of(context).size.height /
                        9, // Establece la altura del contenedor.
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorProfile(
                              doctor: doctor[
                                  'name'], // Pasa el nombre del doctor a la pantalla del perfil del doctor.
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Alinea los hijos en el centro verticalmente.
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(doctor[
                                    'profilePhoto'] ??
                                ''), // Muestra la foto de perfil del doctor.
                            backgroundColor: Colors.blue,
                            radius: 25, // Establece el radio del avatar.
                          ),
                          const SizedBox(
                            width: 20, // Añade un espacio horizontal.
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Alinea los hijos al inicio horizontalmente.
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Alinea los hijos en el centro verticalmente.
                            children: [
                              Text(
                                doctor['name'], // Muestra el nombre del doctor.
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10, // Añade un espacio horizontal.
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment
                                  .centerRight, // Alinea el contenido a la derecha.
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .end, // Alinea los hijos al final verticalmente.
                                mainAxisAlignment: MainAxisAlignment
                                    .end, // Alinea los hijos al final horizontalmente.
                                children: [
                                  Icon(
                                    Typicons
                                        .star_full_outline, // Muestra el icono de estrella.
                                    size: 20,
                                    color: Colors.indigo[400],
                                  ),
                                  const SizedBox(
                                    width: 3, // Añade un espacio horizontal.
                                  ),
                                  Text(
                                    doctor['rating']
                                        .toString(), // Muestra la clasificación del doctor.
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
