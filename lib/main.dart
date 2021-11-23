import 'dart:math';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeAppCheck(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                '${value ?? "NO VALUE"}',
                style:
                    const TextStyle(fontSize: 75, fontWeight: FontWeight.bold),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          value = _insertSampleDataIntoFirebaseDatabase();

          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> _initializeAppCheck({bool enableAppCheck = false}) async {
    await Firebase.initializeApp();

    if (enableAppCheck) {
      await FirebaseAppCheck.instance.activate();
    }
  }

  int _insertSampleDataIntoFirebaseDatabase() {
    final int randomNumber = Random().nextInt(100);
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('test');

    databaseReference.set({
      'value': randomNumber,
    });

    return randomNumber;
  }
}
