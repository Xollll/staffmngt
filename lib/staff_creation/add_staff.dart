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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StaffListPage()),
        );
      } catch (e) {
        print('Error adding staff: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add staff: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StaffListPage()),
            );
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          //
          Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          //
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Add Staff Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Enter name' : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Enter ID' : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Enter age' : null,
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: _submitStaff,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
