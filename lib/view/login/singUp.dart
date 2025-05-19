import 'package:flutter/material.dart';
import 'package:sutura/view/homme/core/appcolor.dart';
import 'package:sutura/view/login/login.dart';
import 'package:sutura/view/widget/login_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    void visible() {
      setState(() {
        visiblePassword = !visiblePassword;
      });
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: Container(color: Appcolor.Primarycolor)),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Appcolor.Secondecolor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Form(
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
                            suffixIcon:IconButton(
                              onPressed: visible,
                               icon:  visiblePassword == true
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),),
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

                          onPressed: () {},
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
