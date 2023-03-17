import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: snakeGame(),
    );
  }
}

class snakeGame extends StatefulWidget {
  double leftPosition = 100;
  double topPosition = 100;
  int direction = 0;

  snakeGame();

  @override
  snakeGameState createState() => snakeGameState();
}

class snakeGameState extends State<snakeGame>
    with SingleTickerProviderStateMixin {
  late double leftPosition;
  late double topPosition;
  int length = 5;
  late int direction;
  late List<List<double>> coordinates;
  late AnimationController controller;

  @override
  void initState() {
    leftPosition = widget.leftPosition;
    topPosition = widget.topPosition;
    direction = widget.direction;

    coordinates = [
      [widget.leftPosition, widget.topPosition],
      [widget.leftPosition - 5, widget.topPosition],
      [widget.leftPosition - 10, widget.topPosition],
      [widget.leftPosition - 15, widget.topPosition],
      [widget.leftPosition - 20, widget.topPosition],
    ];
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    controller.addListener(() {
      setState(() {
        if ((direction % 4) == 1) {}
      });
    });
  }

  void incrementDirection() {
    direction++;
  }

  void startAnimation() {
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: snake(
          length: length,
          listOfSnakeParts: coordinates,
        ),
      ),
    );
  }
}

class SnakeHead extends StatelessWidget {
  final double left;
  final double top;

  SnakeHead({
    required this.left,
    required this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}

class SnakePart extends StatelessWidget {
  final double left;
  final double top;

  SnakePart({
    required this.left,
    required this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: Colors.red),
      ),
    );
  }
}

class snake extends StatelessWidget {
  int length;
  List<List<double>> listOfSnakeParts;
  snake({required this.length, required this.listOfSnakeParts});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(length, (index) {
        final double left = listOfSnakeParts[index][0];
        final double top = listOfSnakeParts[index][1];
        if (index == 0) {
          return SnakeHead(left: left, top: top);
        } else {
          return SnakePart(left: left, top: top);
        }
      }),
    );
  }
}


/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          SnakeHeadStateGlobalKey.currentState?.incrementDirection();
          snakePartStateGlobalKey.currentState?.incrementDirection();
          SnakeHeadStateGlobalKey.currentState?.startAnimation();
          snakePartStateGlobalKey.currentState?.startAnimation();
        },
        child: Scaffold(
          body: Stack(
            children: [
              SnakeHead(
                direction: 0,
                left: 100,
                top: 100,
                key: SnakeHeadStateGlobalKey,
              ),
              snakePart(
                lag: 0,
                direction: 0,
                left: 100 - 1,
                top: 100,
                key: snakePartStateGlobalKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SnakeHead extends StatefulWidget {
  final int direction;
  final double left;
  final double top;
  SnakeHead(
      {required this.direction,
      required this.left,
      required this.top,
      Key? key})
      : super(key: key);

  @override
  SnakeHeadState createState() => SnakeHeadState();
}

// Key för att komma åt SnakeHeadState från parent widget.
final GlobalKey<SnakeHeadState> SnakeHeadStateGlobalKey =
    GlobalKey<SnakeHeadState>();

class SnakeHeadState extends State<SnakeHead>
    with SingleTickerProviderStateMixin {
  late int direction;
  late double left;
  late double top;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    direction = widget.direction;
    left = widget.left;
    top = widget.top;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    controller.addListener(() {
      setState(() {
        if ((direction % 4) == 1) {
          left += 1;
        } else if ((direction % 4) == 2) {
          top += 1;
        } else if ((direction % 4) == 3) {
          left -= 1;
        } else if ((direction % 4) == 0) {
          top -= 1;
        }
      });
    });
  }

  void incrementDirection() {
    direction++;
  }

  void startAnimation() {
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        width: 10,
        height: 10,
      ),
    );
  }
}

class snakePart extends StatefulWidget {
  final int lag;
  final int direction;
  final double left;
  final double top;
  snakePart(
      {required this.lag,
      required this.direction,
      required this.left,
      required this.top,
      Key? key})
      : super(key: key);

  @override
  snakePartState createState() => snakePartState();
}

// Key för att komma åt snakePartState från parent widget.
final GlobalKey<snakePartState> snakePartStateGlobalKey =
    GlobalKey<snakePartState>();

class snakePartState extends State<snakePart>
    with SingleTickerProviderStateMixin {
  late int lag;
  late int direction;
  late double left;
  late double top;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    lag = widget.lag;
    direction = widget.direction;
    left = widget.left;
    top = widget.top;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    controller.addListener(() {
      setState(() {
        lag++;
        if (((direction % 4) == 1) || (direction % 4 == 2) && lag < 1) {
          left += 1;
        } else if (((direction % 4) == 2) || (direction % 4 == 3) && lag < 1) {
          top += 1;
        } else if (((direction % 4) == 3) || (direction % 4 == 0) && lag < 1) {
          left -= 1;
        } else if (((direction % 4) == 0) || (direction % 4 == 1) && lag < 1) {
          top -= 1;
        }
      });
    });
  }

  void incrementDirection() {
    direction++;
    lag = 0;
  }

  void startAnimation() {
    setState(() {
      controller.repeat();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        width: 10,
        height: 10,
      ),
    );
  }
}

*/

