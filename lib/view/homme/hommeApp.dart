import 'package:flutter/material.dart';
import 'package:sutura/core/appcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sutura/view/My/my_screen.dart';
import 'package:sutura/view/add/add_sreen.dart';
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
        MaterialPageRoute(builder: (context) =>AddSreen()),
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
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.circlePlus),
                label: "Add",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bagShopping),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.circleUser),
                label: "Home",
              ),
            ],
            currentIndex: index,
            onTap: select,
            enableFeedback: false,
            elevation: 10,
            backgroundColor: Appcolor.Secondecolor,

            // fixedColor: const Color.fromARGB(255, 247, 246, 246),
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
      body: [HommeScreen(), ShoppingScreen(), MyScreen()][index],
    );
  }
}
