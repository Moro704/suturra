import 'package:flutter/material.dart';

import 'package:sutura/core/appcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sutura/view/My/my_screen.dart';
import 'package:sutura/view/favori/favoris.dart';

import 'package:sutura/view/homme/homme_screen.dart';
import 'package:sutura/view/shopin/shopping_screen.dart';

class Hommeapp extends StatefulWidget {
  const Hommeapp({super.key});

  @override
  State<Hommeapp> createState() => _HommeappState();
}

class _HommeappState extends State<Hommeapp> {
  
  int index = 0;
  void select(int indexselect) {
    if (indexselect == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>PanierScreen()),
      );
    } else {
      setState(() {
        index = indexselect;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      // appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                label: "Accueil",
              ),
              // BottomNavigationBarItem(
              //   icon: FaIcon(FontAwesomeIcons.circlePlus),
              //   label: "Add",
              // ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bagShopping),
                label: "Panier",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.heart),                               
                label: "Favoris",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.circleUser),                               
                label: "Moi",
              ),
            ],
            currentIndex: index,
            onTap: select,
            enableFeedback: false,
            elevation: 8,
            backgroundColor: Appcolor.Secondecolor,

            // fixedColor: const Color.fromARGB(255, 247, 246, 246),
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
      body: [HommeScreen(), PanierScreen(), Favoris(), MyScreen()][index],
    );
  }
}
