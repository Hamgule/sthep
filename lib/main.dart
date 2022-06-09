import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase_options.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/sthep.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Materials()),
        ChangeNotifierProvider(create: (_) => SthepUser()),
      ],
      child: const Sthep(),
    ),
  );

  // Categories c = Categories();
  // await c.loadJson();
  // c.toMap();
  // print(c.find('공학'));
  // print(c.next('대학>자연과학계열>생활과학'));

  // Exp e = Exp();
  // print(e.totalValue);
  // print(e.level);
  // print(e.value);
  // print(e.exp);

}