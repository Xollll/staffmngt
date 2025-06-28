import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'staff_creation/add_staff.dart';

class StaffListPage extends StatelessWidget {
  final staffRef = FirebaseFirestore.instance.collection('staff');

  void _deleteStaff(String id, BuildContext context) {
    staffRef.doc(id).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Deleted')));
  }

  void _editStaff(BuildContext context, DocumentSnapshot doc) {
    final nameCtrl = TextEditingController(text: doc['name']);
    final idCtrl = TextEditingController(text: doc['id']);
    final ageCtrl = TextEditingController(text: doc['age'].toString());

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Staff'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: idCtrl,
                  decoration: InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: ageCtrl,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  staffRef.doc(doc.id).update({
                    'name': nameCtrl.text,
                    'id': idCtrl.text,
                    'age': int.tryParse(ageCtrl.text) ?? 0,
                  });
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staff List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: staffRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No staff found'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final staff = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('${staff['name']} (ID: ${staff['id']})'),
                subtitle: Text('Age: ${staff['age']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editStaff(context, doc),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteStaff(doc.id, context),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddStaffPage()),
          );
        },
        icon: Icon(Icons.add),
        label: Text('Add Staff'),
        tooltip: 'Add Staff',
      ),
    );
  }
}
