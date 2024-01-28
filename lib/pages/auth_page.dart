import 'package:barcode_scanner/pages/barcode_scanner.dart';
import 'package:barcode_scanner/pages/login_or_register.dart';
import 'package:barcode_scanner/pages/login_page.dart';
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
            return BarcodeScanner();

            //replace with home page (shop)

            }
          else {
            return LoginOrRegister();
          }
        }
      )
    );
  }
}