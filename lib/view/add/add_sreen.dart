import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sutura/Principal/model_data.dart';
import 'package:sutura/service/database_service.dart';

class AddSreen extends StatefulWidget {
  const AddSreen({super.key});

  @override
  State<AddSreen> createState() => _AddSreenState();
}

class _AddSreenState extends State<AddSreen> {
  File? imageFiles;

  @override
  Widget build(BuildContext context) {
    TextEditingController nomArctilceController = TextEditingController();
    TextEditingController descArctilceController = TextEditingController();
    TextEditingController prixArctilceController = TextEditingController();
    TextEditingController catArctilceController = TextEditingController();
    final user = Provider.of<User?>(context);
    DatabaseService databaseService = DatabaseService();
    pickImage() async {
      XFile? _filepicker = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (_filepicker != null) {
        setState(() {
          imageFiles = File(_filepicker.path);
        });
      }
    }

    return Scaffold(
      //appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                pickImage();
              },
              child: Container(
                height: 50,
                width: 350,
                child:
                    imageFiles == null
                        ? Center(child: Text("image Article"))
                        : Image.file(imageFiles!, fit: BoxFit.cover),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 189, 183, 183),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nomArctilceController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            248,
                            246,
                            246,
                          ), // Couleur du texte saisi
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          hintText: "Nom du produit",
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),

                          fillColor: const Color.fromARGB(255, 8, 8, 8),
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: descArctilceController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            248,
                            246,
                            246,
                          ), // Couleur du texte saisi
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: "description du produit",
                          fillColor: const Color.fromARGB(255, 8, 8, 8),
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: prixArctilceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            248,
                            246,
                            246,
                          ), // Couleur du texte saisi
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: "Prix du produit",
                          fillColor: const Color.fromARGB(255, 8, 8, 8),
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: catArctilceController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          hintText: "Categorie du produit",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(color: Colors.deepPurple),
                                ),
                              ),
                              child: Text("Annuler"),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                          
                            child: TextButton(
                            onPressed: () async {
  User? user = FirebaseAuth.instance.currentUser;
   
  if (user == null) {
    print("❌ Aucun utilisateur connecté.");
    return;
  }

  // 🔽 Récupère nom et image depuis FirebaseAuth
  String userId = user.uid;
  String userName = user.displayName ?? "Nom inconnu";
  String userImage = user.photoURL ?? "";

  // 🔼 Uploader image article
  String imageurl = await databaseService.uploodimage(imageFiles);

  // 🔼 Ajouter l'article
  await databaseService.serviceData(
    ModelData(
      userId: userId,
      userName: userName,
      userImage: userImage,
      nomArticle: nomArctilceController.text.trim(),
      descriptionArticle: descArctilceController.text.trim(),
      prixArticle: int.tryParse(prixArctilceController.text.trim()),
      categoryArticle: catArctilceController.text,
      imageUrl: imageurl,
    ),
  );
},


                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(),
                              ),
                              child: Text("enregistrer"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
