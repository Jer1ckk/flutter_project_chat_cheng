import 'package:flutter/material.dart';
import '../../domains/models/colors.dart';

class RoomStatusCard extends StatelessWidget {
  const RoomStatusCard({super.key, required this.usedRoom});

  final int totalRoom = 50;
  final int usedRoom;

  @override
  Widget build(BuildContext context) {
    double percent = usedRoom / totalRoom;

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
                      widthFactor: percent, // width proportional
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.purpleDeep.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Percentage Text
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "${(percent * 100).round()}%",
                          style: TextStyle(
                            color: percent > 0.55
                                ? Colors.white
                                : Color(0xFF451C64),
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
