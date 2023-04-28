import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xo/firebase_options.dart';
import 'package:xo/page/scoreboard.dart';
import 'package:xo/page/welcome_page.dart';
import 'package:xo/page/create_page.dart';
import 'package:xo/page/join_page.dart';
import 'package:xo/page/lounge.dart';
import 'package:xo/page/game_page.dart';
import 'package:xo/page/scoreboard.dart';
//import 'package:xo/resources/socket_methods.dart';
//import 'package:xo/provider/tictactoe_board.dart';
//import 'package:xo/resources/socket_methods.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: const Color.fromRGBO(0, 0, 0, 1)),
      routes: {
        WelcomePage.routeName: (context) => const WelcomePage(),
        CreateRoom.routeName: (context) => const CreateRoom(),
        JoinRoom.routeName: (context) => const JoinRoom(),
        Lounge.routeName: (context) => const Lounge(),
        Scoreboard.routeName: (context) => const Scoreboard(),
      },
      initialRoute: WelcomePage.routeName,
    );
  }
}
