import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:staffmngt/staff_creation/add_staff.dart';
import 'package:staffmngt/staff_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // <--- required
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff App Management',
      debugShowCheckedModeBanner: false,
      home: StaffListPage(),
    );
  }
}
