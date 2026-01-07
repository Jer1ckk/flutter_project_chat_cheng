import 'package:flutter/material.dart';

class TotalCostCard extends StatelessWidget {
  final double rent;
  final double electricity;
  final double water;

  const TotalCostCard({
    super.key,
    required this.rent,
    required this.electricity,
    required this.water,
  });

  double get total => rent + electricity + water;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6C3483),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money, color: Colors.white,size: 40,),
          SizedBox(width: 12,),
          const Text(
            "Total Cost",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: Text(
              "\$ ${total.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
