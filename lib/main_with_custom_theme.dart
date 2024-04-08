import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color seedColor = Color(0xFFA74482);
  static const Color textColor = Color(0xFF693668);
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
        ),
      ),
      home: const TicTacToePage(
        player1Name: 'Topolino',
        player2Name: 'Paperino',
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
  State<TicTacToePage> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToePage> {
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
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '(${player1.sign}) ${player1.name}: ${player1.score}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      isPlayer1Turn ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                '(${player2.sign}) ${player2.name}: ${player2.score}',
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
              onTap: () => _tapped(0),
              child: TicTacToeBox(element: board.get(0)),
            ),
            GestureDetector(
              onTap: () => _tapped(1),
              child: TicTacToeBox(element: board.get(1)),
            ),
            GestureDetector(
              onTap: () => _tapped(2),
              child: TicTacToeBox(element: board.get(2)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _tapped(3),
              child: TicTacToeBox(element: board.get(3)),
            ),
            GestureDetector(
              onTap: () => _tapped(4),
              child: TicTacToeBox(element: board.get(4)),
            ),
            GestureDetector(
              onTap: () => _tapped(5),
              child: TicTacToeBox(element: board.get(5)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _tapped(6),
              child: TicTacToeBox(element: board.get(6)),
            ),
            GestureDetector(
              onTap: () => _tapped(7),
              child: TicTacToeBox(element: board.get(7)),
            ),
            GestureDetector(
              onTap: () => _tapped(8),
              child: TicTacToeBox(element: board.get(8)),
            ),
          ],
        ),
        const SizedBox(height: 36),
        ElevatedButton(
          onPressed: () => setState(() {
            board.clear();
          }),
          child: const Text('Pulisci board'),
        ),
        ElevatedButton(
          onPressed: _startNewGame,
          child: const Text('Nuova Partita'),
        ),
      ]),
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
        currentPlayer.score++;
        _showWinDialog(currentPlayer);
        return;
      }

      if (board.isBoardFull()) {
        _showDrawDialog();
      }
    });
  }

  void _showWinDialog(Player winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('${winner.name} (${winner.sign}) ha vinto!!!'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Gioca ancora'),
          ),
        ],
      ),
    );
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

  void _startNewGame() {
    setState(() {
      board.clear();
      player1.score = 0;
      player2.score = 0;
    });
  }
}

class TicTacToeBox extends StatelessWidget {
  const TicTacToeBox({
    required this.element,
    super.key,
  });

  final String element;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(border: Border.all()),
      child: Center(child: Text(element)),
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
  List<String> board = ['', '', '', '', '', '', '', '', ''];

  String get(int index) {
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
