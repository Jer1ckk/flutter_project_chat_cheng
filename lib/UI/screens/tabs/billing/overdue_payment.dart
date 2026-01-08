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

  // Function to check if payment is late
  bool isPaymentLate(dynamic payment) {
    if (payment.isPaid) return false;
    final now = DateTime.now();
    return payment.dueDate.isBefore(now) || payment.dueDate.isAtSameMomentAs(now);
  }

  // Function to calculate days late
  int daysLate(dynamic payment) {
    if (!isPaymentLate(payment)) return 0;
    return DateTime.now().difference(payment.dueDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    // Filter tenants with overdue payments
    final filteredTenants = widget.roomService.tenants.where((tenant) {
      final payment = widget.roomService.getLatestPaymentForTenant(tenant);
      return payment != null &&
          isPaymentLate(payment) &&
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
        child: Padding(
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
                    ? const Center(child: Text("No overdue payments"))
                    : ListView.builder(
                        itemCount: filteredTenants.length,
                        itemBuilder: (context, index) {
                          final tenant = filteredTenants[index];
                          final payment = widget.roomService.getLatestPaymentForTenant(tenant)!;

                          return UserPaymentStatusCard(
                            name: tenant.name,
                            roomNumber: widget.roomService.getTenantRoomNumber(tenant) ?? "-",
                            days: daysLate(payment),
                            isLate: true,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
