import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutura/Principal/choix.dart';
import 'package:sutura/service/panier_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDLYPTRROUtO-FOq5mJdRuYmp6mouzPLWQ",
      appId: "1:732478796775:android:d26bdb72b8b277bb004342",
      messagingSenderId: "732478796775",
      projectId: "flutter-87598",
      storageBucket: "flutter-87598.appspot.com",
    ),
  );
//  await FirebaseAppCheck.instance.activate(
//     androidProvider: AndroidProvider.debug,
//     // Pour la production : AndroidProvider.playIntegrity
//   );
  runApp(
    MultiProvider(
      providers: [
       // StreamProvider.value(value: SignupService().user, initialData: null),
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: null, // L'utilisateur sera `null` si non connecté
        ),
        ChangeNotifierProvider(create: (_) => PanierService()),
    
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Choix(),
      },

      
    
    );
  }
}

