import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/responsive_screens/mobile_layout_screen.dart';
import 'package:insta_clone/responsive_screens/responsive_layout_screen.dart';
import 'package:insta_clone/responsive_screens/web_layout_screen.dart';
import 'package:insta_clone/screens/login.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'utils/colors.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  if (kIsWeb) {
    // print('initialize firebase web');
    await Firebase.initializeApp(
      name: 'instagram-clone-flutter-app',
      options: const FirebaseOptions(
          apiKey: "AIzaSyDHJSH9j5bJnUeQK_y4J4g2IICxE82iejg",
          authDomain: "insta-clone-app-1.firebaseapp.com",
          projectId: "insta-clone-app-1",
          storageBucket: "insta-clone-app-1.appspot.com",
          messagingSenderId: "527309111783",
          appId: "1:527309111783:web:0e81fa87295f58f758bd42"),
    );
  } else {
    // print('initialize firebase app');
    await Firebase.initializeApp(
      name: 'instagram-clone-flutter-app',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayoutScreen(
                  mobileScreenLayout: MobileLayoutScreen(),
                  webScreenLayout: WebLayoutScreen(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return LoginScreen();
          },
        ),
      ),
    );
  }
}
