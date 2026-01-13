import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import '../../../../domains/services/rooms_servive.dart';
import '../../../widgets/user_payment_status_card.dart';
import '../billing/calculate_bill.dart';

class TenantsBillingScreen extends StatefulWidget {
  const TenantsBillingScreen({
    super.key,
    required this.roomService,
    required this.onSave,
  });

  final RoomService roomService;
  final Future<void> Function() onSave;

  @override
  State<TenantsBillingScreen> createState() => _TenantsBillingScreenState();
}

class _TenantsBillingScreenState extends State<TenantsBillingScreen> {
  String searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter tenants by search query
    final filteredTenants = widget.roomService.tenants.where((tenant) {
      return tenant.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tenant Billing",
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

            // Tenant list
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
                        final latestPayment = widget.roomService
                            .getLatestPaymentForTenant(tenant);

                        if (latestPayment == null) {
                          return const SizedBox(); // Skip tenants with no payment
                        }

                        final now = DateTime.now();
                        final dueDate = latestPayment.dueDate;

                        // Calculate days dynamically
                        final int days;
                        final bool isLate;

                        if (latestPayment.isPaid) {
                          days = 0;
                          isLate = false;
                        } else if (dueDate.isBefore(now)) {
                          // Overdue
                          days = now.difference(dueDate).inDays;
                          isLate = true;
                        } else {
                          // Upcoming
                          days = dueDate.difference(now).inDays;
                          isLate = false;
                        }

                        return GestureDetector(
                          onTap: latestPayment.isPaid
                              ? null
                              : () async {
                                  final room = widget.roomService.getRoomById(
                                    tenant.roomId!,
                                  );
                                  if (room == null) return;

                                  final double? total =
                                      await Navigator.push<double>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CalculateBill(
                                            roomRent: room.rent,
                                            name: tenant.name,
                                          ),
                                        ),
                                      );

                                  if (total != null) {
                                    setState(() {
                                      widget.roomService.payPayment(
                                        latestPayment,
                                        DateTime.now(),
                                        total,
                                      );
                                    });

                                    await widget.onSave();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${tenant.name} payment recorded: \$${total.toStringAsFixed(2)}",
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: UserPaymentStatusCard(
                            name: tenant.name,
                            roomNumber:
                                widget.roomService.getTenantRoomNumber(
                                  tenant,
                                ) ??
                                "-",
                            days: days,
                            isLate: isLate,
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
