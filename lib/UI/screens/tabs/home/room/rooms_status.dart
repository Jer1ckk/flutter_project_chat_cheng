import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';

class RoomsStatus extends StatelessWidget {
  const RoomsStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.purpleDeep.color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "45/55",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "10 Rooms Available",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(child: Column(children: [

                  ],
                )),
            ),
          ],
        ),
      ),
    );
  }
}
