import 'package:uuid/uuid.dart';
import 'package:project/domains/models/payment.dart';
import '../../domains/models/room.dart';
import '../../domains/models/tenant.dart';

// UUID generator
final uuid = Uuid();

// Sample Rooms
final List<Room> sampleRooms = [
  Room(roomNumber: 'A001', rent: 150, isOccupied: true),
  Room(roomNumber: 'A002', rent: 160, isOccupied: true),
  Room(roomNumber: 'A003', rent: 170, isOccupied: true),
  Room(roomNumber: 'A004', rent: 180, isOccupied: true),
  Room(roomNumber: 'A005', rent: 190, isOccupied: true),
  Room(roomNumber: 'A006', rent: 200, isOccupied: false),
  Room(roomNumber: 'A007', rent: 210, isOccupied: false),
  Room(roomNumber: 'A008', rent: 220, isOccupied: false),
  Room(roomNumber: 'A009', rent: 230, isOccupied: false),
  Room(roomNumber: 'A010', rent: 240, isOccupied: false),
];

// Sample Tenants (automatically generate tenantId)
final List<Tenant> sampleTenants = [
  Tenant(
    name: "Alice Smith",
    phoneNumber: "0123456789",
    sex: "Female",
    idCardNumber: "ID1001",
    dateOfBirth: DateTime(1995, 5, 12),
    moveInDate: DateTime(2026, 1, 4),
    reserveMoney: 500.0,
    roomId: sampleRooms[0].roomId, // A001
  ),
  Tenant(
    name: "Bob Johnson",
    phoneNumber: "0987654321",
    sex: "Male",
    idCardNumber: "ID1002",
    dateOfBirth: DateTime(1990, 8, 20),
    moveInDate: DateTime(2026, 1, 2),
    reserveMoney: 600.0,
    roomId: sampleRooms[1].roomId, // A002
  ),
  Tenant(
    name: "Catherine Lee",
    phoneNumber: "0112233445",
    sex: "Female",
    idCardNumber: "ID1003",
    dateOfBirth: DateTime(1998, 3, 15),
    moveInDate: DateTime(2026, 1, 5),
    reserveMoney: 450.0,
    roomId: sampleRooms[2].roomId, // A003
  ),
  Tenant(
    name: "David Brown",
    phoneNumber: "0223344556",
    sex: "Male",
    idCardNumber: "ID1004",
    dateOfBirth: DateTime(1992, 7, 30),
    moveInDate: DateTime(2026, 1, 6),
    reserveMoney: 550.0,
    roomId: sampleRooms[3].roomId, // A004
  ),
  Tenant(
    name: "Eva Green",
    phoneNumber: "0334455667",
    sex: "Female",
    idCardNumber: "ID1005",
    dateOfBirth: DateTime(1996, 12, 10),
    moveInDate: DateTime(2026, 1, 3),
    reserveMoney: 480.0,
    roomId: sampleRooms[4].roomId, // A005
  ),
];

// Sample Payments (use tenantId from sampleTenants)
final List<Payment> samplePayments = [
  Payment(
    tenantId: sampleTenants[0].tenantId,
    roomId: sampleRooms[0].roomId,

    amount: 250,
    dueDate: DateTime(2026, 1, 5),
  ),
  Payment(
    tenantId: sampleTenants[1].tenantId,
    roomId: sampleRooms[1].roomId,

    amount: 250,
    dueDate: DateTime(2026, 1, 3),
  ),
  Payment(
    tenantId: sampleTenants[2].tenantId,
    roomId: sampleRooms[2].roomId,

    amount: 260,
    dueDate: DateTime(2026, 1, 15),
  ),
  Payment(
    tenantId: sampleTenants[3].tenantId,
    roomId: sampleRooms[3].roomId,

    amount: 260,
    dueDate: DateTime(2026, 1, 2),
  ),
  Payment(
    tenantId: sampleTenants[4].tenantId,
    roomId: sampleRooms[4].roomId,
  
    amount: 270,
    dueDate: DateTime(2026, 1, 1),
  ),
];
