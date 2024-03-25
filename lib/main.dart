import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';


// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyCPY3qgBEjs3Mgnlh_TuSrbrNBaCpw2mgs",
//         appId: "1:572717615399:android:397ba11574ace4dce28102",
//         messagingSenderId: "572717615399",
//         projectId: "opject7",
//         storageBucket: "opject7.appspot.com",
//       ))
//       : await Firebase.initializeApp();
//
//   runApp(const MyApp());
// }
// You will find it in the google-services.json file
// options: const FirebaseOptions(
// apiKey: "AIzaSyCPY3qgBEjs3Mgnlh_TuSrbrNBaCpw2mgs", // "current_key": "AIzaSyCPY3qgBEjs3Mgnlh_TuSrbrNBaCpw2mgs"
// appId: "1:572717615399:android:397ba11574ace4dce28102", // "mobilesdk_app_id": "1:572717615399:android:397ba11574ace4dce28102",
// messagingSenderId: "572717615399", // "project_number": "572717615399",
// projectId: "opject7", /// "project_id": "opject7",

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:  "current_key",
        appId: "mobilesdk_app_id",
        messagingSenderId: "project_number",
        projectId: "project_id",
        storageBucket: "storageBucket",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> getAndPassDeviceToken() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      // Pass the device token to your backend
      await passTokenToBackend(token);
    }
  }

  Future<void> passTokenToBackend(String token) async {
    print("token:$token");
    try {
      var urlEndpoint = '/JgasRegistration/notifications';
      var url = Uri.parse('https://api.jaguar-petroleum.co.ke:8443/JgasRegistration/notifications');

      // Example of JSON payload to send to backend
      var body = jsonEncode({'token': token, "locationId": "Makandara"});

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (error) {
      print('Error passing token to backend: $error');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
            ElevatedButton(
              onPressed: () {
                getAndPassDeviceToken(); // Call the function when button is clicked
              },
              child: Text('Get and Pass Device Token'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
