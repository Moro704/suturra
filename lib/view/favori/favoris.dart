import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sutura/Principal/model_data.dart';
import 'package:sutura/service/database_service.dart';
import 'package:sutura/view/homme/articleview.dart';
import 'package:sutura/view/homme/user_Article.dart';

class Favoris extends StatefulWidget {
  const Favoris({super.key});

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: 
      Text("Favoris")),
      body: Center(
        child: StreamBuilder<List<ModelData>>(
          stream: DatabaseService().userFavoritesRef(userId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Erreur de chargement des favoris"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Aucun favori trouvé"));
            }
            final favoris = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 1,
                childAspectRatio: 0.68, // ← Ratio largeur/hauteur ajusté
              ),
              itemCount: favoris.length,
              itemBuilder: (context, index) {
                final Mesfavoris = favoris[index];
                return Container(
                  margin: EdgeInsets.only(left: 9, right: 9, bottom: 30, top: 1),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: const Color.fromARGB(255, 32, 31, 31)),),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Articleview(
                                          id: Mesfavoris.id ?? '',
                                          ImageArticle: Mesfavoris.imageUrl ?? '',
                                          NameArticle:
                                              Mesfavoris.nomArticle ?? '',
                                          DescriptionArticle:
                                              Mesfavoris.descriptionArticle ?? '',
                                          PriceArticle:
                                              Mesfavoris.prixArticle ?? 0,
                                          fournisseurId: Mesfavoris.userId ?? '',
                                          fournisseurName:
                                              Mesfavoris.userId ?? '',
                                        ),
                                  ),
                                );
                              },
                              child: AspectRatio(
                                aspectRatio: 0.85,
                                child:
                                    Mesfavoris.imageUrl != null
                                        ? Container(
                                          color: Colors.black,
                                          child: Image.network(
                                            Mesfavoris.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) => const Icon(
                                                  Icons.broken_image,
                                                ),
                                          ),
                                        )
                                        : const Placeholder(),
                              ),
                            ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: StreamBuilder<bool>(
                                    stream: DatabaseService().isFavorite(Mesfavoris.id!, userId),
                                    builder: (context, snapshot) {
                                      final isFavorite = snapshot.data ?? false;
                                      return IconButton(
                                        icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async{
                                   await DatabaseService().toggleFavorite(
                                      ModelData(
                                        id: Mesfavoris.id,
                                        imageUrl: Mesfavoris.imageUrl,
                                        nomArticle: Mesfavoris.nomArticle,
                                        descriptionArticle: Mesfavoris.descriptionArticle,
                                        prixArticle: Mesfavoris.prixArticle,
                                        userId: Mesfavoris.userId,
                                        userName: Mesfavoris.userName,
                                        userImage: Mesfavoris.userImage,
                                        searchKeywords: Mesfavoris.searchKeywords, // Pass the required argument
                                      ),
                                      isFavorite,
                                      userId
                                    );
                                  },
                                );
                              },
                            ),
                                ),
                            Positioned(
                              bottom: 0.1,
                              left: .2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => UserArticle(
                                            fournisseurId:
                                                Mesfavoris.userId ?? '',
                                            fournisseurName:
                                                Mesfavoris.userName ?? '',
                                          ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        Mesfavoris.userImage!,
                                      ),
                                    ),
        
                                    SizedBox(width: 5),
                                    Text(
                                      Mesfavoris.userName ??
                                          "Fournisseur inconnu",
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 247, 248, 248),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
        
                      // Partie texte - prend 25% de l'espace
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Mesfavoris.nomArticle ?? "Nom inconnu",
                            //  overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
        
                          Container(
                            //  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.black87,
                            ),
                            child: Text(
                              "${Mesfavoris.prixArticle?.toStringAsFixed(2) ?? '0.00'} F",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
