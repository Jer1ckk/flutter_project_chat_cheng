import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import 'package:project/domains/services/rooms_servive.dart';
import '../../../../domains/models/payment.dart';
import '../../../widgets/user_payment_status_card.dart';
import '../billing/calculate_bill.dart';

class TenantsBillingScreen extends StatefulWidget {
  const TenantsBillingScreen({super.key, required this.roomService});
  final RoomService roomService;

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

  // Helper to determine days and late status
  Map<String, dynamic> _getPaymentStatus(Payment? payment) {
    if (payment == null) return {'days': 0, 'isLate': false};
    if (payment.isLate) return {'days': payment.daysLate, 'isLate': true};
    final diff = payment.dueDate.difference(DateTime.now()).inDays;
    return {'days': diff < 0 ? 0 : diff, 'isLate': false};
  }

  @override
  Widget build(BuildContext context) {
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

                        final status = _getPaymentStatus(latestPayment);
                        final int days = status['days'];
                        final bool isLate = status['isLate'];

                        return GestureDetector(
                          onTap: latestPayment == null
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

                                    // Save changes to file
                                    await widget.roomService.saveData();
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
