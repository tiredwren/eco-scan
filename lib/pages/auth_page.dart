import 'package:barcode_scanner/pages/home.dart';
import 'package:barcode_scanner/pages/login_or_register.dart';
import 'package:barcode_scanner/pages/login_page.dart';
import 'package:barcode_scanner/pages/shop_page.dart';
import 'package:barcode_scanner/pages/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              }
              else {
                return LoginOrRegister();
              }
            }
        )
    );
  }
}