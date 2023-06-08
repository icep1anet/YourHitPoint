// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// class TestApp extends StatefulWidget {
//   TestApp({Key? key}) : super(key: key);
//   @override
//   _testAppState createState() => _testAppState();
// }

// class _testAppState extends State<TestApp> {
//   Stream<DateTime>? timeStream;
//   var logger = Logger();

//   @override
//   void initState() {
//     super.initState();
//     timeStream =
//         Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'StreamBuilder Example',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('StreamBuilder Example'),
//         ),
//         body: StreamBuilder<DateTime>(
//           stream: timeStream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final currentTime = snapshot.data;
//               return Center(
//                 child: Text('Current Time: $currentTime'),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
