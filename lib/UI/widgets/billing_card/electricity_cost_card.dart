import 'package:flutter/material.dart';

class ElectricityCostCard extends StatefulWidget {
  final double ratePerKwh;
  final ValueChanged<double> onChanged;

  const ElectricityCostCard({
    super.key,
    this.ratePerKwh = 0.2,
    required this.onChanged,
  });

  @override
  State<ElectricityCostCard> createState() => _ElectricityCostCardState();
}

class _ElectricityCostCardState extends State<ElectricityCostCard> {
  double kwhUsed = 0;

  @override
  Widget build(BuildContext context) {
    final cost = kwhUsed * widget.ratePerKwh;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.electric_bolt, color: Colors.white, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "kWh used: ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Spacer(),
                    Container(
                      height: 35,
                      width: 75,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "0",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 6),
                        ),
                        onChanged: (val) {
                          setState(() {
                            kwhUsed = double.tryParse(val) ?? 0;
                            widget.onChanged(kwhUsed);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Cost",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        "\$ ${cost.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}