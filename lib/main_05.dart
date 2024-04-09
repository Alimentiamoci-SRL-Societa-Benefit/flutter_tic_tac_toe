import 'package:flutter/material.dart';

// TODO: nuova partita!

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

  Player get currentPlayer {
    return isPlayer1Turn ? player1 : player2;
  }

  Player? get winnerPlayer {
    return board.getWinningPlayer(player1: player1, player2: player2);
  }

  @override
  Widget build(BuildContext context) {
    Widget boardStatusWidget = PlayerTurnWidget(currentPlayer: currentPlayer);

    if (winnerPlayer != null) {
      boardStatusWidget = WinnerPlayerWidget(winner: winnerPlayer!);
    } else if (board.isBoardFull()) {
      boardStatusWidget = DrawWidget();
    }

    return Column(
      children: [
        SizedBox(height: 64),
        boardStatusWidget,
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeBox(sign: board.get(0), onTap: () => handleTap(0)),
            TicTacToeBox(sign: board.get(1), onTap: () => handleTap(1)),
            TicTacToeBox(sign: board.get(2), onTap: () => handleTap(2)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeBox(sign: board.get(3), onTap: () => handleTap(3)),
            TicTacToeBox(sign: board.get(4), onTap: () => handleTap(4)),
            TicTacToeBox(sign: board.get(5), onTap: () => handleTap(5)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeBox(sign: board.get(6), onTap: () => handleTap(6)),
            TicTacToeBox(sign: board.get(7), onTap: () => handleTap(7)),
            TicTacToeBox(sign: board.get(8), onTap: () => handleTap(8)),
          ],
        ),
      ],
    );
  }

  void handleTap(int index) {
    if (board.get(index) != '' || winnerPlayer != null) {
      return;
    }

    setState(() {
      board.set(player: currentPlayer, index: index);
      isPlayer1Turn = !isPlayer1Turn;
    });
  }
}

class PlayerTurnWidget extends StatelessWidget {
  const PlayerTurnWidget({required this.currentPlayer});

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

class WinnerPlayerWidget extends StatelessWidget {
  const WinnerPlayerWidget({required this.winner});

  final Player winner;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${winner.name} (${winner.sign}) ha vinto la partita!',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DrawWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'E\' un pareggio!',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TicTacToeBox extends StatelessWidget {
  const TicTacToeBox({
    required this.sign,
    required this.onTap,
    super.key,
  });

  final String sign;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(child: Text(sign)),
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
