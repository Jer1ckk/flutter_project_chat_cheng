import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Payment {
  final String paymentId;
  final String tenantId;
  final String roomId;
  final int year;
  final int month;
  double amount;
  final DateTime dueDate;
  bool isPaid;
  DateTime? paidDate;
  int lateDays;

  Payment({
    required this.tenantId,
    required this.roomId,
    required this.year,
    required this.month,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.paidDate,
    this.lateDays = 0,
  }) : paymentId = uuid.v4();

  void markAsPaid(DateTime date) {
    paidDate = date;
    lateDays = date.isAfter(dueDate) ? date.difference(dueDate).inDays : 0;
    isPaid = true;
  }

  bool get isLate => !isPaid && DateTime.now().isAfter(dueDate);

  int get daysLate {
    if (isPaid) return lateDays;
    if (DateTime.now().isAfter(dueDate)) {
      return DateTime.now().difference(dueDate).inDays;
    }
    return 0;
  }

  int get daysUntilDue {
    final diff = dueDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }
}