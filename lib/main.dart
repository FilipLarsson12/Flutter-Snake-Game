import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  int score = 0;
  MyApp();

  Map<String, WidgetBuilder> views = {
    '/start': (BuildContext context) => StartScreen(),
    '/snakeGame': (BuildContext context) => snakeGame(),
    '/gameOverScreen': (BuildContext context) => gameOverScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/start',
      routes: views,
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  double frame = 0;
  late AnimationController controller;
  List<List<double>> coordinates = [];

  StartScreenState();
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    startAnimation();

    controller.addListener(() {
      setState(() {
        frame++;
        if (frame % 5 == 0 && frame < 100) {
          coordinates.add([frame * 2, 200]);
        }
      });
    });
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
    return Container(
      decoration: BoxDecoration(color: Colors.amber),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Center(
              child: Text(
                "Välkommen till Snake!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 40.0,
                    color: Colors.white,
                    fontFamily: 'PressStart2P',
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0)),
                    ]),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text("Starta Spel"),
              onPressed: () {
                Navigator.pushNamed(context, '/snakeGame');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class snakeTounge extends StatelessWidget {
  double left;
  double top;
  snakeTounge({required this.left, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(color: Colors.blue),
        width: 10,
        height: 10,
        child: Column(
          children: [
            Positioned(
                left: left,
                top: top + 4,
                child: Container(
                  width: 4,
                  height: 1,
                  decoration: BoxDecoration(color: Colors.red),
                )),
            Positioned(
              left: left + 4,
              top: top + 3,
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
                width: 1,
                height: 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class gameOverScreen extends StatelessWidget {
  gameOverScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Game Over!",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              margin: EdgeInsets.only(bottom: 10),
            ),
            ElevatedButton(
              child: Text("Spela igen"),
              onPressed: () {
                Navigator.pushNamed(context, '/snakeGame');
              },
            ),
          ],
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

class snakeGameState extends State<snakeGame> with TickerProviderStateMixin {
  bool controllerExist = false;
  int usefulVariable = 0;
  int highscore = 0;
  int score = 0;
  bool gameOver = false;
  int frame = 0;
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
  snakeGameState();

  @override
  void initState() {
    fruitLeftCoordinate = random.nextDouble() * (borderRight - borderLeft);
    fruitTopCoordinate = random.nextDouble() * (borderBottom - borderTop);
    coordinates = createSnake();
    setupAnimationController();
  }

  void setupAnimationController() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    startAnimation();

    controller.addListener(() {
      setState(() {
        collisionWithFruit();
        collisionWithSnake();
        if (direction >= 1) {
          if ((direction % 4) == 1) {
            if (frame % 10 == 0) {
              headTopPosition += 2;
              headLeftPosition += 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else if (frame % 10 == 4) {
              headTopPosition -= 2;
              headLeftPosition += 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else {
              headLeftPosition += 4;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            }
          } else if ((direction % 4) == 2) {
            if (frame % 10 == 0) {
              headTopPosition += 2;
              headLeftPosition -= 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else if (frame % 10 == 5) {
              headTopPosition += 2;
              headLeftPosition += 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else {
              headTopPosition += 4;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            }
          } else if ((direction % 4) == 3) {
            if (frame % 10 == 0) {
              headTopPosition -= 2;
              headLeftPosition -= 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else if (frame % 10 == 4) {
              headTopPosition += 2;
              headLeftPosition -= 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else {
              headLeftPosition -= 4;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            }
          } else if ((direction % 4) == 0) {
            if (frame % 10 == 0) {
              headTopPosition -= 2;
              headLeftPosition -= 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else if (frame % 10 == 5) {
              headTopPosition -= 2;
              headLeftPosition += 2;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            } else {
              headTopPosition -= 4;
              frame++;
              updateCoordinates(headLeftPosition, headTopPosition);
            }
          }
          collisionWithWall();
        }
      });
    });
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
      score++;
      length += 2;
      updateCoordinatesWhenLengthIncreases(direction);
    }
  }

  List<List<double>> createSnake() {
    List<List<double>> startCoordinates =
        List<List<double>>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      startCoordinates.add([100 - (i * 3), 100]);
    }
    return startCoordinates;
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
        gameOver = true;
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
      gameOver = true;
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

  void resetGame() {
    if (usefulVariable == 0) {
      if (score > highscore) {
        highscore = score;
      }
      usefulVariable++;
      controller.dispose();
      coordinates.clear();
      headLeftPosition = 100;
      headTopPosition = 100;
      gameOver = false;
      length = 10;
      direction = 0;
      score = 0;
      frame = 0;
      fruitLeftCoordinate = random.nextDouble() * (borderRight - borderLeft);
      fruitTopCoordinate = random.nextDouble() * (borderBottom - borderTop);
      coordinates = createSnake();
      setupAnimationController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      usefulVariable = 0;
      return Container(
          decoration: BoxDecoration(color: Colors.amber),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Text(
                    "Spel över",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 40.0,
                        color: Colors.white,
                        fontFamily: 'PressStart2P',
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              blurRadius: 2.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0)),
                        ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Din poäng var: $score",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Högsta poäng: $highscore",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    child: Text("Spela igen"),
                    onPressed: () {
                      resetGame();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    child: Text("Tillbaka till Startskärm"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/start');
                    },
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Container(
        decoration: BoxDecoration(color: Colors.black),
        child: GestureDetector(
          onTap: () {
            incrementDirection();
          },
          child: Scaffold(
            body: snake(
              highscore: highscore,
              score: score,
              length: length,
              listOfSnakeParts: coordinates,
              fruitLeft: fruitLeftCoordinate,
              fruitTop: fruitTopCoordinate,
            ),
          ),
        ),
      );
    }
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
        decoration: BoxDecoration(color: Color.fromARGB(175, 90, 244, 59)),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            constraints: BoxConstraints(
              maxWidth: 4.0,
              maxHeight: 4.0,
              minWidth: 4.0,
              minHeight: 4.0,
            ),
            decoration: BoxDecoration(color: Color.fromARGB(255, 79, 228, 84)),
          ),
        ),
      ),
    );
  }
}

class snake extends StatelessWidget {
  int highscore;
  int score;
  int length;
  List<List<double>> listOfSnakeParts;
  double fruitLeft;
  double fruitTop;
  snake(
      {required this.highscore,
      required this.score,
      required this.length,
      required this.listOfSnakeParts,
      required this.fruitLeft,
      required this.fruitTop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 2, left: 4),
                margin: EdgeInsets.only(top: 50, bottom: 5, right: 5, left: 22),
                height: 30,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(width: 2.0, color: Colors.blue)),
                child: Text(
                  "Score: $score",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'RetroGaming',
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 2, left: 4),
                margin: EdgeInsets.only(
                  left: 2,
                  top: 50,
                  bottom: 5,
                ),
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(width: 2.0, color: Colors.blue)),
                child: Text(
                  "HighScore: $highscore",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'RetroGaming',
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              width: 370,
              height: 780,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 72, 156, 225),
                  border: Border.all(
                      width: 2.0, color: Color.fromARGB(255, 22, 55, 81))),
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
          ),
        ],
      ),
    );
  }
}
