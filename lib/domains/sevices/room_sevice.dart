import '../models/payment.dart';
import '../models/room.dart';
import '../models/tenant.dart';

class RoomService {
  List<Room> rooms = [];
  List<Tenant> tenants = [];
  List<Payment> payments = [];

  // -----------------------------
  // Add tenant to a room (Move In)
  // -----------------------------
  void moveInTenant(Tenant tenant, Room room) {

    // Update tenant
    tenant.roomId = room.roomId;
    tenant.isActive = true;

    // Update room
    room.isOccupied = true;

    // Optionally create first payment
    final now = DateTime.now();
    payments.add(Payment(
      tenantId: tenant.tenantId,
      roomId: room.roomId,
      year: now.year,
      month: now.month,
      amount: room.rent,
      dueDate: DateTime(now.year, now.month, 5), // due on 5th
    ));

    // Add tenant to list if not already
    if (!tenants.contains(tenant)) tenants.add(tenant);

  }

  // -----------------------------
  // Tenant Leaves Room
  // -----------------------------
  void tenantLeaves(Tenant tenant) {
    if (tenant.roomId == null) {
      return;
    }

    // Free the room
    final room = rooms.firstWhere((r) => r.roomId == tenant.roomId);
    room.isOccupied = false;

    // Update tenant
    tenant.isActive = false;
    tenant.roomId = null;

  }

  // -----------------------------
  // Mark Payment as Paid
  // -----------------------------
  void payPayment(Payment payment, DateTime date) {
    payment.markAsPaid(date);
  }

  // -----------------------------
  // Get all active tenants in a room
  // -----------------------------
  List<Tenant> getActiveTenantsInRoom(Room room) {
    return tenants
        .where((t) => t.isActive && t.roomId == room.roomId)
        .toList();
  }

  // -----------------------------
  // Check room status
  // -----------------------------
  bool isRoomOccupied(Room room) {
    return room.isOccupied;
  }
}