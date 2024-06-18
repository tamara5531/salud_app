import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/screens/patient/booking_screen.dart';
// Importa el archivo `booking_screen.dart` del proyecto `medsal`, que probablemente contiene la pantalla de reserva de citas.

import 'package:url_launcher/url_launcher.dart';
// Importa la biblioteca url_launcher para lanzar URLs y realizar acciones como hacer llamadas telefónicas.

// ignore: must_be_immutable
class DoctorProfile extends StatefulWidget {
  String? doctor = "P";
  // Declara un campo mutable `doctor` para la clase `DoctorProfile`.

  DoctorProfile({super.key, this.doctor});
  // Constructor que acepta una clave opcional y un nombre de doctor.

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
  // Sobrescribe el método `createState` para devolver una instancia de `_DoctorProfileState`, que manejará el estado de este widget.
}

class _DoctorProfileState extends State<DoctorProfile> {
  // Define la clase `_DoctorProfileState` que extiende `State<DoctorProfile>` para gestionar el estado del widget.

  // Método para realizar una llamada telefónica
  _launchCaller(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    // Construye la URL para la llamada telefónica.

    // ignore: deprecated_member_use
    launch(url);
    // Lanza la URL para hacer la llamada.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Establece el color de fondo del scaffold a blanco.

      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctor')
              .orderBy('name')
              .startAt([widget.doctor]).endAt(
                  ['${widget.doctor!}\uf8ff']).snapshots(),
          // Crea un flujo de datos desde Firestore para la colección `doctor`, ordenada por el campo `name` y filtrada por el nombre del doctor.

          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
                // Muestra un indicador de progreso mientras se cargan los datos.
              );
            }
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                // Desactiva el indicador de overscroll.

                return true;
              },
              child: ListView.builder(
                itemCount: snapshot.data!.size,
                // Establece el número de elementos en la lista basado en el número de documentos en el snapshot.

                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  // Obtiene el documento en el índice actual.

                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    // Añade un margen superior de 5 píxeles al contenedor.

                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 5),
                          // Añade un padding izquierdo de 5 píxeles al contenedor.

                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_left_sharp,
                              color: Colors.indigo,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // Navega de regreso a la pantalla anterior.
                            },
                          ),
                        ),

                        // Foto de perfil del doctor
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(document['profilePhoto'] ?? ''),
                          // Establece la imagen de fondo del avatar con la foto de perfil del doctor.

                          backgroundColor: Colors.lightBlue[100],
                          radius: 80,
                          // Establece el radio del avatar a 80 píxeles.
                        ),
                        const SizedBox(
                          height: 20,
                          // Añade un espacio vertical de 20 píxeles.
                        ),

                        // Nombre del doctor
                        Text(
                          document['name'] ?? '-',
                          // Muestra el nombre del doctor.

                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            // Aplica el estilo del texto usando la fuente Lato.
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                          // Añade un espacio vertical de 10 píxeles.
                        ),

                        // Especialización del doctor (comentada)
                        // const SizedBox(
                        //   height: 16,
                        // ),

                        // Calificación
                        Rating(
                            rating:
                                double.parse(document['rating'].toString())),
                        // Muestra la calificación del doctor.

                        const SizedBox(
                          height: 14,
                          // Añade un espacio vertical de 14 píxeles.
                        ),

                        // Descripción
                        Container(
                          padding: const EdgeInsets.only(left: 22, right: 22),
                          alignment: Alignment.center,
                          child: Text(
                            document['specification'] ?? '-',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black54,
                              // Aplica el estilo del texto usando la fuente Lato.
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          // Añade un espacio vertical de 20 píxeles.
                        ),

                        // Dirección
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 15,
                                // Añade un espacio horizontal de 15 píxeles.
                              ),
                              const Icon(Icons.place_outlined),
                              const SizedBox(
                                width: 20,
                                // Añade un espacio horizontal de 20 píxeles.
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: Text(
                                  document['address'] ?? '-',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    // Aplica el estilo del texto usando la fuente Lato.
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                                // Añade un espacio horizontal de 10 píxeles.
                              ),
                            ],
                          ),
                        ),

                        // Número de teléfono
                        Container(
                          height: MediaQuery.of(context).size.height / 12,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                                // Añade un espacio horizontal de 15 píxeles.
                              ),
                              const Icon(Icons.phone_in_talk),
                              const SizedBox(
                                width: 11,
                                // Añade un espacio horizontal de 11 píxeles.
                              ),
                              TextButton(
                                onPressed: () =>
                                    _launchCaller("${document['phone']}"),
                                // Realiza una llamada telefónica al número del doctor.

                                child: Text(
                                  document['phone'] ?? '-',
                                  style: GoogleFonts.lato(
                                      fontSize: 16, color: Colors.blue),
                                  // Aplica el estilo del texto usando la fuente Lato.
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                                // Añade un espacio horizontal de 10 píxeles.
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 0,
                          // Añade un espacio vertical de 0 píxeles.
                        ),

                        // Horario de trabajo
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                                // Añade un espacio horizontal de 15 píxeles.
                              ),
                              const Icon(Icons.access_time_rounded),
                              const SizedBox(width: 20),
                              Text(
                                'Horas laborales',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  // Aplica el estilo del texto usando la fuente Lato.
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          // Añade un espacio vertical de 20 píxeles.
                        ),

                        // Horario de atención de hoy
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.only(left: 60),
                          child: Row(
                            children: [
                              Text(
                                'Hoy: ',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  // Aplica el estilo del texto usando la fuente Lato.
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                                // Añade un espacio horizontal de 10 píxeles.
                              ),
                              Text(
                                document['openHour'] +
                                    " - " +
                                    document['closeHour'],
                                style: GoogleFonts.lato(
                                  fontSize: 17,
                                  // Aplica el estilo del texto usando la fuente Lato.
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                          // Añade un espacio vertical de 50 píxeles.
                        ),

                        // Botón para reservar una cita
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.indigo.withOpacity(0.9),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingScreen(
                                    doctorUid: document['id'],
                                    doctor: document['name'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Reservar una cita',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // Aplica el estilo del texto usando la fuente Lato.
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                          child: Text(
                            'o',
                            textAlign: TextAlign.center,
                          ),
                          // Añade un texto "o" centrado con un espacio vertical de 20 píxeles.
                        ),

                        // Botones para realizar una llamada directa o enviar un mensaje
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Alinea los botones al centro horizontalmente.

                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      Colors.indigo.withOpacity(0.9),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                onPressed: () {
                                  _launchCaller(document['phone']);
                                  // Realiza una llamada telefónica al número del doctor.
                                },
                                child: const Icon(Icons.call),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Rating extends StatelessWidget {
  const Rating({
    super.key,
    required this.rating,
  });

  final double rating;
  // Variable que almacena la calificación del doctor.

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Alinea el contenido de la fila al centro horizontalmente.

      children: [
        for (var i = 0; i < rating.toInt(); i++)
          const Icon(
            Icons.star_rounded,
            color: Colors.indigoAccent,
            size: 30,
          ),
        // Muestra una estrella completa por cada punto entero de la calificación.

        if (rating - rating.toInt() > 0)
          const Icon(
            Icons.star_half_rounded,
            color: Colors.indigoAccent,
            size: 30,
          ),
        // Muestra una media estrella si la calificación tiene un componente fraccionario.

        if (5 - rating.ceil() > 0)
          for (var i = 0; i < 5 - rating.ceil(); i++)
            const Icon(
              Icons.star_rounded,
              color: Colors.black12,
              size: 30,
            ),
        // Muestra estrellas vacías para completar hasta 5 estrellas.
      ],
    );
  }
}
