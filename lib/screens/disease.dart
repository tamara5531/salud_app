import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/screens/diseasedetail.dart';
// Importa el archivo `diseasedetail.dart` del proyecto `medsal`, que probablemente contiene la pantalla de detalles de enfermedades.

class Disease extends StatefulWidget {
  const Disease({Key? key}) : super(key: key);
  // Define una clase `Disease` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor `const` se utiliza para crear una instancia constante de esta clase.

  @override
  State<Disease> createState() => _DiseaseState();
  // Sobrescribe el método `createState` para devolver una instancia de `_DiseaseState`, que manejará el estado de este widget.
}

class _DiseaseState extends State<Disease> {
  // Define la clase `_DiseaseState` que extiende `State<Disease>` para gestionar el estado del widget.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // Establece el color de fondo de la AppBar a blanco.

          title: Text(
            'Enfermedad',
            // Muestra el título "Enfermedad" en la AppBar.

            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              // Aplica el estilo del texto usando la fuente Lato.
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
            // Establece el tema del icono de la AppBar a negro.
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('disease')
                .orderBy('Name')
                .startAt(['']).endAt(['' '\uf8ff']).snapshots(),
            // Crea un flujo de datos desde Firestore para la colección `disease`, ordenada por el campo `Name` y filtrada para obtener todos los documentos.

            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                  // Muestra un indicador de progreso mientras se cargan los datos.
                );
              }
              return ListView(
                physics: const BouncingScrollPhysics(),
                // Establece la física del desplazamiento para que tenga efecto de rebote.

                children: snapshot.data!.docs.map((document) {
                  // Recorre cada documento en los datos obtenidos de Firestore.

                  return Container(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 0),
                      // Añade un padding al contenedor.

                      width: MediaQuery.of(context).size.width,
                      // Establece el ancho del contenedor al ancho total de la pantalla.

                      height: MediaQuery.of(context).size.height / 10,
                      // Establece la altura del contenedor como una décima parte de la altura total de la pantalla.

                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black87,
                            width: 0.2,
                            // Establece un borde inferior con color negro y ancho de 0.2 píxeles.
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiseaseDetail(
                                disease: document['Name'],
                                // Navega a la pantalla de detalles de la enfermedad cuando se presiona el botón.
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                              // Añade un espacio de 20 píxeles de ancho.
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinea el contenido de la columna al inicio horizontalmente.

                              mainAxisAlignment: MainAxisAlignment.center,
                              // Alinea el contenido de la columna al centro verticalmente.

                              children: [
                                Text(
                                  document['Name'],
                                  // Muestra el nombre de la enfermedad.

                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                    // Aplica el estilo del texto usando la fuente Lato.
                                  ),
                                ),
                                Text(
                                  document['Symtomps'],
                                  // Muestra los síntomas de la enfermedad.

                                  style: GoogleFonts.lato(
                                      fontSize: 14, color: Colors.black54),
                                  // Aplica el estilo del texto usando la fuente Lato.
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              );
            }));
  }
}
