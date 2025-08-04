import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignupService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inscription
  Future<UserCredential?> Sign_up(
    String name,
    String email,
    String phone,
    String password,
    String imageurl,
  ) async {
    try {
      // 🔐 Création du compte utilisateur Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 🔁 Mise à jour du profil FirebaseAuth
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.updatePhotoURL(imageurl);
      await userCredential.user?.reload();

      // 🔥 Ajout dans Firestore sous document avec UID
      await saveUserToFirestore(userCredential.user!, name, email, phone, imageurl);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('❌ Cet email est déjà utilisé.');
      } 
      return null;
    }
  }

  // 🔄 Enregistrer l'utilisateur dans Firestore
  Future<void> saveUserToFirestore(User user, String name, String email, String phone, String imageurl) async {
    await db.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "name": name,
      "email": email,
      "phone": phone,
      "image": imageurl,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // Stream Auth
  Stream<User?> get user => _auth.authStateChanges();

  // Upload image
  Future<String> uploadImageUser(xfile) async {
    

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("users_images/image_user/${DateTime.now().toIso8601String()}");

    UploadTask uploadTask = ref.putFile(xfile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
   
}
