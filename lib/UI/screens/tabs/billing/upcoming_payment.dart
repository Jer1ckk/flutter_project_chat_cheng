import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import '../../../../domains/services/rooms_servive.dart';
import '../../../widgets/user_payment_status_card.dart';

class UpcomingPayment extends StatefulWidget {
  const UpcomingPayment({super.key, required this.roomService});
  final RoomService roomService;

  @override
  State<UpcomingPayment> createState() => _UpcomingPaymentState();
}

class _UpcomingPaymentState extends State<UpcomingPayment> {
  String searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter tenants with upcoming payments
    final filteredTenants = widget.roomService.tenants.where((tenant) {
      final payment = widget.roomService.getLatestPaymentForTenant(tenant);
      return payment != null &&
          !widget.roomService.isPaymentLate(payment) && // use service method
          tenant.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upcoming Payments",
          style: TextStyle(color: Colors.white),
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
                        "No upcoming payments",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTenants.length,
                      itemBuilder: (context, index) {
                        final tenant = filteredTenants[index];
                        final payment = widget.roomService
                            .getLatestPaymentForTenant(tenant)!;

                        final daysUntilDue = widget.roomService.daysUntilDue(
                          payment,
                        );

                        return UserPaymentStatusCard(
                          name: tenant.name,
                          roomNumber:
                              widget.roomService.getTenantRoomNumber(tenant) ??
                              "-",
                          days: daysUntilDue,
                          isLate: false,
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
