import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import '../../../../domains/services/rooms_servive.dart';
import '../../../widgets/user_payment_status_card.dart';

class OverduePayment extends StatefulWidget {
  const OverduePayment({super.key, required this.roomService});
  final RoomService roomService;

  @override
  State<OverduePayment> createState() => _OverduePaymentState();
}

class _OverduePaymentState extends State<OverduePayment> {
  String searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTenants = widget.roomService.tenants.where((tenant) {
      final payment = widget.roomService.getLatestPaymentForTenant(tenant);
      return payment != null &&
          widget.roomService.isPaymentLate(payment) &&
          tenant.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overdue Payments",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.purpleDeep.color,
      ),
      body: Container(
        color: AppColors.purpleDeep.color,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                        "No overdue payments",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTenants.length,
                      itemBuilder: (context, index) {
                        final tenant = filteredTenants[index];
                        final payment = widget.roomService
                            .getLatestPaymentForTenant(tenant)!;

                        return UserPaymentStatusCard(
                          name: tenant.name,
                          roomNumber:
                              widget.roomService.getTenantRoomNumber(tenant) ??
                              "-",
                          days: widget.roomService.daysLate(payment),
                          isLate: true,
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
