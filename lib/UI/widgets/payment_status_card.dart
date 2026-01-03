import 'package:flutter/material.dart';
import '../../domains/models/colors.dart';

class PaymentStatusCard extends StatelessWidget {
  const PaymentStatusCard({
    super.key,
    required this.icon,
    required this.text,
    required this.roomCount,
    this.color = Colors.white,
  });

  final IconData icon;
  final String text;
  final int roomCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.purpleLight.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 30),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Payment",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),

              const Spacer(),

              const Icon(Icons.error_outline, color: Colors.white, size: 30),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "$roomCount Rooms",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
