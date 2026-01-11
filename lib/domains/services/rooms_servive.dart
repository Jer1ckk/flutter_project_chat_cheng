import '../models/payment.dart';
import '../models/room.dart';
import '../models/tenant.dart';

class RoomService {
  List<Room> rooms;
  List<Tenant> tenants;
  List<Payment> payments;

  RoomService({
    required this.rooms,
    required this.tenants,
    required this.payments,
  });

  void moveInTenant(Tenant tenant, Room room) {
    tenant.roomId = room.roomId;
    room.isOccupied = true;

    final firstDueDate = _nextMonthDate(DateTime.now());

    payments.add(
      Payment(
        tenantId: tenant.tenantId,
        roomId: room.roomId,
        amount: room.rent,
        dueDate: firstDueDate,
      ),
    );

    if (!tenants.contains(tenant)) tenants.add(tenant);
  }

  void tenantLeaves(Tenant tenant) {
    if (tenant.roomId == null) return;

    final room = getRoomById(tenant.roomId);
    if (room != null) room.isOccupied = false;

    tenant.roomId = null;
  }

  void payPayment(Payment payment, DateTime paidDate, double totalAmount) {
    payment.amount = totalAmount;
    payment.markAsPaid(paidDate);

    final nextDueDate = _nextMonthDate(payment.dueDate);
    final room = getRoomById(payment.roomId);
    final nextAmount = room?.rent ?? payment.amount;

    payments.add(
      Payment(
        tenantId: payment.tenantId,
        roomId: payment.roomId,
        amount: nextAmount,
        dueDate: nextDueDate,
      ),
    );
  }

  Room? getRoomById(String? roomId) {
    if (roomId == null) return null;
    try {
      return rooms.firstWhere((r) => r.roomId == roomId);
    } catch (_) {
      return null;
    }
  }

  Payment? getLatestPaymentForTenant(Tenant tenant) {
    final tenantPayments = payments
        .where((p) => p.tenantId == tenant.tenantId)
        .toList();
    if (tenantPayments.isEmpty) return null;

    tenantPayments.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return tenantPayments.first;
  }

  String? getTenantRoomNumber(Tenant tenant) {
    final room = getRoomById(tenant.roomId);
    return room?.roomNumber;
  }

  double getCurrentMonthExpectedRevenue() {
    final now = DateTime.now();
    return payments
        .where(
          (p) => p.dueDate.year == now.year && p.dueDate.month == now.month,
        )
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double getCurrentMonthCollectedRevenue() {
    final now = DateTime.now();
    return payments
        .where(
          (p) =>
              p.dueDate.year == now.year &&
              p.dueDate.month == now.month &&
              p.paidDate != null,
        )
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  bool isPaymentLate(Payment payment) {
    return !payment.isPaid && payment.dueDate.isBefore(DateTime.now());
  }

  int daysLate(Payment payment) {
    if (!isPaymentLate(payment)) return 0;
    return DateTime.now().difference(payment.dueDate).inDays;
  }

  int daysUntilDue(Payment payment) {
    if (isPaymentLate(payment)) return 0;
    return payment.dueDate.difference(DateTime.now()).inDays;
  }

  DateTime _nextMonthDate(DateTime from) {
    int year = from.year;
    int month = from.month + 1;

    if (month > 12) {
      month = 1;
      year += 1;
    }

    int day = from.day;
    final maxDay = DateTime(year, month + 1, 0).day;
    if (day > maxDay) day = maxDay;

    return DateTime(year, month, day);
  }

  int getCurrentMonthUpcomingCount() {
    final now = DateTime.now();
    return payments
        .where(
          (p) =>
              p.dueDate.year == now.year &&
              p.dueDate.month == now.month &&
              !p.isPaid,
        )
        .length;
  }

  int getOverdueCount() {
    final now = DateTime.now();
    return payments.where((p) => !p.isPaid && p.dueDate.isBefore(now)).length;
  }

  List<Room> getAvailableRooms() {
    return rooms.where((room) => !room.isOccupied).toList();
  }
}
