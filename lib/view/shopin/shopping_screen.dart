import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutura/service/panier_service.dart';

class PanierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<PanierService>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Mon Panier")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (_, index) {
                final item = cart.cartItems[index];
                return ListTile(
                  leading: CircleAvatar(radius: 30,child: ClipOval(child: Image.network(item.imageUrl,
                   width: MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                  ))),
                  title: Text(item.name),
                  subtitle: Text("Quantité: ${item.quantity}"),
                  trailing: Text("${item.price * item.quantity} FCFA"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Total: ${cart.totalPrice} FCFA",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                ElevatedButton(
  onPressed: () {
    showPhoneNumberDialog(context, cart);
  },
  child: Text("Valider la commande"),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showPhoneNumberDialog(BuildContext context, PanierService cart) {
  final TextEditingController phoneController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Entrez votre numéro de téléphone"),
      content: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(hintText: "Numéro de téléphone"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // fermer sans valider
          child: Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () async {
            final phoneNumber = phoneController.text.trim();
            if (phoneNumber.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Veuillez saisir un numéro de téléphone.")),
              );
              return;
            }
            Navigator.pop(context); // fermer la boîte de dialogue
            await validerCommandeParFournisseur(context, cart, phoneNumber); // lancer la validation
          },
          child: Text("Valider"),
        ),
      ],
    ),
  );
}



Future<void> validerCommandeParFournisseur(BuildContext context, PanierService cart, String phoneNumber) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final commandesParFournisseur = cart.groupByFournisseur();
  try {
    for (var entry in commandesParFournisseur.entries) {
      final fournisseurId = entry.key;
      final items = entry.value;

      final compteurRef = FirebaseFirestore.instance
          .collection('compteurs_commandes')
          .doc(fournisseurId);

      final commandesRef = FirebaseFirestore.instance.collection('commande');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final compteurSnapshot = await transaction.get(compteurRef);

        int lastNumero = 0;                               
        if (compteurSnapshot.exists) {
          lastNumero = compteurSnapshot.data()?['dernierNumero'] ?? 0;
        }

        final newNumero = lastNumero + 1;
        final numeroCommande = 'CMD-${newNumero.toString().padLeft(4, '0')}';

        final commande = {
          'clientId': user.uid,
          'fournisseurId': fournisseurId,
          'clientPhone': phoneNumber,
          'items': items.map((e) => e.modelMap()).toList(),
          'total': items.fold<double>(0, (total, e) => total + (e.price * e.quantity)),
          'date': DateTime.now(), // stocké en Timestamp (mieux que string)
          'status': "en attente",
          'numeroCommande': numeroCommande,
        };

        transaction.set(commandesRef.doc(), commande);
        transaction.set(compteurRef, {'dernierNumero': newNumero});
      });
    }

    cart.clearCart();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Commandes envoyées par fournisseur.")),
    );

    if (!context.mounted) return;
    Navigator.pop(context);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur d'envoi des commandes.")),
    );
  }
}
