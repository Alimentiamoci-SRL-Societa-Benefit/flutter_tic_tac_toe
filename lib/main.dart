import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color seedColor = Color(0xFF668A2D);
  static const Color textColor = Color(0xFF385A11);
  static const Color onSeedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          onPrimary: onSeedColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: textColor),
          bodyLarge: TextStyle(color: textColor),
          displaySmall: TextStyle(color: textColor),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tic Tac Toe',
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 30),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Giocatore 1',
                    labelStyle: Theme.of(context).textTheme.bodyMedium),
                controller: player1Controller,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Giocatore 2',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                controller: player2Controller,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (context) => TicTacToePage(
                      player1Name: player1Controller.value.text,
                      player2Name: player2Controller.value.text,
                    ),
                  ));
                },
                child: const Text('Inizia la partita!'),
              ),
            ],
          ),
        ),
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
  GameBoard board = GameBoard();

  @override
  void initState() {
    player1 = Player(name: widget.player1Name, sign: 'X', score: 0);
    player2 = Player(name: widget.player2Name, sign: 'O', score: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "(${player1.sign}) ${player1.name}: ${player1.score}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isPlayer1Turn ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  "(${player2.sign}) ${player2.name}: ${player2.score}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        !isPlayer1Turn ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(0)),
                onTap: () => _tapped(0),
              ),
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(1)),
                onTap: () => _tapped(1),
              ),
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(2)),
                onTap: () => _tapped(2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(3)),
                onTap: () => _tapped(3),
              ),
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(4)),
                onTap: () => _tapped(4),
              ),
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(5)),
                onTap: () => _tapped(5),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(6)),
                onTap: () => _tapped(6),
              ),
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(7)),
                onTap: () => _tapped(7),
              ),
              GestureDetector(
                child: TicTacToeBox(element: board.elementAt(8)),
                onTap: () => _tapped(8),
              ),
            ],
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: _clearBoard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Pulisci board",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startNewGame,
            child: const Text("Nuova partita"),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      final currentPlayer = isPlayer1Turn ? player1 : player2;

      if (!board.set(player: currentPlayer, index: index)) {
        return;
      }
      isPlayer1Turn = !isPlayer1Turn;

      if (board.playerHasWon(currentPlayer)) {
        _showWinDialog(currentPlayer);
        currentPlayer.score++;
        return;
      }

      if (board.isBoardFull()) {
        _showDrawDialog();
      }
    });
  }

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pareggio!'),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Gioca ancora'))
            ],
          );
        });
  }

  void _showWinDialog(Player winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${winner.name} (${winner.sign}) ha vinto!!!"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Gioca ancora'))
            ],
          );
        });
  }

  void _clearBoard() {
    setState(() {
      board.clear();
    });
  }

  void _startNewGame() {
    _clearBoard();

    setState(() {
      player1.score = 0;
      player2.score = 0;
    });
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
      decoration: BoxDecoration(border: Border.all()),
      child: Center(
        child: Text(
          element,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 35),
        ),
      ),
    );
  }
}

class Player {
  Player({
    required this.name,
    required this.sign,
    this.score = 0,
  });

  final String name;
  final String sign;
  int score;
}

class GameBoard {
  GameBoard();

  List<String> board = ['', '', '', '', '', '', '', '', ''];

  String elementAt(int index) {
    return board[index];
  }

  bool set({required Player player, required int index}) {
    if (board[index] != '') {
      return false;
    }
    board[index] = player.sign;
    return true;
  }

  void clear() {
    for (var i = 0; i < board.length; i++) {
      board[i] = '';
    }
  }

  bool playerHasWon(Player player) {
    final sign = player.sign;

    if (board[0] == board[1] && board[0] == board[2] && board[0] == sign) {
      return true;
    }
    if (board[3] == board[4] && board[3] == board[5] && board[3] == sign) {
      return true;
    }
    if (board[6] == board[7] && board[6] == board[8] && board[6] == sign) {
      return true;
    }
    if (board[0] == board[3] && board[0] == board[6] && board[0] == sign) {
      return true;
    }
    if (board[1] == board[4] && board[1] == board[7] && board[1] == sign) {
      return true;
    }
    if (board[2] == board[5] && board[2] == board[8] && board[2] == sign) {
      return true;
    }
    if (board[0] == board[4] && board[0] == board[8] && board[0] == sign) {
      return true;
    }
    if (board[2] == board[4] && board[2] == board[6] && board[2] == sign) {
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    return board.every((element) => element != '');
  }
}
