import 'package:flutter/material.dart';
import '../../data/storage/data_manager.dart';
import '../../data/storage/room_local_data_source.dart';
import '../../domains/services/rooms_servive.dart';
import '../screens/home_screen.dart';
import '../screens/welcome_screen.dart';

class LoadingScreenController extends StatefulWidget {
  const LoadingScreenController({super.key});

  @override
  State<LoadingScreenController> createState() =>
      _LoadingScreenControllerState();
}

class _LoadingScreenControllerState extends State<LoadingScreenController> {
  bool _showWelcome = true;

  late RoomService roomService;
  late RoomDataManager dataManager;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    dataManager = RoomDataManager(dataSource: RoomLocalDataSource());

    roomService = await dataManager.loadService();

    setState(() {});
  }

  Future<void> _save() async {
    await dataManager.save(roomService);
  }

  void _onGetStarted() {
    setState(() => _showWelcome = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return WelcomeScreen(onGetStarted: _onGetStarted);
    }

    return HomeScreen(roomService: roomService, onSave: _save);
  }
}
