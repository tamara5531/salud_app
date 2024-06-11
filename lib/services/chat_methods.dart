import 'package:firebase_database/firebase_database.dart';
import 'package:medsal/helperFunction/sharedpref_helper.dart';

class ChatMethods {
  Future<void> addMessage({required String chatRoomId, required String message}) async {
    try {
      // add message to real time database
      await FirebaseDatabase.instance.ref('chats').child(chatRoomId).child('chat').push().set({
        'message': message,
        'timestamp': DateTime.now().toUtc().toString(),
        'sender': await SharedPreferenceHelper().getUserId(),
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
