import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sutura/view/homme/hommeApp.dart';
// 'package:sutura/view/homme/homme_screen.dart';
import 'package:sutura/view/login/login.dart';

class Choix extends StatelessWidget {
  const Choix({super.key});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return _user==null ? Login():Hommeapp();
  }
}
