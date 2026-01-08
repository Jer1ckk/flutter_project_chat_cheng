import 'package:flutter/material.dart';
import 'package:project/UI/widgets/room_card.dart';
import 'package:project/domains/models/colors.dart';
import 'package:project/domains/services/rooms_servive.dart';
import '../../../../../domains/models/tenant.dart';
import '../../tenant/tenant_form.dart';

class AvailableRooms extends StatefulWidget {
  const AvailableRooms({super.key, required this.roomService});
  final RoomService roomService;

  @override
  State<AvailableRooms> createState() => _AvailableRoomsState();
}

class _AvailableRoomsState extends State<AvailableRooms> {
  @override
  Widget build(BuildContext context) {
    final availableRooms = widget.roomService.rooms
        .where((room) => !room.isOccupied)
        .toList();

    return Container(
      color: AppColors.purpleDeep.color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "${widget.roomService.rooms.length - availableRooms.length}/${widget.roomService.rooms.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${availableRooms.length} Available",
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
              child: ListView.builder(
                itemCount: availableRooms.length,
                itemBuilder: (context, index) {
                  final room = availableRooms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onTap: () async {
                        final tenant = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TenantForm(roomId: room.roomId),
                          ),
                        );

                        if (tenant != null && tenant is Tenant) {
                          setState(() {
                            widget.roomService.moveInTenant(tenant, room);
                          });

                          await widget.roomService.saveData();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${tenant.name} moved into ${room.roomNumber}",
                              ),
                            ),
                          );
                        }
                      },
                      child: RoomCard(room: room),
                    ),
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
