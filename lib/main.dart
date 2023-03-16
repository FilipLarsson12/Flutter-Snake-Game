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
      home: Scaffold(
        body: Stack(
          children: [
            xMovableContainer(left: 100, top: 100),
          ],
        ),
      ),
    );
  }
}

class xMovableContainer extends StatefulWidget {
  final double left;
  final double top;
  xMovableContainer({required this.left, required this.top});

  @override
  xMovableContainerState createState() => xMovableContainerState();
}

class xMovableContainerState extends State<xMovableContainer>
    with SingleTickerProviderStateMixin {
  late double left;
  late double top;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    left = widget.left;
    top = widget.top;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    controller.addListener(() {
      setState(() {
        left += 1;
      });
    });

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
        width: 50,
        height: 10,
      ),
    );
  }
}
