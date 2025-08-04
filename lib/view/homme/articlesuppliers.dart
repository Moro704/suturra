import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Articlesuppliers extends StatefulWidget {
  const Articlesuppliers({super.key});

  @override
  State<Articlesuppliers> createState() => _ArticlesuppliersState();
}

class _ArticlesuppliersState extends State<Articlesuppliers> {
  final user = FirebaseAuth.instance.currentUser;
  String? fournisseurId;

  @override
  void initState() {
    super.initState();
    fournisseurId = user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Articles de Fournisseur")),
      body:StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('commande').where( 'fournisseurId', isEqualTo: fournisseurId)
              .orderBy('date', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("Aucune commande trouvée.");
        }

        final commandes = snapshot.data!.docs;

        return ListView.builder(
  itemCount: commandes.length,
  itemBuilder: (context, index) {
    final data = commandes[index].data() as Map<String, dynamic>;
    final items = List<Map<String, dynamic>>.from(data['items']); // tous les articles

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
                Text(
  "Commande ${data['numeroCommande'] ?? 'N/A'}",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
Text(
  "Fournisseur : ${data['fournisseurName'] ?? 'Inconnu'}",
),
             Text(
  "Phone-fournisseur: ${data['clientPhone'] ?? 'N/A'}",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 1),
),

            ],),
            const SizedBox(height: 10),

            // 🧾 Affichage de tous les articles
            ...items.map((item) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item['imageUrl']),
              ),
              title: Text(item['name'] ?? 'Article'),
              subtitle: Text("Prix: ${item['price']} FCFA - Quantité: ${item['quantity']}"),
            )),

            Divider(),
            Text("Total: ${data['total']} FCFA"),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("Statut :"),
    DropdownButton<String>(
      value: data['status'],
      items: ['en attente', 'en cours', 'terminée']
          .map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              ))
          .toList(),
      onChanged: (newStatus) {
        if (newStatus != null) {
          FirebaseFirestore.instance
              .collection('commande')
              .doc(commandes[index].id)
              .update({'status': newStatus});
        }
      },
    ),
  ],
),

          ],
        ),
      ),
    );
  },
);
      },
    )
                 
    );
  }
}
