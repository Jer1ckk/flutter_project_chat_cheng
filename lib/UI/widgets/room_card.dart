import 'package:flutter/material.dart';
import '../../domains/models/colors.dart';
import '../../domains/models/room.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  String get status => room.isOccupied ? "Occupied" : "Available";
  Color get statusColor => room.isOccupied ? Colors.red: Colors.green  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleLight.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.meeting_room,
              color: AppColors.purpleDeep.color,
              size: 40,
            ),
          ),

          const SizedBox(width: 16),

          Text(
            "Room ${room.roomNumber}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),

          const Spacer(),

          Container(
            width: 90,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
