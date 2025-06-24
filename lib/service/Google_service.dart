import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 🔹 Étape 1 : Authentification Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔹 Étape 3 : Connexion avec Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // 🔹 Étape 4 : Enregistrement Firestore
        await _saveUserToFirestore(user);
      }

      return userCredential;
    } catch (e) {
      print("❌ Erreur Google Sign-In : $e");
      return null;
    }
  }

  /// 🔄 Enregistrer l'utilisateur dans Firestore
  Future<void> _saveUserToFirestore(User user) async {
    final docRef = _db.collection("users").doc(user.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        "uid": user.uid,
        "name": user.displayName ?? "Utilisateur Google",
        "email": user.email ?? "",
        "phone": "", // Google ne fournit pas de téléphone
        "image": user.photoURL ?? "",
        "provider": "google",
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("✅ Utilisateur Google enregistré dans Firestore.");
    } else {
      print("ℹ️ Utilisateur Google déjà présent dans Firestore.");
    }
  }
}
