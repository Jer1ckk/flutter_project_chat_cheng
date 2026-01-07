import 'package:flutter/material.dart';
import 'package:project/UI/screens/home_screen.dart';
import 'package:project/data/sample/sample_data.dart';
import 'package:project/domains/services/rooms_servive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final RoomService roomService = RoomService(
    payments: samplePayments,
    tenants: sampleTenants,
    rooms: sampleRooms,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen(roomService: roomService,)),
    );
  }
}
