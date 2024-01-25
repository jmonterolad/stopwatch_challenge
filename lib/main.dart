import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  String digitSeconds = "00", digitMinutes = "00";
  Timer? timer;
  bool started = false;
  List<DataRow> lapRows = [];

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
      started = false;
      lapRows.clear();
      lapNumber = 0;
    });
  }

  void addLaps() {
    lapNumber++;
    String lapTime = "$digitMinutes:$digitSeconds.${(elapsedMilliseconds % 1000).toString().padLeft(3, '0')}";
    String overallTime = "$digitMinutes:$digitSeconds";

    // Create a DataRow for the lap and add it to lapRows
    lapRows.insert(
      0,
      DataRow(
        cells: [
          DataCell(Text("Lap $lapNumber")),
          DataCell(Text(lapTime)),
          DataCell(Text(overallTime)),
        ],
      ),
    );

    // Limit the number of visible laps
    if (lapRows.length > maxVisibleLaps) {
      lapRows.sort();
    }

    setState(() {});
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
                  "$digitMinutes:$digitSeconds.${(elapsedMilliseconds % 1000).toString().padLeft(3, '0')}",
                  style: const TextStyle(
                    fontSize: 48.0,
                    color: Colors.white,
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              Container(
                height: 200.0, // Set the maximum height for the DataTable container
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Lap')),
                      DataColumn(label: Text('Lap Times')),
                      DataColumn(label: Text('Overall Time')),
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
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.blue),
                      ),
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
                        side: BorderSide(color: Colors.blue),
                      ),
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
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Text(
                        (!started) ? "Start" : "Pause",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}