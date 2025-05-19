import 'package:flutter/material.dart';

Widget LoginWidget (TextEditingController control,String  LabelText, IconData icone,String hintText ){
  
    return TextField(
      controller: control,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
         borderSide: BorderSide(
         color: Colors.white,
          ), // Bord normal
          borderRadius: BorderRadius.circular(10),
                            ),
        label: Text(LabelText),
        hintText: hintText,
         fillColor: Colors.white,
         filled: true,
        prefixIcon: Icon(icone),
      ),
      
    );
  }

