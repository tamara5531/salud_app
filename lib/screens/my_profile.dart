import 'dart:typed_data';
// Importa la biblioteca 'typed_data' que proporciona tipos de datos binarios y de listas tipadas.

import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la biblioteca de Cloud Firestore para interactuar con la base de datos Firestore.

import 'package:firebase_auth/firebase_auth.dart';
// Importa la biblioteca de autenticación de Firebase para gestionar la autenticación de usuarios.

import 'package:firebase_storage/firebase_storage.dart';
// Importa la biblioteca de almacenamiento de Firebase para subir y descargar archivos.

import 'package:flutter/material.dart';
// Importa la biblioteca de Flutter para desarrollar interfaces gráficas con componentes de Material Design.

import 'package:google_fonts/google_fonts.dart';
// Importa la biblioteca Google Fonts para utilizar fuentes de Google en la aplicación.

import 'package:medsal/firestore_data/appointment_history_list.dart';
// Importa el archivo `appointment_history_list.dart` del proyecto `medsal`, que probablemente contiene la lista de historial de citas.

import 'package:medsal/globals.dart';
// Importa el archivo `globals.dart` del proyecto `medsal`, donde probablemente se encuentran definidas variables globales.

import 'package:image_picker/image_picker.dart';
// Importa la biblioteca `image_picker` para seleccionar imágenes de la galería o cámara del dispositivo.

import 'package:medsal/screens/setting.dart';
// Importa el archivo `setting.dart` del proyecto `medsal`, que probablemente contiene la configuración de usuario.

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);
  // Define la clase `MyProfile` que extiende `StatefulWidget`, indicando que este widget puede tener un estado mutable.
  // El constructor `const` se utiliza para crear una instancia constante de esta clase.

  @override
  State<MyProfile> createState() => _MyProfileState();
  // Sobrescribe el método `createState` para devolver una instancia de `_MyProfileState`, que manejará el estado de este widget.
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Instancia de `FirebaseAuth` para gestionar la autenticación de usuarios.

  User? user;
  // Variable para almacenar el usuario autenticado actualmente.

  final FirebaseStorage storage = FirebaseStorage.instance;
  // Instancia de `FirebaseStorage` para gestionar el almacenamiento de archivos.

  // Detalles del usuario
  String? email;
  String? name;
  String? phone;
  String? bio;
  String? specialization;

  // Imagen de perfil por defecto
  String image =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  // URL de una imagen de perfil por defecto.

  bool _isLoading = true;
  // Variable para indicar si la información está cargando.

  final ScrollController _scrollController = ScrollController();
  // Controlador de desplazamiento para manejar el desplazamiento del contenido.

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    // Método para limpiar recursos cuando el widget se destruye.
  }

  Future<void> _getUser() async {
    try {
      user = _auth.currentUser;
      // Obtiene el usuario autenticado actualmente.

      if (user == null) {
        throw Exception('Usuario no encontrado');
        // Lanza una excepción si el usuario no está autenticado.
      }

      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection(isDoctor ? 'doctor' : 'patient')
          .doc(user!.uid)
          .get();
      // Obtiene el documento del usuario desde Firestore.

      if (!snap.exists || snap.data() == null) {
        throw Exception('Documento no encontrado o los datos son nulos');
        // Lanza una excepción si el documento no existe o los datos son nulos.
      }

      setState(() {
        var snapshot = snap.data() as Map<String, dynamic>;
        email = snapshot['email'];
        name = snapshot['name'];
        phone = snapshot['phone'];
        bio = snapshot['bio'];
        image = snapshot['profilePhoto'] ?? image;
        specialization = snapshot['specialization'];
        _isLoading = false;
        // Actualiza el estado del widget con los datos obtenidos.
      });
      print(snap.data());
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        // Maneja las excepciones y detiene la carga en caso de error.
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    // Llama a `_getUser` para obtener la información del usuario cuando se inicializa el estado del widget.
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
      // Muestra un indicador de progreso mientras se carga la información.
    }

    if (user == null) {
      return Center(child: Text('Ningún usuario encontrado'));
      // Muestra un mensaje si no se encuentra un usuario autenticado.
    }

    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
            // Desactiva el indicador de overscroll.
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.5],
                            colors: [
                              Colors.indigo,
                              Colors.indigoAccent,
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 5,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, right: 7),
                          alignment: Alignment.topRight,
                          // Botón para editar la información del usuario.
                          child: IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserSettings(),
                                ),
                              ).then((value) {
                                // Recarga la página al volver de la configuración.
                                _getUser();
                                setState(() {});
                              });
                            },
                          ),
                        ),
                      ),
                      // Nombre del usuario.
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 6,
                        padding: const EdgeInsets.only(top: 75),
                        child: Text(
                          name ?? 'Nombre no agregado',
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(specialization == null ? '' : '($specialization)'),
                    ],
                  ),
                  // Imagen del usuario.
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.teal.shade50,
                          width: 5,
                        ),
                        shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () {
                        _showSelectionDialog(context);
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(image),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Información básica del usuario.
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                padding: const EdgeInsets.only(left: 20),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Correo del usuario.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.red[900],
                            child: const Icon(
                              Icons.mail_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          email ?? 'Email no agregado',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Número de teléfono del usuario.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.blue[800],
                            child: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          phone ?? 'No agregado',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Biografía del usuario.
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                padding: const EdgeInsets.only(left: 20, top: 20),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.indigo[600],
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Bio',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // Contenido de la biografía.
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 10, left: 40),
                      child: Text(
                        bio ?? 'No añadido',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black38,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Historial de citas del usuario.
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                padding: const EdgeInsets.only(left: 20, top: 20),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.green[900],
                            child: const Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Historial de citas",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 30,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppointmentHistoryList()));
                                },
                                child: const Text('Ver todo'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: Container(
                          padding: const EdgeInsets.only(right: 15),
                          child: const AppointmentHistoryList(),
                          // Lista de historial de citas.
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Para seleccionar o tomar una foto desde el dispositivo.
  Future selectOrTakePhoto(ImageSource imageSource) async {
    XFile? file =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 12);
    // Selecciona una imagen de la galería o la cámara con una calidad del 12%.

    if (file != null) {
      var im = await file.readAsBytes();
      // Lee la imagen como bytes.

      // Sube la imagen a la nube.
      await uploadFile(im, file.name);
      return;
    }

    print('No se seleccionó ni se tomó ninguna foto');
    // Imprime un mensaje si no se seleccionó ninguna imagen.
  }

  // Diálogo para seleccionar la fuente de la foto.
  Future _showSelectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Seleccione Foto'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('Desde galería'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text('Tomar foto'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Subir imagen.
  Future uploadFile(Uint8List img, String fileName) async {
    final destination = 'dp/${user?.displayName}-$fileName';
    // Establece el destino del archivo en Firebase Storage.

    try {
      final ref = storage.ref(destination);
      // Referencia al destino en Firebase Storage.

      UploadTask uploadTask = ref.putData(img);
      // Crea una tarea de subida con los datos de la imagen.

      TaskSnapshot snapshot = await uploadTask;
      // Espera a que la tarea de subida complete y obtiene un `TaskSnapshot`.

      String downloadUrl = await snapshot.ref.getDownloadURL();
      // Obtiene la URL de descarga del archivo subido.

      print('image url : $downloadUrl');

      setState(() {
        image = Uri.decodeFull(downloadUrl.toString());
        // Actualiza el estado con la nueva URL de la imagen.
      });

      FirebaseFirestore.instance
          .collection(isDoctor ? 'doctor' : 'patient')
          .doc(user?.uid)
          .set({
        'profilePhoto': downloadUrl,
      }, SetOptions(merge: true));
      // Actualiza la foto de perfil en Firestore en la colección correspondiente.

      // Datos principales del usuario.
      FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'profilePhoto': downloadUrl,
      }, SetOptions(merge: true));
      // Actualiza la foto de perfil en la colección `users`.

      print("subido !!!");
    } catch (e) {
      print(e.toString());
      print('ocurrió un error');
    }
  }
}
