import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'time_track_app.dart';

StreamBuilder<User?> _WidgetIfLoggedIn(Widget targetWidget) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (!snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/unauthenticated');
          });
          return const CircularProgressIndicator();
        } else {
          return targetWidget;
        }
        
      }
          return const Center(
            child: Text(
              'Error: Authentication service is missing',
              style: TextStyle(color: Colors.red),
            ),
          );
    }
  );
}

StreamBuilder<User?> _WidgetIfLoggedOut(Widget targetWidget) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/home');
          });
          return const CircularProgressIndicator();
        } else {
          return targetWidget;
        }
    }
      return const Center(
        child: Text(
          'Error: Authentication service is missing',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  );
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //     await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  //   } catch (e) {
  //     print('Failed to connect to Firebase emulators: $e');
  //   }
  // }
  
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/unauthenticated',
        page: () => _WidgetIfLoggedOut(LoginPage())
      ),
      GetPage(
        name: '/',
        page: () => _WidgetIfLoggedIn(const TimeTrackApp())
      ),
      // GetPage(name: '/app', page: () => UserPrefsPage()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Wrap with MaterialApp
      title: 'My App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
    );
  }
}