import 'package:flutter/material.dart';
//import 'package:sutura/core/appcolor.dart' show Appcolor;


class Articleview extends StatefulWidget {
  const Articleview({super.key});

  @override
  State<Articleview> createState() => _ArticleviewState();
}

class _ArticleviewState extends State<Articleview> {
  int x = 100000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          Column(
            children: [
            Expanded(
            flex: 5,
            child:  SizedBox(
            width: MediaQuery.of(context).size.width*0.78,
            height: MediaQuery.of(context).size.height*0.7,
            child: Image.asset(
              "assets/HijabH.png",
              fit: BoxFit.cover,
            ),
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
                          color: Colors.black
                        ),
                        child: Text(
                          "Hijab simple",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white, ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Consus pour allier sobriété, confort et respect des traditions, ce hijab simple est parfait pour un usage quotidien au Mali. Léger et respirant, il est adaptéaux haues températures tout en offrant une bonne couvrance. Disponible en plusieurs couleurs ',
                      
                        textAlign: TextAlign.start,
                        ),
                      ),
                       SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black
                        ),
                        child: Text(
                          "Selectionner la Taille",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 255, 255, 255)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                         SizedBox(height: 8),
                      
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ["S", "M", "L", "XL"].map((size) {
                          return Text(
                            size,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                width: 100,
                child: TextField(decoration: InputDecoration(border: OutlineInputBorder()),textAlign: TextAlign.center),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Couleur :"),
              SizedBox(
                 height: 30,
                width: 100,
                child:TextField(decoration: InputDecoration(border: OutlineInputBorder() ),textAlign: TextAlign.center,),
              ),
            ],
          ),
              ],
            ),
          
           SizedBox(height: 12,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black
                        ),
                        child: Text("Prix: ${x}F unites",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),),
                      ),
                      SizedBox(height: 12,),
                      Container(
                        //color: const Color.fromARGB(255, 241, 137, 129),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.favorite_border,size: 30,color:  const Color.fromARGB(255, 106, 15, 167)),  
                             //SizedBox(width: 10,),
                             Icon(Icons.message,size: 30,color:  const Color.fromARGB(255, 106, 15, 167)),
                              SizedBox(width: 10,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:  const Color.fromARGB(255, 106, 15, 167),
                                  padding: EdgeInsets.symmetric(horizontal: 25,vertical:8 ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)
                                  
                                )
                                ),
                                
                                onPressed: () {
                                
                              }, child:Text("Valider",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.white),))
                          ],
                        ),
                      )
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
                    icon: Icon(Icons.arrow_back, color:  const Color.fromARGB(255, 106, 15, 167)),
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
