import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'staff_creation/add_staff.dart';

class StaffListPage extends StatelessWidget {
  final staffRef = FirebaseFirestore.instance.collection('staff');

  void _deleteStaff(String id, BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this staff entry?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await staffRef.doc(id).delete();
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted successfully')),
                  );
                },
                child: Text('Delete'),
              ),
            ],
          ),
    );
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F6FC),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Staff List'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: staffRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'No staff found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final staff = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      staff['name'][0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    '${staff['name']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${staff['id']} | Age: ${staff['age']}'),
                  trailing: Wrap(
                    spacing: 8,
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
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => AddStaffPage(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        backgroundColor: Colors.teal,
        icon: Icon(Icons.add),
        label: Text('Add Staff'),
        tooltip: 'Add Staff',
      ),
    );
  }
}
