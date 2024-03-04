import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToePage(
        player1Name: 'Pippo',
        player2Name: 'Topolino',
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({
    required this.player1Name,
    required this.player2Name,
    super.key,
  });

  final String player1Name;
  final String player2Name;

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  late Player player1;
  late Player player2;
  bool isPlayer1Turn = true;
  int player1Score = 0;
  int player2Score = 0;
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int filledBoxes = 0;

  @override
  void initState() {
    player1 = Player(name: widget.player1Name, sign: 'X');
    player2 = Player(name: widget.player2Name, sign: 'O');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  player1.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "= $player1Score",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  player2.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "= $player2Score",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TicTacToeBox(element: displayElement[0]),
                onTap: () => _tapped(0),
              ),
              GestureDetector(
                child: TicTacToeBox(element: displayElement[1]),
                onTap: () => _tapped(1),
              ),
              GestureDetector(
                child: TicTacToeBox(element: displayElement[2]),
                onTap: () => _tapped(2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TicTacToeBox(element: displayElement[3]),
                onTap: () => _tapped(3),
              ),
              GestureDetector(
                child: TicTacToeBox(element: displayElement[4]),
                onTap: () => _tapped(4),
              ),
              GestureDetector(
                child: TicTacToeBox(element: displayElement[5]),
                onTap: () => _tapped(5),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TicTacToeBox(element: displayElement[6]),
                onTap: () => _tapped(6),
              ),
              GestureDetector(
                child: TicTacToeBox(element: displayElement[7]),
                onTap: () => _tapped(7),
              ),
              GestureDetector(
                child: TicTacToeBox(element: displayElement[8]),
                onTap: () => _tapped(8),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _clearBoard,
            child: const Text("Clear Board"),
          ),
          ElevatedButton(
            onPressed: _clearScore,
            child: const Text("Clear Score"),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (isPlayer1Turn && displayElement[index] == '') {
        displayElement[index] = player1.sign;
        filledBoxes++;
      } else if (!isPlayer1Turn && displayElement[index] == '') {
        displayElement[index] = player2.sign;
        filledBoxes++;
      }

      isPlayer1Turn = !isPlayer1Turn;
      _checkWinner();
    });
  }

  void _checkWinner() {
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

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Draw"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play Again'))
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

  void _clearScore() {
    _clearBoard();

    setState(() {
      player2Score = 0;
      player1Score = 0;
    });
  }

  void _showWinDialog(String winnerSign) {
    String winnerName =
        winnerSign == player1.sign ? player1.name : player2.name;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("$winnerName ($winnerSign) is winner!!!"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play Again'))
            ],
          );
        });
    if (winnerSign == player1.sign) {
      player1Score++;
    } else if (winnerSign == player2.sign) {
      player2Score++;
    }
  }
}

class TicTacToeBox extends StatelessWidget {
  const TicTacToeBox({
    super.key,
    required this.element,
  });

  final String element;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Center(
        child: Text(
          element,
          style: const TextStyle(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }
}

class Player {
  const Player({
    required this.name,
    required this.sign,
  });

  final String name;
  final String sign;
}
