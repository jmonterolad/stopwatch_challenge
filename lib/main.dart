import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: StopwatchApp(),
    );
  }
}

class StopwatchApp extends StatefulWidget {
  const StopwatchApp({super.key});

  @override
  State<StopwatchApp> createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  int elapsedMilliseconds = 0, seconds = 0, minutes = 0;
  String digitSeconds = "00", digitMinutes = "00", digitMilliseconds = "00";
  Timer? timer;
  bool started = false;
  List<DataRow> lapRows = [];
  Color startButtonColor = const Color(0xFF6A5ACD);
  Color pauseButtonColor = Colors.red;
  Color lapButtonColor = const Color(0xFF808080);

  Stopwatch stopwatch = Stopwatch();
  int lapNumber = 0;
  int maxVisibleLaps = 5; // Set the maximum number of visible laps

  void stop() {
    stopwatch.stop();
    timer?.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer?.cancel();
    setState(() {
      stopwatch.reset();
      elapsedMilliseconds = 0;
      seconds = 0;
      minutes = 0;
      digitSeconds = "00";
      digitMinutes = "00";
      digitMilliseconds = "00";
      started = false;
      lapRows.clear();
      lapNumber = 0;
    });
  }

  void addLaps() {
    if (started) {
      lapNumber++;
      String lapTime =
          "$digitMinutes:$digitSeconds.${(elapsedMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}";
      String overallTime = "$digitMinutes:$digitSeconds";

      // Create a DataRow for the lap and add it to lapRows
      lapRows.insert(
        0,
        DataRow(
          cells: [
            DataCell(
                Text("Lap $lapNumber", style: const TextStyle(color: Colors.white))),
            DataCell(Text(lapTime, style: const TextStyle(color: Colors.white))),
            DataCell(Text(overallTime, style: const TextStyle(color: Colors.white))),
          ],
        ),
      );

      // Limit the number of visible laps
      if (lapRows.length > maxVisibleLaps) {
        lapRows.sort();
        lapRows.removeLast();
      }

      setState(() {});
    }
  }

  void start() {
    stopwatch.start();
    started = true;
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      int localMilliseconds = stopwatch.elapsedMilliseconds;
      int localSeconds = localMilliseconds ~/ 1000;
      int localMinutes = localSeconds ~/ 60;

      setState(() {
        elapsedMilliseconds = localMilliseconds;
        seconds = localSeconds % 60;
        minutes = localMinutes;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitMilliseconds =
            (localMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: Text(
                  "$digitMinutes:$digitSeconds.$digitMilliseconds",
                  style: const TextStyle(
                    fontSize: 48.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 300.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text('Lap',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Lap Time',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Overall Time',
                              style: TextStyle(color: Colors.white))),
                    ],
                    rows: lapRows,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () => reset(),
                      shape: const StadiumBorder(),
                      fillColor: startButtonColor,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () => addLaps(),
                      shape: const StadiumBorder(
                        side: BorderSide(),
                      ),
                      fillColor: lapButtonColor,
                      child: const Text(
                        'Lap',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () => (!started) ? start() : stop(),
                      shape: const StadiumBorder(
                        side: BorderSide(),
                      ),
                      fillColor:
                          (started) ? pauseButtonColor : startButtonColor,
                      child: Text(
                        (started) ? "Pause" : "Start",
                        style: const TextStyle(color: Colors.white),
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
