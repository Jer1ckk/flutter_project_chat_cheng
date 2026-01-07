import 'package:flutter/material.dart';
import '../../../../domains/models/colors.dart';
import '../../../../domains/services/rooms_servive.dart';
import '../../../widgets/payment_status_card.dart';
import '../../../widgets/revenue_card.dart';
import '../../../widgets/room_status_card.dart';
import '../../../widgets/user_payment_status_card.dart';
import '../billing/overdue_payment.dart';
import '../billing/upcoming_payment.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.roomService});
  final RoomService roomService;

  @override
  Widget build(BuildContext context) {
    final upcomingCount = roomService.tenants.where((tenant) {
      final payment = roomService.getLatestPaymentForTenant(tenant);
      return payment != null && !payment.isLate;
    }).length;

    final overdueCount = roomService.tenants.where((tenant) {
      final payment = roomService.getLatestPaymentForTenant(tenant);
      return payment != null && payment.isLate;
    }).length;

    return Container(
      decoration: BoxDecoration(color: AppColors.purpleDeep.color),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            RoomStatusCard(roomService: roomService),
            const SizedBox(height: 10),

            Row(
              children: [
                // Upcoming
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            UpcomingPayment(roomService: roomService),
                      ),
                    );
                  },
                  child: PaymentStatusCard(
                    icon: Icons.calendar_month,
                    text: "Upcoming",
                    roomCount: upcomingCount,
                  ),
                ),
                const Spacer(),
                // Overdue
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OverduePayment(roomService: roomService),
                      ),
                    );
                  },
                  child: PaymentStatusCard(
                    icon: Icons.warning_amber_rounded,
                    text: "Overdue",
                    roomCount: overdueCount,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RevenueCard(
              currentMonthRevenue: roomService.getCurrentMonthRevenue(),
            ),

            // Upcoming Payment list
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Upcoming Payment",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: roomService.tenants
                      .where((t) {
                        final payment = roomService.getLatestPaymentForTenant(
                          t,
                        );
                        return payment != null && !payment.isLate;
                      })
                      .map((tenant) {
                        final payment = roomService.getLatestPaymentForTenant(
                          tenant,
                        )!;
                        final diff = payment.dueDate
                            .difference(DateTime.now())
                            .inDays;
                        return UserPaymentStatusCard(
                          name: tenant.name,
                          roomNumber:
                              roomService.getTenantRoomNumber(tenant) ?? "-",
                          days: diff < 0 ? 0 : diff,
                          isLate: false,
                        );
                      })
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
