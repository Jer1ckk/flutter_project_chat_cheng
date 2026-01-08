import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../domains/models/room.dart';
import '../../domains/models/tenant.dart';
import '../../domains/models/payment.dart';

class RoomLocalDataSource {
  static const String _assetPath = 'assets/testing_data.json';

  /// Get the file in the device documents directory
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/room_data.json');
  }

  /// Load saved data if exists, otherwise fallback to asset
  Future<LoadedRoomData> load() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content);
        return _parseJsonData(json);
      }
    } catch (_) {
      // ignore errors, fallback to asset
    }

    // fallback to asset if file doesn't exist or error occurs
    try {
      final content = await rootBundle.loadString(_assetPath);
      final json = jsonDecode(content);
      return _parseJsonData(json);
    } catch (_) {
      // final fallback: empty lists
      return LoadedRoomData(rooms: [], tenants: [], payments: []);
    }
  }

  /// Save data to local file
  Future<void> save({
    required List<Room> rooms,
    required List<Tenant> tenants,
    required List<Payment> payments,
  }) async {
    final file = await _getLocalFile();

    final data = jsonEncode({
      'rooms': rooms.map((r) => _roomToJson(r)).toList(),
      'tenants': tenants.map((t) => _tenantToJson(t)).toList(),
      'payments': payments.map((p) => _paymentToJson(p)).toList(),
    });

    await file.writeAsString(data);
  }

  /// =======================
  /// JSON serialization
  /// =======================
  Map<String, dynamic> _roomToJson(Room r) => {
        'roomId': r.roomId,
        'roomNumber': r.roomNumber,
        'rent': r.rent,
        'isOccupied': r.isOccupied,
      };

  Room _roomFromJson(Map<String, dynamic> json) => Room(
        roomId: json['roomId'],
        roomNumber: json['roomNumber'],
        rent: (json['rent'] as num).toDouble(),
        isOccupied: json['isOccupied'] ?? false,
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

  Tenant _tenantFromJson(Map<String, dynamic> json) => Tenant(
        tenantId: json['tenantId'],
        name: json['name'],
        sex: json['sex'],
        phoneNumber: json['phoneNumber'],
        idCardNumber: json['idCardNumber'],
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        moveInDate: DateTime.parse(json['moveInDate']),
        reserveMoney: (json['reserveMoney'] as num).toDouble(),
        roomId: json['roomId'],
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

  Payment _paymentFromJson(Map<String, dynamic> json) => Payment(
        paymentId: json['paymentId'],
        tenantId: json['tenantId'],
        roomId: json['roomId'],
        amount: (json['amount'] as num).toDouble(),
        dueDate: DateTime.parse(json['dueDate']),
        isPaid: json['isPaid'] ?? false,
        paidDate: json['paidDate'] != null
            ? DateTime.parse(json['paidDate'])
            : null,
      );

  /// Parse full loaded JSON
  LoadedRoomData _parseJsonData(Map<String, dynamic> json) {
    final rooms = (json['rooms'] as List<dynamic>? ?? [])
        .map((r) => _roomFromJson(r as Map<String, dynamic>))
        .toList(growable: true);

    final tenants = (json['tenants'] as List<dynamic>? ?? [])
        .map((t) => _tenantFromJson(t as Map<String, dynamic>))
        .toList(growable: true);

    final payments = (json['payments'] as List<dynamic>? ?? [])
        .map((p) => _paymentFromJson(p as Map<String, dynamic>))
        .toList(growable: true);

    return LoadedRoomData(rooms: rooms, tenants: tenants, payments: payments);
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
