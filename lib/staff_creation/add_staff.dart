import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../staff_list.dart';

class AddStaffPage extends StatefulWidget {
  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _ageController = TextEditingController();

  Future<void> _submitStaff() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('staff').add({
          'name': _nameController.text,
          'id': _idController.text,
          'age': int.parse(_ageController.text),
          'createdAt': Timestamp.now(),
        });

        // Go to staff list page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StaffListPage()),
        );
      } catch (e) {
        print('Error adding staff: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add staff: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Staff')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) => value!.isEmpty ? 'Enter ID' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter age' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitStaff,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
