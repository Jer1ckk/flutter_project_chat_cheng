import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Tenant {
  final String tenantId;
  final String name;
  final String phoneNumber;
  String? roomId;
  final DateTime moveInDate;
  bool isActive;

  Tenant({
    required this.name,
    required this.phoneNumber,
    this.roomId,
    required this.moveInDate,
    this.isActive = true,
  }) : tenantId = uuid.v4();

  void leave() {
    isActive = false;
    roomId = null;
  }
}