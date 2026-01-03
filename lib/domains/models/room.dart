import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Room {
  final String roomId;
  final String roomNumber;
  final double rent;
  bool isOccupied;

  Room({required this.roomNumber, required this.rent, this.isOccupied = false})
    : roomId = uuid.v4();
}