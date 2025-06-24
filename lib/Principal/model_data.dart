// === Dans model_data.dart ===
import 'package:cloud_firestore/cloud_firestore.dart';

class ModelData {
  String? id;
  String? userName;
  String? userImage;
  String? userId;
  String? nomArticle;
  String? descriptionArticle;
  int? prixArticle;
  String? categoryArticle;
  String? imageUrl;
  Timestamp? timestamp;

  // Constructeur modifié avec paramètres nommés optionnels
  ModelData({
    this.id, // Rendre id optionnel
    this.userId,
    this.userName,
    this.userImage,
    this.nomArticle,
    this.descriptionArticle,
    this.prixArticle,
    this.categoryArticle,
    this.imageUrl,
    this.timestamp,
  });

  // Méthode modelMap() corrigée
  Map<String, dynamic> modelMap() {
    return {
      // Ne pas inclure id ici pour les nouveaux documents
      "userId": this.userId,
      "userName": this.userName,
      "userImage": this.userImage,
      "nomArticle": this.nomArticle,
      "DescriptionArticle": this.descriptionArticle,
      "PrixArticle": this.prixArticle,
      "categoryArticle": this.categoryArticle,
      "imageUrl": this.imageUrl,
      "timestamp": this.timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory ModelData.fromMap(Map<String, dynamic> data) {
    return ModelData(
      id: data['id'],
      userId: data['idUser'],
      userName: data['userName'],
      userImage: data['userImage'],
      nomArticle: data['nomArticle'],
      descriptionArticle: data['DescriptionArticle'],
      prixArticle: data['PrixArticle'],
      categoryArticle: data['categoryArticle'],
      imageUrl: data['imageUrl'],
      timestamp: data['timestamp'],
    );
  }
}
