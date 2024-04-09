import 'package:flutter/material.dart';

// TODO: implementare un turno di gioco

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
        ),
        body: TicTacToePage(),
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  State<TicTacToePage> createState() {
    return TicTacToeState();
  }
}

class TicTacToeState extends State<TicTacToePage> {
  Player player1 = Player(name: 'Topolino', sign: 'X');
  Player player2 = Player(name: 'Paperino', sign: 'O');
  bool isPlayer1Turn = true;
  GameBoard board = GameBoard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 64),
        PlayerTurnWidget(currentPlayer: isPlayer1Turn ? player1 : player2),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeBox(sign: board.get(0)),
            TicTacToeBox(sign: board.get(1)),
            TicTacToeBox(sign: board.get(2)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeBox(sign: board.get(3)),
            TicTacToeBox(sign: board.get(4)),
            TicTacToeBox(sign: board.get(5)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeBox(sign: board.get(6)),
            TicTacToeBox(sign: board.get(7)),
            TicTacToeBox(sign: board.get(8)),
          ],
        ),
      ],
    );
  }
}

class PlayerTurnWidget extends StatelessWidget {
  const PlayerTurnWidget({
    required this.currentPlayer,
  });

  final Player currentPlayer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'E\' il turno di ${currentPlayer.name} (${currentPlayer.sign})',
      ),
    );
  }
}

class TicTacToeBox extends StatelessWidget {
  const TicTacToeBox({
    required this.sign,
    super.key,
  });

  final String sign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(border: Border.all()),
      child: Center(child: Text(sign)),
    );
  }
}

class Player {
  Player({
    required this.name,
    required this.sign,
  });

  final String name;
  final String sign;
}

class GameBoard {
  List<String> board = ['', '', '', '', '', '', '', '', ''];

  String get(int index) {
    return board[index];
  }

  void set({required Player player, required int index}) {
    board[index] = player.sign;
  }

  void clear() {
    for (var i = 0; i < board.length; i++) {
      board[i] = '';
    }
  }

  Player? getWinningPlayer({
    required Player player1,
    required Player player2,
  }) {
    const winningLines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (final line in winningLines) {
      var firstBoxSign = board[line[0]];
      var secondBoxSign = board[line[1]];
      var thirdBoxSign = board[line[2]];

      if (firstBoxSign != '' &&
          firstBoxSign == secondBoxSign &&
          secondBoxSign == thirdBoxSign) {
        return player1.sign == firstBoxSign ? player1 : player2;
      }
    }

    return null;
  }

  bool isBoardFull() {
    return board.every((element) => element != '');
  }
}
