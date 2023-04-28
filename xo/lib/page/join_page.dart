import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:xo/page/create_page.dart';
import 'package:xo/page/scoreboard.dart';
import 'package:xo/widgets/custom_textfield.dart';
import 'package:xo/widgets/custome_text.dart';
import 'package:xo/widgets/custom_buttom.dart';

class JoinRoom extends StatefulWidget {
  static const String routeName = '/join-room';
  //const JoinRoom({super.key});
  const JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomIDController = TextEditingController();
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('games');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Image.asset(
            'image/logo.png',
            scale: 4,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(text: 'Join Room !', fontSize: 50),
            SizedBox(height: size.height * 0.05),
            CustomeTextField(
              controller: _nameController,
              hintText: 'Enter your Name',
            ),
            const SizedBox(height: 20),
            CustomeTextField(
              controller: _roomIDController,
              hintText: 'Enter Room ID',
            ),
            SizedBox(height: size.height * 0.01),
            CustomButton(
              onTap: () {
                final String roomID = _roomIDController.text.trim();
                if (roomID.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Room ID cannot be blank'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  dbRef
                      .orderByKey()
                      .equalTo(roomID)
                      .once()
                      .then((DatabaseEvent event) {
                    DataSnapshot snapshot = event.snapshot;

                    if (snapshot.value != null) {
                      // Room with the given ID exists
                      final String playerName = _nameController.text.trim();
                      if (playerName.isNotEmpty) {
                        // Add user to the room
                        dbRef.child(roomID).update({'user2': playerName});
                        dbRef.child(roomID).update({'counter': 2});

                        // Navigate to game screen
                        Navigator.pushNamed(context, Scoreboard.routeName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Player Name cannot be blank'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      // ID does not exist
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Room ID does not exist'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                }
              },
              text: 'Join',
            )
          ],
        ),
      ),
    );
  }
}