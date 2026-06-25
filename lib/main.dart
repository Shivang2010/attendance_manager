import 'package:attendance_manager/providers/attendance_provider.dart';
import 'package:attendance_manager/providers/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/home_page.dart';
import 'database/Dao/attendance_dao.dart';
import 'database/Dao/subject_dao.dart';
import 'database/app_db.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appDb = AppDatabase();
  final subjectDao = SubjectDao(appDb);
  final attendanceDao = AttendanceDao(appDb);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: appDb),
        Provider<SubjectDao>.value(value: subjectDao),
        Provider<AttendanceDao>.value(value: attendanceDao),
        ChangeNotifierProvider<SubjectProvider>(
          create: (_) => SubjectProvider(subjectDao),
        ),
        ChangeNotifierProvider<AttendanceProvider>(
          create: (_) => AttendanceProvider(attendanceDao),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}