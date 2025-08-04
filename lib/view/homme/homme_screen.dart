import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sutura/Principal/model_data.dart';
import 'package:sutura/Principal/model_homme.dart';
import 'package:sutura/core/appcolor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sutura/service/database_service.dart';
import 'package:sutura/view/add/add_sreen.dart';
import 'package:sutura/view/homme/articlesuppliers.dart';
import 'package:sutura/view/homme/articleview.dart';
import 'package:sutura/view/homme/drawer/apropospage.dart';
import 'package:sutura/view/homme/drawer/dasboard/dasboard.dart';
import 'package:sutura/view/homme/drawer/produit/article_fourniseur.dart';
import 'package:sutura/view/homme/recherche.dart';
import 'package:sutura/view/homme/user_Article.dart';

class HommeScreen extends StatefulWidget {
  const HommeScreen({super.key});

  @override
  State<HommeScreen> createState() => _HommeScreenState();
}

class _HommeScreenState extends State<HommeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> imagesList = [
    'assets/carou_1.jpg',
    'assets/carou_2.jpg',
    //'assets/carou_3.jpg',
  ];
  List<ModelHomme> page_scrool = [
    ModelHomme(nom: "tout", Image: "assets/HijabH.png"),
    ModelHomme(nom: "Hijab", Image: "assets/HijabH.png"),
    ModelHomme(nom: "Femme", Image: "assets/mus_abaya.jfif"),
    ModelHomme(nom: "Homme", Image: "assets/mus_homme.jpg"),
    ModelHomme(nom: "Autre", Image: "assets/mus_autre.jpg"),
  ];
    String selectedCategory="tout";
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Appcolor.Secondecolor),
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    "Sutura",
                    style: TextStyle(
                      fontSize: 40,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Appcolor.Primarycolor,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text('Dashboard'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarChartSample2(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text('Commande à traiter'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Articlesuppliers(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text('Produits'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FournisseurArticle(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.circlePlus),
                      title: Text('Ajouter un Produit'),
                      onTap: () {
                        Navigator.pop(context); // Ferme le drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddSreen()),
                        );
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.info_outline_rounded),
                      title: Text(' À propos'),
                      onTap: () {
                        Navigator.pop(context); // Ferme le drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AproposPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Déconnexion'),
                      onTap: () async {
                        // Déconnecte Google
                        await GoogleSignIn().signOut();

                        // Déconnecte Firebase
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            scaffoldKey.currentState?.openDrawer();
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
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
            child: ClipRect(
              child: TextField(
                keyboardType: null,
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleSearchScreen(),
                    ),
                  );
                },
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
          ),
          SizedBox(height: 10),
          Flexible(
            flex: 2,
            child: ListView.builder(
              itemCount: page_scrool.length,
              scrollDirection: Axis.horizontal,
              itemBuilder:
                  (context, index) => InkWell(
                    onTap: () {
  setState(() {
    selectedCategory = page_scrool[index].nom;
  });
},
       
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          height: 50,
                          width: 50,
                          foregroundDecoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Image.asset(page_scrool[index].Image),
                        ),
                        Text(page_scrool[index].nom),
                      ],
                    ),
                  ),
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<List<ModelData>>(
              stream:  selectedCategory == "tout"
    ? DatabaseService().getArticle()
    : DatabaseService().getArticleByCategory(selectedCategory),

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
                      margin: EdgeInsets.only(
                        left: 9,
                        right: 9,
                        bottom: 30,
                        top: 1,
                      ),
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
                                              id: articles[index].id ?? '',
                                              ImageArticle:
                                                  article.imageUrl ?? '',
                                              NameArticle:
                                                  article.nomArticle ?? '',
                                              DescriptionArticle:
                                                  article.descriptionArticle ??
                                                  '',
                                              PriceArticle:
                                                  article.prixArticle ?? 0,
                                              fournisseurId:
                                                  article.userId ?? '',
                                              fournisseurName:
                                                  article.userId ?? '',
                                            ),
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
                                  top: 2,
                                  right: 2,
                                  child: StreamBuilder<bool>(
                                    stream: DatabaseService().isFavorite(
                                      article.id!,
                                      userId,
                                    ),
                                    builder: (context, snapshot) {
                                      final isFavorite = snapshot.data ?? false;
                                      return IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await DatabaseService().toggleFavorite(
                                            ModelData(
                                              id: article.id,
                                              imageUrl: article.imageUrl,
                                              nomArticle: article.nomArticle,
                                              descriptionArticle:
                                                  article.descriptionArticle,
                                              prixArticle: article.prixArticle,
                                              userId: article.userId,
                                              userName: article.userName,
                                              userImage: article.userImage,
                                              searchKeywords:
                                                  article
                                                      .searchKeywords, // Ajout du paramètre requis
                                            ),
                                            isFavorite,
                                            userId,
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
                                                    article.userId ?? '',
                                                fournisseurName:
                                                    article.userName ?? '',
                                              ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            article.userImage!,
                                          ),
                                        ),

                                        SizedBox(width: 5),
                                        Text(
                                          article.userName ??
                                              "Fournisseur inconnu",
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              247,
                                              248,
                                              248,
                                            ),
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
                                article.nomArticle ?? "Nom inconnu",
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
                                  "${article.prixArticle?.toStringAsFixed(2) ?? '0.00'} F",
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
        ],
      ),
    );
  }
}
