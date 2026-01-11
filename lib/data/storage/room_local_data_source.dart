import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../domains/models/payment.dart';
import '../../domains/models/room.dart';
import '../../domains/models/tenant.dart';

class RoomLocalDataSource {
  static const String _assetPath = 'assets/data.json';

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/room_data.json');
  }

  Future<LoadedRoomData> load() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        return _parse(json);
      }
    } catch (_) {}

    try {
      final json = jsonDecode(await rootBundle.loadString(_assetPath));
      return _parse(json);
    } catch (_) {
      return LoadedRoomData(rooms: [], tenants: [], payments: []);
    }
  }

  Future<void> save({
    required List<Room> rooms,
    required List<Tenant> tenants,
    required List<Payment> payments,
  }) async {
    final file = await _getLocalFile();

    await file.writeAsString(jsonEncode({
      'rooms': rooms.map(_roomToJson).toList(),
      'tenants': tenants.map(_tenantToJson).toList(),
      'payments': payments.map(_paymentToJson).toList(),
    }));
  }

  // =============================
  // JSON helpers
  // =============================

  Map<String, dynamic> _roomToJson(Room r) => {
        'roomId': r.roomId,
        'roomNumber': r.roomNumber,
        'rent': r.rent,
        'isOccupied': r.isOccupied,
      };

  Room _roomFromJson(Map<String, dynamic> j) => Room(
        roomId: j['roomId'],
        roomNumber: j['roomNumber'],
        rent: (j['rent'] as num).toDouble(),
        isOccupied: j['isOccupied'] ?? false,
      );

  Map<String, dynamic> _tenantToJson(Tenant t) => {
        'tenantId': t.tenantId,
        'name': t.name,
        'sex': t.sex,
        'phoneNumber': t.phoneNumber,
        'idCardNumber': t.idCardNumber,
        'dateOfBirth': t.dateOfBirth.toIso8601String(),
        'moveInDate': t.moveInDate.toIso8601String(),
        'reserveMoney': t.reserveMoney,
        'roomId': t.roomId,
      };

  Tenant _tenantFromJson(Map<String, dynamic> j) => Tenant(
        tenantId: j['tenantId'],
        name: j['name'],
        sex: j['sex'],
        phoneNumber: j['phoneNumber'],
        idCardNumber: j['idCardNumber'],
        dateOfBirth: DateTime.parse(j['dateOfBirth']),
        moveInDate: DateTime.parse(j['moveInDate']),
        reserveMoney: (j['reserveMoney'] as num).toDouble(),
        roomId: j['roomId'],
      );

  Map<String, dynamic> _paymentToJson(Payment p) => {
        'paymentId': p.paymentId,
        'tenantId': p.tenantId,
        'roomId': p.roomId,
        'amount': p.amount,
        'dueDate': p.dueDate.toIso8601String(),
        'isPaid': p.isPaid,
        'paidDate': p.paidDate?.toIso8601String(),
      };

  Payment _paymentFromJson(Map<String, dynamic> j) => Payment(
        paymentId: j['paymentId'],
        tenantId: j['tenantId'],
        roomId: j['roomId'],
        amount: (j['amount'] as num).toDouble(),
        dueDate: DateTime.parse(j['dueDate']),
        isPaid: j['isPaid'] ?? false,
        paidDate: j['paidDate'] != null
            ? DateTime.parse(j['paidDate'])
            : null,
      );

  LoadedRoomData _parse(Map<String, dynamic> json) {
    return LoadedRoomData(
      rooms: (json['rooms'] ?? []).map<Room>((r) => _roomFromJson(r)).toList(),
      tenants:
          (json['tenants'] ?? []).map<Tenant>((t) => _tenantFromJson(t)).toList(),
      payments: (json['payments'] ?? [])
          .map<Payment>((p) => _paymentFromJson(p))
          .toList(),
    );
  }
}

class LoadedRoomData {
  final List<Room> rooms;
  final List<Tenant> tenants;
  final List<Payment> payments;

  LoadedRoomData({
    required this.rooms,
    required this.tenants,
    required this.payments,
  });
}
