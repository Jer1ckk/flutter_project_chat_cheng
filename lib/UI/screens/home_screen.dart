import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8D63A6),
        centerTitle: false,
        title: Text("CHAT CHENG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.white,
            gap: 8,
            activeColor: Color(0xFF8D63A6),
            tabBackgroundColor: Color(0xFFE2C7FF),
            padding: EdgeInsets.all(20),
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
