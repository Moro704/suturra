import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sutura/Principal/model_data.dart';

class DatabaseService {
  final docRef = FirebaseFirestore.instance.collection("Article").doc();

  // ignore: prefer_final_fields
  CollectionReference _reference = FirebaseFirestore.instance.collection(
    'Article',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Methode Pour ajouter une image;
  Future<String> uploodimage(xfile) async {
    final String safeFileName =
        "image_${DateTime.now().toIso8601String().replaceAll(":", "-")}.png";

    Reference ref = FirebaseStorage.instance.ref().child(
      "Article_Images/images_Article/$safeFileName",
    );

    UploadTask uploadTask = ref.putFile(xfile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
  // Methode  Pour ajouter un article

  Future<void> serviceData(ModelData model) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      if (userId == null) {
        print("❌ Aucun utilisateur connecté.");
        return;
      }
      final userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .get();

      final data = model.modelMap();
      if (userDoc.exists) {
        await docRef.set(data);
      }
    } catch (e) {
      print("Error adding article: $e");
      // Gérer l'erreur ici (SnackBar, etc.)
    }
  }

  //Methode pour recupére sur les Article sur Firebase
  Stream<List<ModelData>> getArticle() {
    final queryArticle =
        _reference.orderBy("timestamp", descending: true).snapshots();
    return queryArticle.map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => ModelData.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList(),
    );
  }
//Methode pour recupére sur les Article par categorie
Stream<List<ModelData>> getArticleByCategory(String category) {
  return FirebaseFirestore.instance
      .collection("Article")
      .where("categoryArticle", isEqualTo: category)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ModelData.fromMap(doc.data() as Map<String, dynamic>)).toList());
}

  Stream<List<ModelData>> getUserArticle(String fournisseurId) {
    final queryArticle =
        _reference.where("userId", isEqualTo: fournisseurId).snapshots();
    return queryArticle.map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => ModelData.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  // Methode pour ajouter du favoris
  addFavoris(ModelData model, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(model.id)
          .set(model.modelMap());
    } catch (e) {
      print("Error adding to favorites: $e");
      // Gérer l'erreur ici (SnackBar, etc.)
    }
  }

  // Methode pour ajouter du favoris
  Future<void> deleteFavoris(ModelData model, String userId) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(model.id);

    await docRef.delete();
  }

  Stream<List<ModelData>> userFavoritesRef(String userId) {
    final favoritesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites');
    final queryfavoris =
        favoritesRef.orderBy('timestamp', descending: true).snapshots();
    return queryfavoris.map(
      (snapshots) =>
          snapshots.docs.map((doc) => ModelData.fromMap(doc.data())).toList(),
    );
  }

  Stream<bool> isFavorite(String articleId, String userId) {
    if (userId.isEmpty) return Stream.value(false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(articleId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> toggleFavorite(
    ModelData item,
    bool isFavorite,
    String userId,
  ) async {
    if (isFavorite) {
      await deleteFavoris(item, userId);
    } else {
      await addFavoris(item, userId);
    }
  }

  // Methode pour recuper les  commandes par un utilisateur
  
  Stream<List<ModelData>> searchArticles(String query) {
  final normalizedQuery = query.toLowerCase().trim();
  
  if (normalizedQuery.isEmpty) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('articles') // Votre nom de collection
      .where('searchKeywords', arrayContains: normalizedQuery)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ModelData.fromMap(doc.data()))
          .toList());
}
}
