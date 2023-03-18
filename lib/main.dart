import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          snakeGameStateGlobalKey.currentState?.incrementDirection();
          snakeGameStateGlobalKey.currentState?.startAnimation();
        },
        child: snakeGame(
          key: snakeGameStateGlobalKey,
        ),
      ),
    );
  }
}

class snakeGame extends StatefulWidget {
  snakeGame({Key? key}) : super(key: key);

  @override
  snakeGameState createState() => snakeGameState();
}

// Key för att komma åt snakeGameState från parent widget.
final GlobalKey<snakeGameState> snakeGameStateGlobalKey =
    GlobalKey<snakeGameState>();

class snakeGameState extends State<snakeGame>
    with SingleTickerProviderStateMixin {
  int start = 0;
  late double headLeftPosition = 100;
  late double headTopPosition = 100;
  final random = Random();
  int length = 10;
  int direction = 0;
  late List<List<double>> coordinates =
      List<List<double>>.empty(growable: true);
  late AnimationController controller;
  late double fruitLeftCoordinate;
  late double fruitTopCoordinate;
  final borderLeft = 23;
  final borderRight = 381;
  final borderTop = 84;
  final borderBottom = 852;

  @override
  void initState() {
    fruitLeftCoordinate = random.nextDouble() * (borderRight - borderLeft);
    fruitTopCoordinate = random.nextDouble() * (borderBottom - borderTop);
    coordinates = createSnake();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    controller.addListener(() {
      setState(() {
        collisionWithFruit();
        collisionWithSnake();
        collisionWithWall();
        if ((direction % 4) == 1) {
          headLeftPosition += 3;
          updateCoordinates(headLeftPosition, headTopPosition);
        } else if ((direction % 4) == 2) {
          headTopPosition += 3;
          updateCoordinates(headLeftPosition, headTopPosition);
        } else if ((direction % 4) == 3) {
          headLeftPosition -= 3;
          updateCoordinates(headLeftPosition, headTopPosition);
        } else if ((direction % 4) == 0) {
          headTopPosition -= 3;
          updateCoordinates(headLeftPosition, headTopPosition);
        }
      });
    });
  }

  List<List<double>> createSnake() {
    List<List<double>> startCoordinates =
        List<List<double>>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      startCoordinates.add([100 - (i * 3), 100]);
    }
    return startCoordinates;
  }

  /* Method to update the entire coordinate list of the Snake. 
  The movement of the Snake head should be dependent on direction
  and the movement of the remaining snake parts should be dependent
  on where the previous part of the snake was.
  
  */
  void updateCoordinates(
      double newHeadLeftCoordinate, double newHeadTopCoordinate) {
    double nextLeftCoordinate = coordinates[0][0];
    double nextTopCoordinate = coordinates[0][1];
    double currentLeftCoordinate = 0;
    double currentTopCoordinate = 0;

    for (int i = 0; i < length; i++) {
      if (i == 0) {
        coordinates[i][0] = newHeadLeftCoordinate;
        coordinates[i][1] = newHeadTopCoordinate;
      } else {
        currentLeftCoordinate = coordinates[i][0];
        currentTopCoordinate = coordinates[i][1];
        coordinates[i][0] = nextLeftCoordinate;
        coordinates[i][1] = nextTopCoordinate;
        nextLeftCoordinate = currentLeftCoordinate;
        nextTopCoordinate = currentTopCoordinate;
      }
    }
  }

  /* Check if the snake has collided with fruit. 
  If it has generate new fruit coordinates and increase the snake length.
  */

  void collisionWithFruit() {
    if ((coordinates[0][0] >= fruitLeftCoordinate - 10 &&
            coordinates[0][0] <= fruitLeftCoordinate + 10) &&
        (coordinates[0][1] >= fruitTopCoordinate - 10 &&
            coordinates[0][1] <= fruitTopCoordinate + 10)) {
      fruitLeftCoordinate = random.nextDouble() * (borderRight - borderLeft);
      fruitTopCoordinate = random.nextDouble() * (borderBottom - borderTop);
      length += 2;
      updateCoordinatesWhenLengthIncreases(direction);
    }
  }

  /* Check if the snake has collided with itself. 
  If it has the game is over.
  */
  void collisionWithSnake() {
    for (int i = 10; i < length; i++) {
      if ((coordinates[0][0] >= coordinates[i][0] - 10 &&
              coordinates[0][0] <= coordinates[i][0] + 10) &&
          (coordinates[0][1] >= coordinates[i][1] - 10 &&
              coordinates[0][1] <= coordinates[i][1] + 10)) {
        length = 0;
        coordinates.clear();
      }
    }
  }

  /* Check if the snake has collided with the wall. 
  If it has the game is over.
  */

  void collisionWithWall() {
    if ((coordinates[0][0] > 358 ||
        coordinates[0][0] < 0 ||
        coordinates[0][1] < 0 ||
        coordinates[0][1] > 770)) {
      length = 0;
      coordinates.clear();
    }
  }

  void updateCoordinatesWhenLengthIncreases(int direction) {
    double newContainerLeftCoordinate = coordinates[length - 3][0];
    double newContainerTopCoordinate = coordinates[length - 3][1];
    double secondNewContainerLeftCoordinate = coordinates[length - 3][0];
    double secondNewContainerTopCoordinate = coordinates[length - 3][1];
    if (direction % 4 == 1) {
      newContainerLeftCoordinate -= 3;
      secondNewContainerLeftCoordinate -= 6;
    } else if (direction % 4 == 2) {
      newContainerTopCoordinate -= 3;
      secondNewContainerTopCoordinate -= 6;
    } else if (direction % 4 == 3) {
      newContainerLeftCoordinate += 3;
      secondNewContainerLeftCoordinate += 6;
    } else if (direction % 4 == 0) {
      newContainerTopCoordinate += 3;
      secondNewContainerTopCoordinate += 6;
    }

    coordinates.add([newContainerLeftCoordinate, newContainerTopCoordinate]);
    coordinates.add(
        [secondNewContainerLeftCoordinate, secondNewContainerTopCoordinate]);
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
    return Scaffold(
      body: snake(
        length: length,
        listOfSnakeParts: coordinates,
        fruitLeft: fruitLeftCoordinate,
        fruitTop: fruitTopCoordinate,
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
        decoration: BoxDecoration(color: Colors.black),
      ),
    );
  }
}

class SnakePart extends StatelessWidget {
  final double left;
  final double top;
  final Color color;
  SnakePart({
    required this.left,
    required this.top,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}

class Fruit extends StatelessWidget {
  final double left;
  final double top;

  Fruit({required this.left, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: Colors.orange),
      ),
    );
  }
}

class snake extends StatelessWidget {
  int length;
  List<List<double>> listOfSnakeParts;
  double fruitLeft;
  double fruitTop;
  snake(
      {required this.length,
      required this.listOfSnakeParts,
      required this.fruitLeft,
      required this.fruitTop});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: 370,
        height: 780,
        decoration:
            BoxDecoration(border: Border.all(width: 2.0, color: Colors.black)),
        child: Stack(
          children: List.generate(length, (index) {
            final double left = listOfSnakeParts[index][0];
            final double top = listOfSnakeParts[index][1];
            if (index == 0) {
              return SnakeHead(left: left, top: top);
            } else if (index < length - 1) {
              if (index % 2 == 0) {
                return SnakePart(
                  left: left,
                  top: top,
                  color: Colors.red,
                );
              } else {
                return SnakePart(
                  left: left,
                  top: top,
                  color: Colors.black,
                );
              }
            } else {
              return Fruit(left: fruitLeft, top: fruitTop);
            }
          }),
        ),
      ),
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

