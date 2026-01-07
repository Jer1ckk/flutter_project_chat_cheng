import 'package:flutter/material.dart';
import 'package:project/domains/models/tenant.dart';
import '../../../../domains/models/colors.dart';

class TenantDetail extends StatelessWidget {
  const TenantDetail({super.key, required this.tenant, required this.roomNumber});
  final Tenant tenant;
  final String roomNumber;

  bool isMale(String sex) => sex == "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purpleDeep.color,
      appBar: AppBar(
        backgroundColor: AppColors.purpleDeep.color,
        title: const Text("Tenant Detail"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.purpleLight.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
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

                // Name
                Text(
                  tenant.name,
                  style: TextStyle(
                    color: AppColors.purpleDeep.color,
                    decoration: TextDecoration.none,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Tel: ${tenant.phoneNumber}",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: AppColors.purpleDeep.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Info boxes
                Row(
                  children: [
                    Expanded(
                      child: InfoBox(
                        icon: Icons.meeting_room,
                        text: "Room: $roomNumber",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoBox(
                        icon: isMale(tenant.sex)
                            ? Icons.male
                            : Icons.female_sharp,
                        text: tenant.sex,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: InfoBox(
                        icon: Icons.calendar_month,
                        text:
                            "Born:\n${tenant.dateOfBirth.year}-${tenant.dateOfBirth.month}-${tenant.dateOfBirth.day}",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoBox(
                        icon: Icons.badge,
                        text: "ID: ${tenant.idCardNumber}",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: InfoBox(
                        icon: Icons.edit_calendar,
                        text:
                            "Enter:\n${tenant.moveInDate.year}-${tenant.moveInDate.month}-${tenant.moveInDate.day}",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoBox(
                        icon: Icons.attach_money,
                        text: "Reserve: ${tenant.reserveMoney}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 219, 249),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.purpleDeep.color, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: AppColors.purpleDeep.color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
