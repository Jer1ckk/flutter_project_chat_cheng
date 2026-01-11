import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import '../../../../../domains/models/room.dart';
import '../../../../widgets/room_card.dart';

class RoomsStatus extends StatelessWidget {
  const RoomsStatus({super.key, required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    final totalRooms = rooms.length;
    final occupiedRooms = rooms.where((r) => r.isOccupied).length;
    final availableRooms = totalRooms - occupiedRooms;

    return Scaffold(
      backgroundColor: AppColors.purpleDeep.color,
      appBar: AppBar(
        title: const Text("Rooms Status"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        backgroundColor: AppColors.purpleDeep.color,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "$occupiedRooms/$totalRooms",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "$availableRooms Rooms",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Room list
            Expanded(
              child: rooms.isEmpty
                  ? const Center(
                      child: Text(
                        "No rooms available",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: RoomCard(room: room),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
