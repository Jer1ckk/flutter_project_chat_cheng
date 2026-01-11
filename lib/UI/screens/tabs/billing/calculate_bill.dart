import 'package:flutter/material.dart';

import '../../../../domains/models/colors.dart';
import '../../../widgets/billing_card/electricity_cost_card.dart';
import '../../../widgets/billing_card/rent_price_card.dart';
import '../../../widgets/billing_card/total_cost_card.dart';
import '../../../widgets/billing_card/water_cost_card.dart';

class CalculateBill extends StatefulWidget {
  const CalculateBill({super.key, required this.roomRent, required this.name});

  final double roomRent;
  final String name;

  @override
  State<CalculateBill> createState() => _CalculateBillState();
}

class _CalculateBillState extends State<CalculateBill> {
  double electricityUsed = 0;
  double waterUsed = 0;

  final double electricityRate = 0.2;
  final double waterRate = 0.2;

  void updateElectricity(double val) {
    setState(() {
      electricityUsed = val;
    });
  }

  void updateWater(double val) {
    setState(() {
      waterUsed = val;
    });
  }

  double get totalAmount =>
      widget.roomRent +
      electricityUsed * electricityRate +
      waterUsed * waterRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calculate Bill",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.purpleDeep.color,
      ),
      body: Container(
        color: AppColors.purpleDeep.color,
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                RentPriceCard(price: widget.roomRent),
                const SizedBox(height: 8),
                ElectricityCostCard(
                  ratePerKwh: electricityRate,
                  onChanged: updateElectricity,
                ),
                const SizedBox(height: 8),
                WaterCostCard(
                  ratePerCubicMeter: waterRate,
                  onChanged: updateWater,
                ),
                const SizedBox(height: 8),
                TotalCostCard(
                  rent: widget.roomRent,
                  electricity: electricityUsed * electricityRate,
                  water: waterUsed * waterRate,
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, totalAmount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleDeep.color,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Mark Paid",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
