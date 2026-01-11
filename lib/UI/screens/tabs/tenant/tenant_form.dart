import 'package:flutter/material.dart';
import 'package:project/domains/models/colors.dart';
import '../../../../domains/models/tenant.dart';

class TenantForm extends StatefulWidget {
  const TenantForm({super.key, required this.roomId});
  final String roomId;

  @override
  State<TenantForm> createState() => _TenantFormState();
}

class _TenantFormState extends State<TenantForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String phoneNumber = '';
  String idCard = '';
  double reserveMoney = 0.0;
  DateTime? dateOfBirth;
  DateTime? enterDate;
  String? sex;

  final List<String> sexes = ['Male', 'Female'];

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "This field is required";
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter amount";
    if (double.tryParse(value) == null) return "Enter valid number";
    return null;
  }

  void _onNameChanged(String value) => name = value;
  void _onPhoneChanged(String value) => phoneNumber = value;
  void _onIdCardChanged(String value) => idCard = value;
  void _onReserveChanged(String value) =>
      reserveMoney = double.tryParse(value) ?? 0;
  void _onSexChanged(String? value) => setState(() => sex = value);

  Future<void> _pickDate(bool isDob) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isDob) {
          dateOfBirth = picked;
        } else {
          enterDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (dateOfBirth == null || enterDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select both dates")));
      return;
    }

    if (sex == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select sex")));
      return;
    }

    final tenant = Tenant(
      name: name,
      phoneNumber: phoneNumber,
      idCardNumber: idCard,
      sex: sex!,
      moveInDate: DateTime(enterDate!.year, enterDate!.month, enterDate!.day),
      reserveMoney: reserveMoney,
      dateOfBirth: DateTime(
        dateOfBirth!.year,
        dateOfBirth!.month,
        dateOfBirth!.day,
      ),
      roomId: widget.roomId,
    );

    Navigator.pop(context, tenant);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      name = '';
      phoneNumber = '';
      idCard = '';
      reserveMoney = 0.0;
      sex = null;
      dateOfBirth = null;
      enterDate = null;
    });
  }

  InputDecoration _blackInput(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tenant"),
        backgroundColor: AppColors.purpleDeep.color,
      ),
      body: Container(
        color: AppColors.purpleLight.color,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NAME
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: _blackInput("Name"),
                validator: _requiredValidator,
                onChanged: _onNameChanged,
              ),
              const SizedBox(height: 12),
              // PHONE
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: _blackInput("Phone Number"),
                validator: _requiredValidator,
                keyboardType: TextInputType.phone,
                onChanged: _onPhoneChanged,
              ),
              const SizedBox(height: 12),
              // ID CARD
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: _blackInput("ID Card Number"),
                validator: _requiredValidator,
                onChanged: _onIdCardChanged,
              ),
              const SizedBox(height: 12),
              // RESERVE MONEY
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: _blackInput("Reserve Money"),
                validator: _numberValidator,
                keyboardType: TextInputType.number,
                onChanged: _onReserveChanged,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: sex,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black),
                decoration: _blackInput("Sex"),
                items: sexes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: _onSexChanged,
                validator: (val) => val == null ? "Please select sex" : null,
              ),
              const SizedBox(height: 12),
              // DOB
              ListTile(
                tileColor: Colors.white,
                title: const Text(
                  "Date of Birth",
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  dateOfBirth == null
                      ? "Select date"
                      : "${dateOfBirth!.year}-${dateOfBirth!.month}-${dateOfBirth!.day}",
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.black),
                onTap: () => _pickDate(true),
              ),
              const SizedBox(height: 12),
              // MOVE-IN
              ListTile(
                tileColor: Colors.white,
                title: const Text(
                  "Move-in Date",
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  enterDate == null
                      ? "Select date"
                      : "${enterDate!.year}-${enterDate!.month}-${enterDate!.day}",
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.black),
                onTap: () => _pickDate(false),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitForm,
                      child: const Text("Add"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _resetForm,
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
