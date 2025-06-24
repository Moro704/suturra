import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sutura/core/appcolor.dart';
import 'package:sutura/service/SignUp_service.dart';
import 'package:sutura/view/login/login.dart';
import 'package:sutura/widget/login_widget.dart';

class Singup extends StatefulWidget {
  const Singup({super.key});

  @override
  State<Singup> createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  TextEditingController controlUser = TextEditingController();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlPhone = TextEditingController();
  TextEditingController controlPassword = TextEditingController();
  bool visiblePassword = false;
  File? _imageFile;
final SignupService signupService = SignupService();

  Future<void> _selectImageSource() async {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Prendre une photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Choisir depuis la galerie"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        // Utilisez le fichier sélectionné
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        print("Aucune image sélectionnée.");
      }
    } catch (e) {
      print("Erreur lors de la sélection de l'image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    void visible() {
      setState(() {
        visiblePassword = !visiblePassword;
      });
    }

    return Scaffold(
      appBar:AppBar(
        backgroundColor: Appcolor.Secondecolor,
        title: Text(
          "Inscription",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
        color: Appcolor.Secondecolor,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                     radius: 45,
                    child: GestureDetector(

                      onTap: () {
                        _selectImageSource();
                      },
                      child:
                          _imageFile == null
                              ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                              : ClipOval(
                                child: Image.file(
                                  _imageFile!,
                                  width: MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      LoginWidget(
                        controlUser,
                        "Nom",
                        Icons.person,
                        "Nom utilisateur",
                      ),
                      SizedBox(height: 20),
                      LoginWidget(
                        controlEmail,
                        "email",
                        Icons.email,
                        "votre email",
                      ),
                      SizedBox(height: 20),
                      LoginWidget(
                        controlPhone,
                        "phone",
                        Icons.phone_iphone_outlined,
                        "numero téléphone",
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: controlPassword,
                
                        obscureText: visiblePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: visible,
                            icon:
                                visiblePassword == true
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ), // Bord normal
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Entrez votre mot de passe",
                          label: Text("Password"),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 244, 245),
                          foregroundColor: const Color.fromARGB(
                            255,
                            12,
                            12,
                            12,
                          ),
                          shape: RoundedRectangleBorder(),
                        ),
                
                     onPressed: () async {
  if (_imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Veuillez sélectionner une image.")),
    );
    return;
  }

  try {
    // 📤 Upload image
    String imageurl = await signupService.uploadImageUser(_imageFile!);

    // 🔐 Appel à l'inscription
    final result = await signupService.Sign_up(
      controlUser.text.trim(),
      controlEmail.text.trim(),
      controlPhone.text.trim(),
      controlPassword.text,
      imageurl,
    );

    if (result != null) {
      // ✅ Succès - redirection ou message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inscription réussie ")),
      );

      // Redirige vers Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      // Échec
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'inscription ")),
      );
    }
  } catch (e) {
    //  Erreur inattendue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur : $e")),
    );
  }
},

                child: Text("VALIDE"),
              ),
              SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Conntez-vous ?",
                            style: TextStyle(color: Colors.white),
                          ),
                
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: Text(
                              "Connexion",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
