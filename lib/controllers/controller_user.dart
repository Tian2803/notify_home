import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getUserName() async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;

    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

    if (userDoc.exists) {
      final userName = userDoc.data()?['name'];
      return userName as String;
    }
    return null;
  } catch (e) {
    print('Error al obtener el nombre de usuario: $e');
    throw Exception(
        'No se pudo obtener el nombre del usuario.');
  }
}
