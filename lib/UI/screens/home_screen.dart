import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project/UI/screens/tabs/home/home_tab.dart';
import 'package:project/UI/screens/tabs/home/room/available_rooms.dart';
import 'package:project/domains/models/colors.dart';
import 'package:project/domains/services/rooms_servive.dart';

import 'tabs/billing/tenants_billing_screen.dart';
import 'tabs/tenant/tenant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.roomService,
    required this.onSave,
  });

  final RoomService roomService;
  final Future<void> Function() onSave;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeTab(roomService: widget.roomService),
      AvailableRooms(roomService: widget.roomService),
      TenantsBillingScreen(roomService: widget.roomService),
      TenantScreen(roomService: widget.roomService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8D63A6),
        centerTitle: false,
        title: const Text(
          "CHAT CHENG",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        color: AppColors.purpleDeep.color,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            backgroundColor: AppColors.purpleDeep.color,
            gap: 8,
            activeColor: const Color(0xFF8D63A6),
            tabBackgroundColor: const Color(0xFFE2C7FF),
            padding: const EdgeInsets.all(12),

            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.person_add, text: 'Add Tenant'),
              GButton(icon: Icons.receipt_long, text: 'Billing'),
              GButton(icon: Icons.people, text: 'Tenants'),
            ],
          ),
        ),
      ),
    );
  }
}
