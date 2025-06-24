import 'package:firebase_auth/firebase_auth.dart';

class SinginService {
  
  Future<void> singIn(String email,String password) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
  await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
          if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

  }
}