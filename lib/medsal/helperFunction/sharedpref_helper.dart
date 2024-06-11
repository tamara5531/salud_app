import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Método para obtener el ID de usuario almacenado en SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Método para guardar el ID de usuario en SharedPreferences
  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Método para eliminar el ID de usuario de SharedPreferences
  Future<void> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
