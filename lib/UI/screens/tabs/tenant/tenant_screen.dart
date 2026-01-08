import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import 'package:project/domains/services/rooms_servive.dart';
import '../../../widgets/tenant_card.dart';
import 'tenant_detail.dart';

class TenantScreen extends StatefulWidget {
  const TenantScreen({super.key, required this.roomService});
  final RoomService roomService;

  @override
  State<TenantScreen> createState() => _TenantScreenState();
}

class _TenantScreenState extends State<TenantScreen> {
  String searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTenants = widget.roomService.tenants.where((tenant) {
      return tenant.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tenants",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.purpleDeep.color,
      ),
      body: Container(
        color: AppColors.purpleDeep.color,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search tenants...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // List
            Expanded(
              child: filteredTenants.isEmpty
                  ? const Center(
                      child: Text(
                        "No tenants found",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTenants.length,
                      itemBuilder: (context, index) {
                        final tenant = filteredTenants[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TenantDetail(
                                  tenant: tenant,
                                  roomNumber:
                                      widget.roomService.getTenantRoomNumber(
                                        tenant,
                                      ) ??
                                      "-",
                                ),
                              ),
                            );
                          },
                          child: TenantCard(
                            name: tenant.name,
                            roomNumber:
                                widget.roomService.getTenantRoomNumber(
                                  tenant,
                                ) ??
                                "-",
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
