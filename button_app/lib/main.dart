import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  bool isPaused = false;
  bool showButton = false;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            // setState(() {
            //   isPaused = !isPaused;
            //   showButton = !showButton;
            //   if (isPaused) {
            //     _controller.forward(); // Start the animation
            //   } else {
            //     _controller.reverse(); // Reverse the animation
            //   }
            // });
            setState(() {
              if (!isPaused) {
                isPaused = true;
                _controller.reverse();
              } else if (isRecording) {
                isRecording = false;
              }
            });
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0), // Start from the left
                  end: Offset.zero, // End at the center
                ).animate(
                  CurvedAnimation(
                    curve: Curves.easeInOut,
                    parent: _controller, // Use an AnimationController
                  ),
                ),
                child: const StopButton(),
              );
            },
            child: const SizedBox(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          // setState(() {
          //   isRecording = !isRecording;
          //   if (isRecording) {
          //     _controller.forward();
          //   }
          // });
          setState(() {
            if (!isRecording && !isPaused) {
              isRecording = true;
              _controller.forward();
            } else if (isRecording) {
              isRecording = false;
              isPaused = true;
            }
          });
        },
        child: Stack(
          children: [
            !isRecording ? const RecordingButton() : const SizedBox(),
            isPaused
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPaused ? isPaused = false : isPaused = true;
                            !isRecording
                                ? isRecording = true
                                : isRecording = false;
                          });
                        },
                        child: const ResumeButton(),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPaused ? isPaused = false : isPaused = true;
                            !isRecording
                                ? isRecording = true
                                : isRecording = false;
                          });
                        },
                        child: const FinishButton(),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class StopButton extends StatelessWidget {
  const StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      // duration: const Duration(milliseconds: 400),
      // curve: Curves.fastOutSlowIn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.stop,
            color: Colors.white,
          ),
          Text(
            'Stop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}

class FinishButton extends StatelessWidget {
  const FinishButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 45.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.stop,
              color: Colors.white,
            ),
            Text(
              'Stop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResumeButton extends StatelessWidget {
  const ResumeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 45.0,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Row(
          children: const [
            Icon(
              Icons.pause,
              color: Colors.white,
            ),
            Text(
              'Resume',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordingButton extends StatelessWidget {
  const RecordingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 55.0,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Start Recording',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
