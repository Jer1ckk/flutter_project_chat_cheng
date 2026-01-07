import '../models/payment.dart';
import '../models/room.dart';
import '../models/tenant.dart';

class RoomService {
  List<Room> rooms = [];
  List<Tenant> tenants = [];
  List<Payment> payments = [];

  RoomService({
    required this.payments,
    required this.tenants,
    required this.rooms,
  });

  // -----------------------------
  // Add tenant to a room (Move In)
  // -----------------------------
  void moveInTenant(Tenant tenant, Room room) {
    tenant.roomId = room.roomId;
    room.isOccupied = true;

    // Compute next month's due date (same day)
    final now = DateTime.now();
    final firstDueDate = _nextMonthDate(now);

    // Create first payment
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

  // -----------------------------
  // Tenant leaves room
  // -----------------------------
  void tenantLeaves(Tenant tenant) {
    if (tenant.roomId == null) return;
    final room = rooms.firstWhere((r) => r.roomId == tenant.roomId);
    room.isOccupied = false;
    tenant.roomId = null;
  }

  // -----------------------------
  // Mark payment as paid and generate next month payment
  // -----------------------------
  void payPayment(Payment payment, DateTime paidDate, double totalAmount) {
    // 1. Set the actual payment amount (rent + utilities)
    payment.amount = totalAmount;

    // 2. Mark current payment as paid
    payment.markAsPaid(paidDate);

    // 3. Generate next month's payment (same day, default to room rent only)
    final nextDueDate = _nextMonthDate(payment.dueDate);
    final room = getRoomById(payment.roomId);
    final nextAmount =
        room?.rent ?? payment.amount; // default next month: rent only

    payments.add(
      Payment(
        tenantId: payment.tenantId,
        roomId: payment.roomId,
        amount: nextAmount,
        dueDate: nextDueDate,
      ),
    );
  }

  // -----------------------------
  // Helper: compute next month date safely
  // -----------------------------
  DateTime _nextMonthDate(DateTime from) {
    int year = from.year;
    int month = from.month + 1;

    if (month > 12) {
      month = 1;
      year += 1;
    }

    int day = from.day;
    final daysInNextMonth = DateTime(year, month + 1, 0).day;
    if (day > daysInNextMonth) day = daysInNextMonth;

    return DateTime(year, month, day);
  }

  // -----------------------------
  // Get all active tenants in a room
  // -----------------------------
  List<Tenant> getActiveTenantsInRoom(Room room) {
    return tenants.where((t) => t.roomId == room.roomId).toList();
  }

  // -----------------------------
  // Check room status
  // -----------------------------
  bool isRoomOccupied(Room room) => room.isOccupied;

  // -----------------------------
  // Get room object by roomId
  // -----------------------------
  Room? getRoomById(String roomId) {
    try {
      return rooms.firstWhere((r) => r.roomId == roomId);
    } catch (e) {
      return null;
    }
  }

  // -----------------------------
  // Get latest payment for a tenant
  // -----------------------------
  Payment? getLatestPaymentForTenant(Tenant tenant) {
    final tenantPayments = payments
        .where((p) => p.tenantId == tenant.tenantId)
        .toList();
    if (tenantPayments.isEmpty) return null;
    tenantPayments.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return tenantPayments.first;
  }

  // -----------------------------
  // Get tenant's room number
  // -----------------------------
  String? getTenantRoomNumber(Tenant tenant) {
    if (tenant.roomId == null) return null;
    try {
      final room = rooms.firstWhere((r) => r.roomId == tenant.roomId);
      return room.roomNumber;
    } catch (e) {
      return null;
    }
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
}
