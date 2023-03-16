import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          snakeHeadStateGlobalKey.currentState?.incrementDirection();
          snakePartStateGlobalKey.currentState?.incrementDirection();
          snakeHeadStateGlobalKey.currentState?.startAnimation();
          snakePartStateGlobalKey.currentState?.startAnimation();
        },
        child: Scaffold(
          body: Stack(
            children: [
              snakeHead(
                direction: 0,
                left: 100,
                top: 100,
                key: snakeHeadStateGlobalKey,
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

class snakeHead extends StatefulWidget {
  final int direction;
  final double left;
  final double top;
  snakeHead(
      {required this.direction,
      required this.left,
      required this.top,
      Key? key})
      : super(key: key);

  @override
  snakeHeadState createState() => snakeHeadState();
}

// Key för att komma åt snakeHeadState från parent widget.
final GlobalKey<snakeHeadState> snakeHeadStateGlobalKey =
    GlobalKey<snakeHeadState>();

class snakeHeadState extends State<snakeHead>
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
