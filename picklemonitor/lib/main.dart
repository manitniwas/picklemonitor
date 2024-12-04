import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Court Availability',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Court Availability'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime(); // Initial update of the time
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = _getCurrentTime();
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for the table
    final List<Map<String, dynamic>> tableData = [
      {
        "courtNumber": 1,
        "numPlayers": 4,
        "availableSpots": 0,
        "timeOnCourt": "2:00 PM",
      },
      {
        "courtNumber": 2,
        "numPlayers": 2,
        "availableSpots": 2,
        "timeOnCourt": "3:00 PM",
      },
      {
        "courtNumber": 3,
        "numPlayers": 1,
        "availableSpots": 3,
        "timeOnCourt": "4:00 PM",
      },
    ];

    // Function to determine the row color
    Color getRowColor(int availableSpots) {
      if (availableSpots == 0) {
        return Colors.red.shade100;
      } else if (availableSpots <= 2) {
        return Colors.yellow.shade100;
      } else {
        return Colors.green.shade100;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 14),
                    const SizedBox(width: 8),
                    const Text(
                      "Status: Operational",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "Time: $_currentTime",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Court Number')),
                  DataColumn(label: Text('Number of Players')),
                  DataColumn(label: Text('Available Spots')),
                  DataColumn(label: Text('Time on Court')),
                ],
                rows: tableData.map((row) {
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return getRowColor(row['availableSpots']);
                    }),
                    cells: [
                      DataCell(Text(row['courtNumber'].toString())),
                      DataCell(Text(row['numPlayers'].toString())),
                      DataCell(Text(row['availableSpots'].toString())),
                      DataCell(Text(row['timeOnCourt'])),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
