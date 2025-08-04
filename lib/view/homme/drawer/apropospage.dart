import 'package:flutter/material.dart';

class AproposPage extends StatelessWidget {
  const AproposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
        
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
             
            SizedBox(height: 20),
            Column(
              children: [
                 Text(
              "Cette application e-commerce a été créée pour offrir une expérience simple et rapide d’achat en ligne. "
              "Elle vous permet de parcourir les produits, passer des commandes, et suivre vos livraison.",
              style: TextStyle(fontSize: 16),
            ),
                Icon(Icons.verified, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text("Développeur", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Moro ", style: TextStyle(fontSize: 16)),
            Text("Contactez nous sur", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("74 66 08 26 ", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Version", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("1.0.0", style: TextStyle(fontSize: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }
}