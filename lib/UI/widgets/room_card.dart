import 'package:flutter/material.dart';
import '../../domains/models/colors.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.roomNumber,
    required this.isAvailable,
  });

  final String roomNumber;
  final bool isAvailable;

  String get status => isAvailable ? "Available" : "Occupied";
  Color get statusColor => isAvailable ? Colors.green : Colors.red;

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
            child: Icon(Icons.meeting_room, color: AppColors.purpleDeep.color, size: 40,),
          ),

          const SizedBox(width: 16),

          Text(
            "Room $roomNumber",
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
