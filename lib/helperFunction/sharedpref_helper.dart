import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete de SharedPreferences para manejar el almacenamiento de datos localmente en el dispositivo.

class SharedPreferenceHelper {
  // Clave para almacenar el ID del usuario.
  final String _userIdKey = "USERIDKEY";
  // Clave para almacenar el nombre del usuario.
  final String _userNameKey = "USERNAMEKEY";
  // Clave para almacenar el tipo de cuenta.
  final String _accountTypeKey = "ACCOUNTTYPEKEY";
  // Clave para almacenar la URL del perfil.
  final String _profileUrlKey = "PROFILEURLKEY";

  // Función para guardar el nombre del usuario.
  Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs.setString(
        _userNameKey, userName); // Guarda el nombre del usuario.
  }

  // Función para guardar el ID del usuario.
  Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs.setString(_userIdKey, userId); // Guarda el ID del usuario.
  }

  // Función para guardar el tipo de cuenta del usuario.
  Future<bool> saveAccountType(bool accountType) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs.setBool(
        _accountTypeKey, accountType); // Guarda el tipo de cuenta del usuario.
  }

  // Función para guardar la URL del perfil del usuario.
  Future<bool> saveProfileUrl(String profileUrl) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs.setString(
        _profileUrlKey, profileUrl); // Guarda la URL del perfil del usuario.
  }

  // Función para obtener el nombre del usuario.
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs.getString(_userNameKey); // Retorna el nombre del usuario.
  }

  // Función para obtener el ID del usuario.
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs.getString(_userIdKey); // Retorna el ID del usuario.
  }

  // Función para obtener el tipo de cuenta del usuario.
  Future<bool?> getAccountType() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs
        .getBool(_accountTypeKey); // Retorna el tipo de cuenta del usuario.
  }

  // Función para obtener la URL del perfil del usuario.
  Future<String?> getProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences.
    return prefs
        .getString(_profileUrlKey); // Retorna la URL del perfil del usuario.
  }
}
