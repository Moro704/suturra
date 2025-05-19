import 'package:flutter/material.dart';
import 'package:sutura/view/homme/core/appcolor.dart';
import 'package:sutura/view/homme/hommeApp.dart';
import 'package:sutura/view/login/singUp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool visiblePassword = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    void visible() {
      setState(() {
        visiblePassword = !visiblePassword;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(flex: 4, child: Container(color: Appcolor.Primarycolor)),
              Expanded(
                flex: 6,
                child: Container(
                  width: width,
                  color: Appcolor.Secondecolor,

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 215),
                        Text(
                          "ou",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Center(
                                child: Image.asset(
                                  "assets/google.png",
                                  width: 34,
                                  height: 34,
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage("assets/facebook.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.17,

            left: width - 340,
            right: width - 340,
            child: Container(
              width: width * 0.7,
              height: height * 0.45,
              decoration: BoxDecoration(
               color:  Appcolor.PositionedColor,
               borderRadius: BorderRadius.circular(18)

              ),
              child: SingleChildScrollView(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 35),
                        TextField(
                          controller: controllerEmail,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Entrez votre email",
                            label: Text("Email"),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ), // Bord normal
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: controllerPassword,
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
                            backgroundColor: Color(0xFF251058),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(),
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Hommeapp(),
                              ),
                            );
                          },
                          child: Text("Connectez"),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Vous n'avez pas de compte?"),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Singup(),
                                  ),
                                );
                              },
                              child: Text(
                                "S'Incrirer",
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
