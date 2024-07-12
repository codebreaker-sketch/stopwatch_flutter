import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
      );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int milliseconds = 0, seconds = 0, minutes = 0;
  String digitMilliseconds = "000", digitSeconds = "00", digitMinutes = "00";
  Timer? timer;
  bool started = false;
  List<String> laps = [];

  void stop() {
    timer?.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer?.cancel();
    setState(() {
      milliseconds = 0;
      seconds = 0;
      minutes = 0;

      digitMilliseconds = "000";
      digitSeconds = "00";
      digitMinutes = "00";

      started = false;
      laps.clear();
    });
  }

  void addLaps() {
    String lap = "$digitMinutes:$digitSeconds:$digitMilliseconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      int localMilliseconds = milliseconds + 1;
      int localSeconds = seconds;
      int localMinutes = minutes;

      if (localMilliseconds > 999) {
        localSeconds++;
        localMilliseconds = 0;
      }
      if (localSeconds > 59) {
        localMinutes++;
        localSeconds = 0;
      }

      setState(() {
        milliseconds = localMilliseconds;
        seconds = localSeconds;
        minutes = localMinutes;
        digitMilliseconds = (milliseconds >= 100)
            ? "$milliseconds"
            : milliseconds >= 10
                ? "0$milliseconds"
                : "00$milliseconds";
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Stopwatch App",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  "$digitMinutes:$digitSeconds:$digitMilliseconds",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              CustomPaint(
                size: const Size(200, 200),
                painter: ClockPainter(minutes, seconds, milliseconds),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF323F68),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lap n°${index + 1}",
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              laps[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stop();
                      },
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Text(
                        (!started) ? "Start" : "Pause",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    color: Colors.orange,
                    onPressed: addLaps,
                    icon: const Icon(Icons.flag),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: reset,
                      fillColor: Colors.blue,
                      shape: const StadiumBorder(),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
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
}

class ClockPainter extends CustomPainter {
  final int minutes;
  final int seconds;
  final int milliseconds;

  ClockPainter(this.minutes, this.seconds, this.milliseconds);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    Paint minuteHandPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    Paint secondHandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Paint millisecondHandPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double radius = size.width / 2;
    Offset center = Offset(radius, radius);

    // Draw the clock circle
    canvas.drawCircle(center, radius, circlePaint);

    // Draw the minute hand
    double minuteHandX =
        center.dx + radius * 0.7 * cos((minutes * 6 - 90) * pi / 180);
    double minuteHandY =
        center.dy + radius * 0.7 * sin((minutes * 6 - 90) * pi / 180);
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandPaint);

    // Draw the second hand
    double secondHandX =
        center.dx + radius * 0.8 * cos((seconds * 6 - 90) * pi / 180);
    double secondHandY =
        center.dy + radius * 0.8 * sin((seconds * 6 - 90) * pi / 180);
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandPaint);

    // Draw the millisecond hand
    double millisecondHandX = center.dx +
        radius * 0.9 * cos((milliseconds * 0.36 - 90) * pi / 180);
    double millisecondHandY = center.dy +
        radius * 0.9 * sin((milliseconds * 0.36 - 90) * pi / 180);
    canvas.drawLine(
        center, Offset(millisecondHandX, millisecondHandY), millisecondHandPaint);

    // Draw the numbers
    for (int i = 1; i <= 12; i++) {
      double angle = (i * 30 - 90) * pi / 180;
      double numberX = center.dx + radius * 0.75 * cos(angle);
      double numberY = center.dy + radius * 0.75 * sin(angle);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(numberX - textPainter.width / 2, numberY - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
