import '../../data/storage/room_local_data_source.dart';
import '../models/payment.dart';
import '../models/room.dart';
import '../models/tenant.dart';

class RoomService {
  final RoomLocalDataSource localDataSource;

  // All lists are growable
  List<Room> rooms = [];
  List<Tenant> tenants = [];
  List<Payment> payments = [];

  RoomService({required this.localDataSource});

  // =============================
  // LOAD data from local storage
  // =============================
  Future<void> loadData() async {
    final loaded = await localDataSource.load();

    rooms = loaded.rooms.toList(growable: true);
    tenants = loaded.tenants.toList(growable: true);
    payments = loaded.payments.toList(growable: true);
  }

  // =============================
  // SAVE data to local storage
  // =============================
  Future<void> saveData() async {
    await localDataSource.save(
      rooms: rooms,
      tenants: tenants,
      payments: payments,
    );
  }

  // =============================
  // ROOM/TENANT operations
  // =============================

  /// Moves a tenant into a room and creates the first payment
  Future<void> moveInTenant(Tenant tenant, Room room) async {
    tenant.roomId = room.roomId;
    room.isOccupied = true;

    final firstDueDate = _nextMonthDate(DateTime.now());

    payments.add(Payment(
      tenantId: tenant.tenantId,
      roomId: room.roomId,
      amount: room.rent,
      dueDate: firstDueDate,
    ));

    if (!tenants.contains(tenant)) tenants.add(tenant);

    await saveData(); // persist immediately
  }

  /// Tenant leaves a room
  Future<void> tenantLeaves(Tenant tenant) async {
    if (tenant.roomId == null) return;

    final room = getRoomById(tenant.roomId);
    if (room != null) room.isOccupied = false;
    tenant.roomId = null;

    await saveData();
  }

  // =============================
  // PAYMENTS operations
  // =============================

  /// Pay a payment and schedule next month
  Future<void> payPayment(Payment payment, DateTime paidDate, double totalAmount) async {
    payment.amount = totalAmount;
    payment.markAsPaid(paidDate);

    final nextDueDate = _nextMonthDate(payment.dueDate);
    final room = getRoomById(payment.roomId);
    final nextAmount = room?.rent ?? payment.amount;

    payments.add(Payment(
      tenantId: payment.tenantId,
      roomId: payment.roomId,
      amount: nextAmount,
      dueDate: nextDueDate,
    ));

    await saveData();
  }

  // =============================
  // HELPERS
  // =============================

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

  Room? getRoomById(String? roomId) {
    if (roomId == null) return null;
    try {
      return rooms.firstWhere((r) => r.roomId == roomId);
    } catch (_) {
      return null;
    }
  }

  List<Tenant> getActiveTenantsInRoom(Room room) =>
      tenants.where((t) => t.roomId == room.roomId).toList();

  bool isRoomOccupied(Room room) => room.isOccupied;

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
}
