import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sutura/Principal/model_data.dart';
import 'package:sutura/service/database_service.dart';

class FournisseurArticle extends StatefulWidget {

  const FournisseurArticle({Key? key}) : super(key: key);


  @override
  State<FournisseurArticle> createState() => _FournisseurArticleState();
}

class _FournisseurArticleState extends State<FournisseurArticle> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Articles"),
        centerTitle: true,
      ),
      body:  StreamBuilder<List<ModelData>>(
        stream: DatabaseService().getUserArticle(userId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement des articles"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun article trouvé"));
          }
          final articles = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 1,
              childAspectRatio: 0.68, // ← Ratio largeur/hauteur ajusté
            ),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Container(
                margin: EdgeInsets.only(left: 6, right: 6, bottom: 6),
                // decoration: BoxDecoration(
                //   border: Border.all(color: const Color.fromARGB(255, 32, 31, 31)),),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 0.85,
                          child:
                              article.imageUrl != null
                                  ? Container(
                                    color: Colors.black,
                                    child: Image.network(
                                      article.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.broken_image,
                                          ),
                                    ),
                                  )
                                  : const Placeholder(),
                        ),
                       
                      ],
                    ),
      
                    // Partie texte - prend 25% de l'espace
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            article.nomArticle ?? "Nom inconnu",
                            //  overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color.fromARGB(255, 7, 7, 7),
                            ),
                            child: Text(
                              "${article.prixArticle?.toStringAsFixed(2) ?? '0.00'} F",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 254, 255, 254),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      );
    
  }
}