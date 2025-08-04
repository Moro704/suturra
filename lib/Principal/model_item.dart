class CardModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
   final int quantity;
  final String couleur;
  final String taille;
  final String fournisseurId;
  final String fournisseurName;
  

  CardModel({
    required this.id,
    required this.name,

    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.couleur,
    required this.taille,
    required this.fournisseurId,
    required this.fournisseurName,
  });
  CardModel copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? couleur,
    String? taille,
    String? fournisseurId,
    String? fournisseurName,
    bool? favoris,
  }) {
    return CardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      couleur: couleur ?? this.couleur,
      taille: taille ?? this.taille,
      fournisseurId: fournisseurId ?? this.fournisseurId,
      fournisseurName: fournisseurName ?? this.fournisseurName,

    );
  }
  Map<String, dynamic> modelMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'couleur': couleur,
      'taille': taille,
      'fournisseurId': fournisseurId,
      'fournisseurName': fournisseurName,
     
    };
    
  }
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
      couleur: map['couleur'] ?? '',
      taille: map['taille'] ?? '',
      fournisseurId: map['fournisseurId'] ?? '',
      fournisseurName: map['fournisseurName'] ?? '',
    );
  }
}
