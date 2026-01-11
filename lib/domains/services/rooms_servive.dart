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

  // Move a tenant into a room and create the first payment
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

  // Tenant leaves a room
  void tenantLeaves(Tenant tenant) {
    if (tenant.roomId == null) return;

    final room = getRoomById(tenant.roomId);
    if (room != null) room.isOccupied = false;

    tenant.roomId = null;
  }

  // Process a payment and create the next month's payment
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

  // Get room by ID
  Room? getRoomById(String? roomId) {
    if (roomId == null) return null;
    try {
      return rooms.firstWhere((r) => r.roomId == roomId);
    } catch (_) {
      return null;
    }
  }

  // Get latest payment for a tenant
  Payment? getLatestPaymentForTenant(Tenant tenant) {
    final tenantPayments =
        payments.where((p) => p.tenantId == tenant.tenantId).toList();
    if (tenantPayments.isEmpty) return null;

    tenantPayments.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return tenantPayments.first;
  }

  // Get tenant's room number
  String? getTenantRoomNumber(Tenant tenant) {
    final room = getRoomById(tenant.roomId);
    return room?.roomNumber;
  }

  // Revenue functions
  double getCurrentMonthExpectedRevenue() {
    final now = DateTime.now();
    return payments
        .where((p) => p.dueDate.year == now.year && p.dueDate.month == now.month)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double getCurrentMonthCollectedRevenue() {
    final now = DateTime.now();
    return payments
        .where((p) =>
            p.dueDate.year == now.year &&
            p.dueDate.month == now.month &&
            p.paidDate != null)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  // Count upcoming and overdue payments
  int getCurrentMonthUpcomingCount() {
    final now = DateTime.now();
    return payments
        .where((p) =>
            p.dueDate.year == now.year &&
            p.dueDate.month == now.month &&
            !p.isPaid)
        .length;
  }

  int getOverdueCount() {
    final now = DateTime.now();
    return payments.where((p) => !p.isPaid && p.dueDate.isBefore(now)).length;
  }

  // Available rooms
  List<Room> getAvailableRooms() {
    return rooms.where((room) => !room.isOccupied).toList();
  }

  // Helper: calculate the same day next month
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
}
