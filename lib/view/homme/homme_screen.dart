import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sutura/Principal/model_data.dart';
import 'package:sutura/Principal/model_homme.dart';
import 'package:sutura/core/appcolor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sutura/service/database_service.dart';
import 'package:sutura/view/homme/articlesuppliers.dart';
import 'package:sutura/view/homme/articleview.dart';

class HommeScreen extends StatefulWidget {
  const HommeScreen({super.key});

  @override
  State<HommeScreen> createState() => _HommeScreenState();
}

class _HommeScreenState extends State<HommeScreen> {
  List<String> imagesList = [
    'assets/carou_1.jpg',
    'assets/carou_2.jpg',
    //'assets/carou_3.jpg',
  ];
  List<ModelHomme> page_scrool = [
    ModelHomme(nom: "Autre", Image: "assets/HijabH.png"),
    ModelHomme(nom: "Hijab", Image: "assets/HijabH.png"),
    ModelHomme(nom: "Hijab", Image: "assets/mus_abaya.jfif"),
    ModelHomme(nom: "Hijab", Image: "assets/mus_homme.jpg"),
    ModelHomme(nom: "Hijab", Image: "assets/mus_autre.jpg"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: FaIcon(
            FontAwesomeIcons.alignLeft,
            color: Appcolor.Secondecolor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.commentDots,
              color: Appcolor.Secondecolor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.bell, color: Appcolor.Secondecolor),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            //height: 200,
            //width: double.infinity,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 100,
                //enlargeCenterPage: true,
                // aspectRatio: 10.0,
                viewportFraction: 0.99,
                autoPlay: true,
                autoPlayInterval: Duration(
                  seconds: 7,
                ), // Chaque image reste 5 sec
                autoPlayAnimationDuration: Duration(
                  seconds: 1,
                ), // Durée de transition
                autoPlayCurve: Curves.linear,
              ),
              items:
                  imagesList
                      .map(
                        (item) => Container(
                          margin: EdgeInsets.only(left: 6, right: 5),

                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: Image.asset(
                              item,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
            child: TextField(
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(95, 196, 193, 193),
                filled: true,
                hintText: "Rechercher",
                prefixIcon: Container(
                  margin: EdgeInsets.all(5),
                  color: Appcolor.Secondecolor,
                  child: Icon(Icons.search, color: Colors.white),
                ),
                suffixIcon: Icon(
                  Icons.filter_list,
                  color: Appcolor.Secondecolor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            flex: 2,
            child: ListView.builder(
              itemCount: page_scrool.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final Page = page_scrool[index];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      height: 50,
                      width: 50,
                      foregroundDecoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Image.asset(Page.Image),
                    ),
                    Text(Page.nom),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<List<ModelData>>(
              stream: DatabaseService().getArticle(),
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Articleview(),
                                    ),
                                  );
                                },
                                child: AspectRatio(
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
                              ),
                              Positioned(
                                bottom: 2,
                                left: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Articlesuppliers(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                     CircleAvatar(
  radius: 22,
  backgroundImage: NetworkImage(article.userImage!),
),

                                      SizedBox(width: 5),
                                      Text(
                                        article.userName ?? "Fournisseur inconnu",
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 247, 248, 248),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  
                                  ),
                                ))
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
          ),
        ],
      ),
    );
  }
}
