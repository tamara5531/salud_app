import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

class DiseaseDetail extends StatefulWidget {
  final String disease;

  const DiseaseDetail({Key? key, required this.disease}) : super(key: key);
  // Define una clase `DiseaseDetail` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor acepta una cadena `disease` que especifica la enfermedad para mostrar los detalles.

  @override
  State<DiseaseDetail> createState() => _DiseaseDetailState();
  // Sobrescribe el método `createState` para devolver una instancia de `_DiseaseDetailState`, que manejará el estado de este widget.
}

class _DiseaseDetailState extends State<DiseaseDetail> {
  // Define la clase `_DiseaseDetailState` que extiende `State<DiseaseDetail>` para gestionar el estado del widget.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Establece el color de fondo de la pantalla a blanco.

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        // Establece el tema del icono de la AppBar a negro.

        backgroundColor: Colors.white,
        // Establece el color de fondo de la AppBar a blanco.

        elevation: 0,
        // Establece la elevación de la AppBar a 0.

        title: Text(
          widget.disease,
          // Muestra el nombre de la enfermedad en la AppBar.

          style: GoogleFonts.lato(color: Colors.black),
          // Aplica el estilo del texto usando la fuente Lato de Google Fonts.
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('disease')
              .orderBy('Name')
              .startAt([widget.disease]).endAt(
                  ['${widget.disease}\uf8ff']).snapshots(),
          // Crea un flujo de datos desde Firestore para la colección `disease`, ordenada por el campo `Name` y filtrada por la enfermedad especificada.

          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
                // Muestra un indicador de progreso mientras se cargan los datos.
              );
            }
            return ListView(
                physics: const ClampingScrollPhysics(),
                // Establece la física del desplazamiento para que no haya efecto de rebote.

                children: snapshot.data!.docs.map((document) {
                  // Recorre cada documento en los datos obtenidos de Firestore.

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    // Añade un margen superior de 10 píxeles al contenedor.

                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        // Añade un espacio vertical de 20 píxeles.

                        Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey[50],
                              // Estilo del contenedor con un fondo azul grisáceo claro y bordes redondeados.
                            ),
                            child: Text(
                              document['Descripcíon'],
                              // Muestra la descripción de la enfermedad.

                              style: GoogleFonts.lato(
                                  color: Colors.black54, fontSize: 18),
                              // Aplica el estilo del texto usando la fuente Lato.
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        // Añade un espacio vertical de 20 píxeles.

                        Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey[50],
                              // Estilo del contenedor con un fondo azul grisáceo claro y bordes redondeados.
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinea el contenido de la columna al inicio horizontalmente.

                              children: [
                                Text(
                                  '¿Como fue el contagio?',
                                  // Muestra el título de la sección que describe cómo se propaga la enfermedad.

                                  style: GoogleFonts.lato(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  // Aplica el estilo del texto usando la fuente Lato.

                                  textAlign: TextAlign.left,
                                  // Alinea el texto a la izquierda.
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Añade un espacio vertical de 15 píxeles.

                                Text(
                                  document['Spread'],
                                  // Muestra la información sobre cómo se propaga la enfermedad.

                                  style: GoogleFonts.lato(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    // Aplica el estilo del texto usando la fuente Lato.
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        // Añade un espacio vertical de 20 píxeles.

                        Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey[50],
                              // Estilo del contenedor con un fondo azul grisáceo claro y bordes redondeados.
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinea el contenido de la columna al inicio horizontalmente.

                              children: [
                                Text(
                                  'Sintomas',
                                  // Muestra el título de la sección que describe los síntomas de la enfermedad.

                                  style: GoogleFonts.lato(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  // Aplica el estilo del texto usando la fuente Lato.

                                  textAlign: TextAlign.left,
                                  // Alinea el texto a la izquierda.
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Añade un espacio vertical de 15 píxeles.

                                Text(
                                  document['Symtomps'],
                                  // Muestra la información sobre los síntomas de la enfermedad.

                                  style: GoogleFonts.lato(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    // Aplica el estilo del texto usando la fuente Lato.
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        // Añade un espacio vertical de 20 píxeles.

                        Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey[50],
                              // Estilo del contenedor con un fondo azul grisáceo claro y bordes redondeados.
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinea el contenido de la columna al inicio horizontalmente.

                              children: [
                                Text(
                                  'Señales de advertencia: busque atención médica',
                                  // Muestra el título de la sección que describe los signos de advertencia que indican la necesidad de atención médica.

                                  style: GoogleFonts.lato(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  // Aplica el estilo del texto usando la fuente Lato.

                                  textAlign: TextAlign.left,
                                  // Alinea el texto a la izquierda.
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Añade un espacio vertical de 15 píxeles.

                                Text(
                                  document['Warning'],
                                  // Muestra la información sobre los signos de advertencia de la enfermedad.

                                  style: GoogleFonts.lato(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    // Aplica el estilo del texto usando la fuente Lato.
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  );
                }).toList());
          }),
    );
  }
}
