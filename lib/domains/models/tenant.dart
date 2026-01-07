import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Tenant {
  final String tenantId;
  final String name;
  final String sex;
  final String phoneNumber;
  final String idCardNumber;
  final DateTime dateOfBirth;
  final DateTime moveInDate;
  final double reserveMoney;
  String? roomId;

  Tenant({
    required this.name,
    required this.phoneNumber,
    this.roomId,
    required this.moveInDate,
    required this.reserveMoney,
    required this.idCardNumber,
    required this.dateOfBirth, required this.sex,
  }) : tenantId = uuid.v4();

  void leave() {
    roomId = null;
  }

  bool isActive() {
    if (roomId == null) {
      return false;
    }
    return true;
  }
}
