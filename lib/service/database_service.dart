import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sutura/Principal/model_data.dart';

class DatabaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  
  CollectionReference _reference = FirebaseFirestore.instance.collection(
    'Article',
  );
  // Methode Pour ajouter une image;
  Future<String> uploodimage(xfile) async {
    Reference ref = FirebaseStorage.instance
        .ref("")
        .child("Article_Images")
        .child("imgaes_Article/${DateTime.now()}.png");
    UploadTask uploadTask = ref.putFile(xfile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Methode  Pour ajouter un article

  Future<void> serviceData(ModelData model) async {
  try {
    final data = model.modelMap();
    await db.collection("Article").add(data);
  } catch (e) {
    print("Error adding article: $e");
    // Gérer l'erreur ici (SnackBar, etc.)
  }
}

  //Methode pour recupére sur les Article sur Firebase
  Stream<List<ModelData>> getArticle() {
    final queryArticle = _reference.orderBy("timestamp", descending: true).snapshots();
    return queryArticle.map((snapshot)=>
   snapshot.docs
          .map((doc) => ModelData.fromMap(doc.data() as Map<String, dynamic>))
          .toList());
  }
}
 