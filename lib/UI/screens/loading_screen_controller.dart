import 'package:flutter/material.dart';
import 'package:project/UI/screens/welcome_screen.dart';
import 'package:project/UI/screens/home_screen.dart';
import 'package:project/domains/services/rooms_servive.dart';
import '../../data/storage/room_local_data_source.dart';

class LoadingScreenController extends StatefulWidget {
  const LoadingScreenController({super.key});

  @override
  State<LoadingScreenController> createState() =>
      _LoadingScreenControllerState();
}

class _LoadingScreenControllerState extends State<LoadingScreenController> {
  bool _showWelcome = true;

  late RoomService roomService;
  late RoomLocalDataSource dataSource;

  @override
  void initState() {
    super.initState();

    dataSource = RoomLocalDataSource();
    roomService = RoomService(localDataSource: dataSource);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await roomService.loadData();
    } catch (e) {
      roomService.rooms = [];
      roomService.tenants = [];
      roomService.payments = [];
    }
  }

  Future<void> _saveData() async {
    await roomService.saveData();
  }

  void _onGetStarted() {
    setState(() {
      _showWelcome = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) return WelcomeScreen(onGetStarted: _onGetStarted);
    return HomeScreen(roomService: roomService, onSave: _saveData);
  }
}
