import 'package:flutter/material.dart';

// TODO: mostrare la board di gioco

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
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

  @override
  Widget build(BuildContext context) {
    return PlayerTurnWidget(currentPlayer: isPlayer1Turn ? player1 : player2);
  }
}

class PlayerTurnWidget extends StatelessWidget {
  PlayerTurnWidget({
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
