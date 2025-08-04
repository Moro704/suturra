import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sutura/Principal/model_data.dart';
import 'package:sutura/core/appcolor.dart';
import 'package:sutura/service/database_service.dart';

class AddSreen extends StatefulWidget {
  const AddSreen({super.key});

  @override
  State<AddSreen> createState() => _AddSreenState();
}
List<String> _generateSearchKeywords(String nomArticle, String userName) {
  final keywords = <String>[];
  
  // Ajoute les versions complètes
  keywords.add(nomArticle.toLowerCase());
  keywords.add(userName.toLowerCase());
  
  // Décompose en parties pour les recherches partielles
  keywords.addAll(nomArticle.toLowerCase().split(' '));
  keywords.addAll(userName.toLowerCase().split(' '));
  
  // Filtre les chaînes vides
  return keywords.where((k) => k.isNotEmpty).toSet().toList();
}

class _AddSreenState extends State<AddSreen> {
  //  Déclaration des controllers
  late TextEditingController nomArctilceController;
  late TextEditingController descArctilceController;
  late TextEditingController prixArctilceController;
  late TextEditingController catArctilceController;

  File? imageFiles;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nomArctilceController = TextEditingController();
    descArctilceController = TextEditingController();
    prixArctilceController = TextEditingController();
    catArctilceController = TextEditingController();
  }

  @override
  void dispose() {
    nomArctilceController.dispose();
    descArctilceController.dispose();
    prixArctilceController.dispose();
    catArctilceController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    XFile? _filepicker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (_filepicker != null) {
      setState(() {
        imageFiles = File(_filepicker.path);
      });
    }
  }

  Future<void> enregistrerProduit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ Aucun utilisateur connecté.");
      return;
    }

    if (nomArctilceController.text.trim().isEmpty ||
        descArctilceController.text.trim().isEmpty ||
        prixArctilceController.text.trim().isEmpty ||
        catArctilceController.text.trim().isEmpty ||
        imageFiles == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    int? prix = int.tryParse(prixArctilceController.text.trim());
    if (prix == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le prix doit être un nombre")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    final docRef = FirebaseFirestore.instance.collection('articles').doc();
    try {
      final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

      final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
      String imageurl = await DatabaseService().uploodimage(imageFiles);
      final userData = userDoc.data();

      await DatabaseService().serviceData(
        ModelData(
          id:docRef.id , // Laisser id à null pour un nouvel article
         userId: userId,
          userName: userData?['name'] ?? "Nom inconnu",
          userImage: (userData != null && userData['image'] != null && userData['image'].toString().isNotEmpty)
  ? userData['image']
  : (user?.photoURL ?? "https://ton_image_par_defaut.png"),
          nomArticle: nomArctilceController.text.trim(),
          descriptionArticle: descArctilceController.text.trim(),
          prixArticle: prix,
          categoryArticle: catArctilceController.text,
          imageUrl: imageurl,
          searchKeywords: _generateSearchKeywords(
      nomArctilceController.text.trim(),
      userData?['name'] ?? "Nom inconnu"
    ),
        ),
      );
      

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Retour après ajout
    } catch (e) {
      print("Erreur lors de l'enregistrement : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 350,
                color: Colors.grey[300],
                child: imageFiles == null
                    ? Center(
                        child: Text(
                          "Image Article",
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    : Image.file(imageFiles!, fit: BoxFit.cover),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Appcolor.Secondecolor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    // 🔤 Nom
                    TextField(
                      controller: nomArctilceController,
                      style: TextStyle(fontSize: 16),
                      decoration: _inputDecoration("Nom du produit"),
                    ),
                    SizedBox(height: 20),
                    // 🔽 Catégorie
                    DropdownButtonFormField<String>(
                      value: catArctilceController.text.isNotEmpty
                          ? catArctilceController.text
                          : null,
                      decoration: _inputDecoration("Catégorie du produit"),
                      items: ["Femme", "Homme", "Autres", "Hijab", "Abaya"]
                          .map((categorie) => DropdownMenuItem(
                                value: categorie,
                                child: Text(categorie),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          catArctilceController.text = val;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    // 📝 Description
                    TextFormField(
                      controller: descArctilceController,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      style: TextStyle(fontSize: 16),
                      decoration: _inputDecoration("Description du produit")
                          .copyWith(fillColor: Color.fromARGB(255, 235, 232, 232)),
                    ),
                    SizedBox(height: 20),
                    // 💰 Prix
                    TextField(
                      controller: prixArctilceController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                      decoration: _inputDecoration("Prix du produit"),
                    ),
                    SizedBox(height: 38),
                    // 📦 Boutons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: _buttonStyle(const Color.fromARGB(255, 153, 30, 30)),
                            child: Text("Annuler"),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextButton(
                            onPressed: isLoading ? null : enregistrerProduit,
                            style: _buttonStyle(const Color.fromARGB(255, 153, 30, 30)),
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("Enregistrer"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Méthodes utilitaires pour éviter la répétition
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return TextButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
