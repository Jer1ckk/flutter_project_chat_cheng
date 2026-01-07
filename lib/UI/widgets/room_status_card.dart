import 'package:flutter/material.dart';
import 'package:project/domains/services/rooms_servive.dart';
import '../../domains/models/colors.dart';

class RoomStatusCard extends StatelessWidget {
  const RoomStatusCard({super.key, required this.roomService});

  final RoomService roomService;

  @override
  Widget build(BuildContext context) {
    // Count only tenants with assigned rooms
    final int usedRoom = roomService.tenants
        .where((t) => t.roomId != null)
        .length;

    // Total rooms
    final int totalRoom = roomService.rooms.length;

    // Avoid divide by zero
    final double percent = usedRoom / totalRoom;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleLight.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Room Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "$usedRoom/$totalRoom",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Stack(
                  children: [
                    // Background bar
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // Filled bar
                    FractionallySizedBox(
                      widthFactor: percent,
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.purpleDeep.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Percentage text
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "${(percent * 100).round()}%",
                          style: TextStyle(
                            color: AppColors.purpleLight.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
