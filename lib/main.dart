import 'package:barcode_scanner/models/shop.dart';
import 'package:barcode_scanner/pages/auth_page.dart';
import 'package:barcode_scanner/pages/barcode_scanner.dart';
import 'package:barcode_scanner/pages/login_page.dart';
import 'package:barcode_scanner/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => SustainableShop(),
      builder: (context, child) => const MaterialApp(
        home: AuthPage(),
      ),
    );
  }
}