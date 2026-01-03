import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';

class UserPaymentStatusCard extends StatelessWidget {
  const UserPaymentStatusCard({
    super.key,
    required this.name,
    required this.roomNumber,
     required this.days,
      required this.isLate,
    
  });
  final String name;
  final String roomNumber;
  final int days;
  final bool isLate;

  Color get statusColor => isLate ? Colors.red : Colors.green;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleLight.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.purpleDeep.color,
              size: 40,
            ),
          ),

          const SizedBox(width: 16),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Room $roomNumber",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),

          Container(
            width: 90,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$days Days",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
