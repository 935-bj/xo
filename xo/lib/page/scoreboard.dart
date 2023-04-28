import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xo/page/welcome_page.dart';
import 'package:xo/widgets/custom_textfield.dart';
import 'package:xo/widgets/custome_text.dart';
import 'package:xo/widgets/custom_buttom.dart';

class Scoreboard extends StatefulWidget {
  static const String routeName = '/scoreboard'; // define the routeName property
  const Scoreboard({Key? key}) : super(key: key);

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  late DatabaseReference _scoresRef;

bool oTurn = true;

// 1st player is O
List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
int xScore = 0;
int oScore = 0;
int filledBoxes = 0;

@override
void initState() {
  super.initState();
  _scoresRef = FirebaseDatabase.instance.ref('scores');
  _scoresRef.onValue.listen((event) {
    var snapshotValue = event.snapshot.value;
    if (snapshotValue != null) {
      var values = Map<String, dynamic>.from(snapshotValue as Map<dynamic, dynamic>);
      setState(() {
        xScore = values['x'] ?? 0;
        oScore = values['o'] ?? 0;
      });
    }
  });
}

  void _incrementScore(String player) {
    if (player == 'x') {
      _scoresRef.update({'x': xScore + 1});
    } else if (player == 'o') {
      _scoresRef.update({'o': oScore + 1});
    }
  }

@override
Widget build(BuildContext context) {
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
	backgroundColor: Colors.black,
	body: Column(
		children: <Widget>[
		Expanded(
			child: Container(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
				Padding(
					padding: const EdgeInsets.all(30.0),
					child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
            CustomText(
              text: 'Player 1',
              fontSize: 20,
            ),
						CustomText(
              text: xScore.toString(),
              fontSize: 20,
            ),
					],
					),
				),
				Padding(
					padding: const EdgeInsets.all(30.0),
					child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						CustomText(
              text: 'Player 2',
              fontSize: 20,
            ),
            CustomText(
              text: oScore.toString(),
              fontSize: 20,
            ),
					],
					),
				),
				],
			),
			),
		),
		Expanded(
			flex: 4,
			child: GridView.builder(
				itemCount: 9,
				gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
					crossAxisCount: 3),
				itemBuilder: (BuildContext context, int index) {
				return GestureDetector(
					onTap: () {
					_tapped(index);
					},
					child: Container(
					decoration: BoxDecoration(
						border: Border.all(color: Colors.white)),
					child: Center(
						child: Text(
						displayElement[index],
						style: TextStyle(color: Colors.white, fontSize: 85),
						),
					),
					),
				);
				}),
		),
		Expanded(
			child: Container(
			child: Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.black,
  ),
  onPressed: _clearScoreBoard,
  child: Text("Clear Score Board"),
),
			],
			),
		))
		],
	),
	);
}

void _tapped(int index) {
	setState(() {
	if (oTurn && displayElement[index] == '') {
		displayElement[index] = 'o';
		filledBoxes++;
	} else if (!oTurn && displayElement[index] == '') {
		displayElement[index] = 'x';
		filledBoxes++;
	}

	oTurn = !oTurn;
	_checkWinner();
	});
}

void _checkWinner() {
	
	// Checking rows
	if (displayElement[0] == displayElement[1] &&
		displayElement[0] == displayElement[2] &&
		displayElement[0] != '') {
	_showWinDialog(displayElement[0]);
	}
	if (displayElement[3] == displayElement[4] &&
		displayElement[3] == displayElement[5] &&
		displayElement[3] != '') {
	_showWinDialog(displayElement[3]);
	}
	if (displayElement[6] == displayElement[7] &&
		displayElement[6] == displayElement[8] &&
		displayElement[6] != '') {
	_showWinDialog(displayElement[6]);
	}

	// Checking Column
	if (displayElement[0] == displayElement[3] &&
		displayElement[0] == displayElement[6] &&
		displayElement[0] != '') {
	_showWinDialog(displayElement[0]);
	}
	if (displayElement[1] == displayElement[4] &&
		displayElement[1] == displayElement[7] &&
		displayElement[1] != '') {
	_showWinDialog(displayElement[1]);
	}
	if (displayElement[2] == displayElement[5] &&
		displayElement[2] == displayElement[8] &&
		displayElement[2] != '') {
	_showWinDialog(displayElement[2]);
	}

	// Checking Diagonal
	if (displayElement[0] == displayElement[4] &&
		displayElement[0] == displayElement[8] &&
		displayElement[0] != '') {
	_showWinDialog(displayElement[0]);
	}
	if (displayElement[2] == displayElement[4] &&
		displayElement[2] == displayElement[6] &&
		displayElement[2] != '') {
	_showWinDialog(displayElement[2]);
	} else if (filledBoxes == 9) {
	_showDrawDialog();
	}
}

void _showWinDialog(String winner) {
	showDialog(
		barrierDismissible: false,
		context: context,
		builder: (BuildContext context) {
		return AlertDialog(
			title: Text("\" " + winner + " \" is Winner!"),
			actions: [
			TextButton(
				child: Text("Play Again"),
				onPressed: () {
				_clearBoard();
				Navigator.of(context).pop();
				},
			),
      TextButton(
				child: Text("Finish the game"),
				onPressed: () {
				_clearBoard();
				Navigator.pushNamed(context, WelcomePage.routeName);
				},
			)
			],
		);
		});

	if (winner == 'o') {
	oScore++;
	} else if (winner == 'x') {
	xScore++;
	}
}

void _showDrawDialog() {
	showDialog(
		barrierDismissible: false,
		context: context,
		builder: (BuildContext context) {
		return AlertDialog(
			title: Text("Draw"),
			actions: [
			TextButton(
				child: Text("Play Again"),
				onPressed: () {
				_clearBoard();
				Navigator.of(context).pop();
				},
			),
      TextButton(
				child: Text("Finish the game"),
				onPressed: () {
				_clearBoard();
				Navigator.pushNamed(context, WelcomePage.routeName);
				},
			)
			],
		);
		});
}

void _clearBoard() {
	setState(() {
	for (int i = 0; i < 9; i++) {
		displayElement[i] = '';
	}
	});

	filledBoxes = 0;
}

void _clearScoreBoard() {
	setState(() {
	xScore = 0;
	oScore = 0;
	for (int i = 0; i < 9; i++) {
		displayElement[i] = '';
	}
	});
	filledBoxes = 0;
}
}