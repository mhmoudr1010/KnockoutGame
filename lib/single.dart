import 'dice.dart';
import 'package:flutter/material.dart';
import 'package:knockout_game/rivee-animation.dart';
import 'knockout.dart';

class Single extends StatefulWidget {
  const Single({super.key});

  @override
  State<Single> createState() => _SingleState();
}

class _SingleState extends State<Single> {
  late String currentAnimation;

  @override
  void initState() {
    currentAnimation = 'Start';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Single Dice"),
        actions: [
          IconButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => const KnockOutScreen());
                Navigator.push(context, route);
              },
              icon: const Icon(Icons.fitness_center)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: height / 1.7,
              width: width * 0.8,
              child: RiveAnimation.asset(
                'assets/dice.riv',
                fit: BoxFit.contain,
                animations: [currentAnimation],
              ),
            ),
            SizedBox(
              width: width / 2.5,
              height: height / 10,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentAnimation = 'Roll';
                    });
                    Dice.wait3Seconds().then((_) => callResult());
                  },
                  child: const Text("Play")),
            ),
          ],
        ),
      ),
    );
  }

  void callResult() async {
    Map<int, String> animation = Dice.getRandomAnimation();
    setState(() {
      currentAnimation = animation.values.first;
    });
  }
}
