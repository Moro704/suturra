import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutura/Principal/model_item.dart';
import 'package:sutura/service/panier_service.dart';

//import 'package:sutura/core/appcolor.dart' show Appcolor;

class Articleview extends StatefulWidget {
  final String id;
  final String ImageArticle;
  final String NameArticle;
  final String DescriptionArticle;
  final int PriceArticle;
  final String fournisseurId;
  final String fournisseurName;

  const Articleview({
    super.key,
    required this.id,
    required this.ImageArticle,
    required this.NameArticle,
    required this.DescriptionArticle,
    required this.PriceArticle,
    required this.fournisseurId,
    required this.fournisseurName,
  });

  @override
  State<Articleview> createState() => _ArticleviewState();
}

class _ArticleviewState extends State<Articleview> {
  List<String> couleurs = [
    "Noir",
    "Blanc Cassé",
    "Beige",
    "Gris",
    "Bleu Marine",
    "Vert Olive",
    "Bordeaux",
    "Mauve",
    "Doré",
    "Crème",
  ];
  String? couleurSelectionnee;
  TextEditingController quantiteController = TextEditingController();
  final List<String> tailles = ["S", "M", "L", "XL"];
  String tailleSelectionnee = "M";

  @override
  Widget build(BuildContext context) {
    final panier = Provider.of<PanierService>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  //  width: MediaQuery.of(context).size.width*0.7,
                  //  height: MediaQuery.of(context).size.height*0.7,
                  child: Image.network(widget.ImageArticle, fit: BoxFit.cover),
                ),

                // Flèche retour en haut à gauche

                // ],
              ),

              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black,
                        ),
                        child: Text(
                          widget.NameArticle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.11,
                        child: Center(
                          child: Text(
                            widget.DescriptionArticle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          //  color: Colors.black
                        ),
                        child: Text(
                          "Selectionner la Taille",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            tailles.map((taille) {
                              final bool estSelectionnee =
                                  taille == tailleSelectionnee;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tailleSelectionnee = taille;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        estSelectionnee
                                            ? const Color.fromARGB(
                                              255,
                                              15,
                                              15,
                                              15,
                                            )
                                            : const Color.fromARGB(
                                              255,
                                              228,
                                              221,
                                              221,
                                            ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          estSelectionnee
                                              ? const Color.fromARGB(
                                                255,
                                                8,
                                                8,
                                                8,
                                              )
                                              : const Color.fromARGB(
                                                0,
                                                255,
                                                255,
                                                255,
                                              ),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    taille,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          estSelectionnee
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quantité :"),
                              SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextField(
                                  controller: quantiteController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                    ), // facultatif
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Couleur :"),
                              SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DropdownButtonFormField(
                                  value: couleurSelectionnee,
                                  onChanged: (String? value) {
                                    setState(() {
                                      couleurSelectionnee = value;
                                    });
                                  },
                                  alignment: Alignment.center,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                  items:
                                      couleurs
                                          .map(
                                            (toElement) => DropdownMenuItem(
                                              value: toElement,
                                              child: Text(toElement),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black,
                        ),
                        child: Text(
                          "Prix: ${widget.PriceArticle}F unites",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        //color: const Color.fromARGB(255, 241, 137, 129),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 30,
                              color: const Color.fromARGB(255, 106, 15, 167),
                            ),
                            //SizedBox(width: 10,),
                            Icon(
                              Icons.message,
                              size: 30,
                              color: const Color.fromARGB(255, 106, 15, 167),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  106,
                                  15,
                                  167,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),

                              onPressed: () async {
                                await panier.addToCart(
                                  CardModel(
                                    id: widget.id,
                                    name: widget.NameArticle,
                                    imageUrl: widget.ImageArticle,
                                    price: widget.PriceArticle.toDouble(),
                                    quantity: int.parse(
                                      quantiteController.text,
                                    ),
                                    couleur: couleurSelectionnee!,
                                    taille: tailleSelectionnee,
                                    fournisseurId: widget.fournisseurId,
                                    fournisseurName: widget.fournisseurName,
                             
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Valider",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 30, // ajuste selon besoin (ex : pour éviter l'encoche)
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: const Color.fromARGB(255, 106, 15, 167),
              ),
              onPressed: () {
                Navigator.pop(context); // pour revenir à la page précédente
              },
            ),
          ),
        ],
      ),
    );
  }
}
