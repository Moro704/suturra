import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';

import 'package:sutura/service/database_service.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
     User? user = FirebaseAuth.instance.currentUser;
       final userid = FirebaseAuth.instance.currentUser?.uid;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        body:SafeArea(
          child: Column(
            children: [
              // Nouvelle partie : infos utilisateur AU-DESSUS du TabBar
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ListTile(
                  leading: ClipOval(
                    child: CircleAvatar(
                      radius: 30,
                     child: user?.photoURL != null
                          ? Image.network(user!.photoURL!)
                          : const Icon(Icons.person, size: 50, color: Colors.grey
                    ),
                  ),),
                  title: Text(user?.displayName ?? 'Utilisateur'),
                  subtitle: Text(user?.email ?? 'Email non disponible'),
                  
                  onTap: () {},
                ),
              ),
            SizedBox(
              height: 25,
              width: MediaQuery.of(context).size.width*0.6,
                child: FloatingActionButton(
                             
                  onPressed: () {
                    // Action pour changer de rôle
                  },
                  child: const Text("Modifier le Rôle d'Utilisateur",style: TextStyle(fontSize: 11,color: Color.fromARGB(255, 3, 3, 3)),),
                ),
              ),
              const Divider(),
          
              // TabBar déplacé ici (dans le body)
              const Material(
                color: Colors.transparent,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'Commande'),  
                    Tab(text: 'Commande traiter'),
                
                  ],
                ),
              ),
          
              // Contenu des onglets
              Expanded(
              
                child: TabBarView(
                  children: [
                     StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance
        .collection('commande')
        .where('clientId', isEqualTo:  userid)
        .orderBy('date', descending: true)
        .snapshots(),
                      
             
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final commandes = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: commandes.length,
                          itemBuilder: (context, index) {
                            final commande = commandes[index];
                            return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
                Text(
  "Commande ${commande['numeroCommande'] ?? 'N/A'}",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
                Text(
  "Phone-fournisseur: ${commande['clientPhone'] ?? 'N/A'}",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),


            ],),
            const SizedBox(height: 10),

    
           ...((commande['items'] ?? []) as List)
                .map((item) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item['imageUrl']),
                  ),
                  title: Text(item['name'] ?? 'Article'),
                  subtitle: Text("Prix: ${item['price']} FCFA - Quantité: ${item['quantity']}"),
                )),

           Divider(),
            Container(
              color: const Color.fromARGB(255, 151, 39, 50),
              child: Center(child: Text("Total: ${commande['total']} FCFA",textAlign: TextAlign.center,))),
         


          ],
        ),
      ),
    );
                          },
                        );
                      },
                    ),
                     StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance
        .collection('commande')
        .where('clientId', isEqualTo: userid)
        .where('status', isEqualTo: 'terminée')
        .orderBy('date', descending: true)
        .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final commandes = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: commandes.length,
                          itemBuilder: (context, index) {
                            final commande = commandes[index];
                            return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
                Text(
  "Commande ${commande['numeroCommande'] ?? 'N/A'}",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),

            ],),
            

            // 🧾 Affichage de tous les articles
            ...((commande['items'] ?? []) as List)
                .map((item) => Column(
                  children: [
                    
  

                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item['imageUrl']),
                      ),
                      title: Text(item['name'] ?? 'Article'),
                      subtitle: Text("Prix: ${item['price']} FCFA - Quantité: ${item['quantity']}"),
                    ),
                  ],
                )),

            Divider(),
            Container(
              color: Colors.green[100],
              child: Center(child: Text("Total: ${commande['total']} FCFA"))),
         


          ],
        ),
      ),
    );
                          },
                        );
                      },
                    ),                   
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}