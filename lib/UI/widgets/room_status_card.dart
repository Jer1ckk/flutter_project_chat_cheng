import 'package:flutter/material.dart';
import 'package:project/domains/services/rooms_servive.dart';

import '../../domains/models/colors.dart';

class RoomStatusCard extends StatelessWidget {
  const RoomStatusCard({super.key, required this.roomService});

  final RoomService roomService;

  @override
  Widget build(BuildContext context) {
    final int totalRoom = roomService.rooms.length;
    final int usedRoom = roomService.tenants.where((t) => t.roomId != null).length;

    final double percent = totalRoom == 0 ? 0.0 : (usedRoom / totalRoom).clamp(0.0, 1.0);

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
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
