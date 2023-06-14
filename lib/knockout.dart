import 'package:flutter/material.dart';

import 'single.dart';
import 'dice.dart';
import 'package:knockout_game/rivee-animation.dart';

class KnockOutScreen extends StatefulWidget {
  const KnockOutScreen({super.key});

  @override
  State<KnockOutScreen> createState() => _KnockOutScreenState();
}

class _KnockOutScreenState extends State<KnockOutScreen> {
  int _playerScore = 0;
  int _aiScore = 0;
  String? _animation1;
  String? _animation2;

  @override
  void initState() {
    _animation1 = 'Start';
    _animation2 = 'Start';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knockout Game'),
        actions: [
          IconButton(
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Single());
                Navigator.push(context, route);
              },
              icon: const Icon(Icons.repeat_one)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height / 3,
                    width: width / 2.5,
                    child: RiveAnimation.asset(
                      'assets/dice.riv',
                      fit: BoxFit.contain,
                      animations: [_animation1!],
                    ),
                  ),
                  SizedBox(
                    height: height / 3,
                    width: width / 2.5,
                    child: RiveAnimation.asset(
                      'assets/dice.riv',
                      fit: BoxFit.contain,
                      animations: [_animation2!],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const GameText(
                      text: 'Player: ',
                      color: Colors.deepOrange,
                      isBordered: false),
                  GameText(
                      text: _playerScore.toString(),
                      color: Colors.white,
                      isBordered: true),
                ],
              ),
              Padding(padding: EdgeInsets.all(height / 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const GameText(
                      text: 'AI       : ',
                      color: Colors.lightBlue,
                      isBordered: false),
                  GameText(
                      text: _aiScore.toString(),
                      color: Colors.white,
                      isBordered: true),
                ],
              ),
              Padding(padding: EdgeInsets.all(height / 12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width / 3,
                    height: height / 10,
                    child: ElevatedButton(
                      child: const Text("Play"),
                      onPressed: () {
                        play(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    height: height / 10,
                    child: ElevatedButton(
                      child: const Text("Restart"),
                      onPressed: () {
                        reset();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future play(BuildContext context) async {
    String message = '';
    setState(() {
      _animation1 = 'Roll';
      _animation2 = 'Roll';
    });
    Dice.wait3Seconds().then((_) {
      Map<int, String> animation1 = Dice.getRandomAnimation();
      Map<int, String> animation2 = Dice.getRandomAnimation();
      int result = (animation1.keys.first + 1) + (animation2.keys.first + 1);
      int aiResult = Dice.getRandomNumber() + Dice.getRandomNumber();
      if (result == 7) result = 0;
      if (aiResult == 7) aiResult = 0;
      setState(() {
        _playerScore += result;
        _aiScore += aiResult;
        _animation1 = animation1.values.first;
        _animation2 = animation2.values.first;
      });
      if (_playerScore >= 50 || _aiScore >= 50) {
        if (_playerScore > _aiScore) {
          message = 'You win!';
        } else if (_playerScore == _aiScore) {
          message = 'Draw!';
        } else {
          message = 'You lose!';
        }
        showMessage(message);
      }
    });
    print("Player score is: $_playerScore \n AI Score is: $_aiScore");
  }

  void showMessage(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void reset() {
    setState(() {
      _animation1 = 'Start';
      _animation2 = 'Start';
      _aiScore = 0;
      _playerScore = 0;
    });
  }
}

class GameText extends StatelessWidget {
  const GameText(
      {super.key,
      required this.text,
      required this.color,
      required this.isBordered});

  final String text;
  final Color color;
  final bool isBordered;

  @override
  Widget build(BuildContext context) {
    return /*Container(
      decoration: BoxDecoration(
        border: isBordered ? Border.all() : null,
        borderRadius: BorderRadius.circular(24),
      ),
      child: */
        Text(
      text,
      style: TextStyle(fontSize: 24, color: color),
    );
  }
}
