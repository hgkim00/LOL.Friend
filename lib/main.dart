import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lol_friend/services/auth_service.dart';
import 'package:lol_friend/services/community_service.dart';
import 'package:lol_friend/services/like_service.dart';
import 'package:lol_friend/services/location_provider.dart';
import 'package:lol_friend/services/navigation_service.dart';
import 'package:lol_friend/views/app.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => NavigationService()),
        ChangeNotifierProvider(create: (context) => CommunityService()),
        ChangeNotifierProvider(create: (context) => LikeService()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      builder: ((context, child) => const App()),
    ),
  );
}
